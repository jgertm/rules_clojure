
def _impl(ctx):
    toolchain = ctx.toolchains["@rules_clojure//:toolchain"]

    deps = depset(
        direct = toolchain.files.clojure_jars,
        transitive = [dep[JavaInfo].transitive_runtime_jars for dep in ctx.attr.deps],
    )


    class_dir = ctx.actions.declare_directory(ctx.label.name + "/classes")
    jar = ctx.actions.declare_file(ctx.label.name + ".jar")
    args = ctx.actions.args()
    args.add("-cp")
    args.add_joined(
        deps, 
        join_with = ctx.configuration.host_path_separator,
        format_joined = "%s{}.".format(ctx.configuration.host_path_separator),
    )
    args.add("clojure.main")
    args.add("-i", toolchain.bin.clojurec.path)
    args.add("-m", "clojurec")
    args.add("outpath", class_dir.path)
    args.add("package", ctx.label.package)
    args.add("name", ctx.label.name)
    args.add("file", ctx.file.src.path)
    args.add("output-jar", jar.path)

    ctx.actions.run(
        mnemonic = "clojurec",
        executable = toolchain.java,
        arguments = [args],
        inputs = depset(
            direct = [ctx.file.src, toolchain.bin.clojurec],
            transitive = [deps, toolchain.files.all]
        ),
        outputs = [class_dir, jar],
    )

    return [
        DefaultInfo(
            files = depset([class_dir, jar]),
        ),
        JavaInfo(
            output_jar = jar,
            compile_jar = jar,
            deps = [dep[JavaInfo] for dep in ctx.attr.deps]
        ),
    ]

clojure_ns = rule(
    implementation = _impl,
    attrs = {
        "src": attr.label(
            allow_single_file = [".clj"],
            mandatory = True,
        ),
        "deps": attr.label_list(
            default = [],
        ),
    },
    toolchains = ["@rules_clojure//:toolchain"],
)

def merge_jars(ctx, input_jars, output_jar, main_class = None, progress_message = None):
    args = ctx.actions.args()
    args.add_all(["--compression", "--normalize", "--sources"])
    args.add_all(input_jars)
    if main_class:
        args.add("--main_class", main_class)
    args.add("--output", output_jar.path)

    ctx.actions.run(
        inputs = input_jars,
        outputs = [output_jar],
        executable = ctx.executable._singlejar,
        mnemonic = "MergeJars",
        progress_message = progress_message,
        arguments = [args],
    )

def _clojure_binary_jar_impl(ctx):
    toolchain = ctx.toolchains["@rules_clojure//:toolchain"]

    output_jar = ctx.actions.declare_file(ctx.label.name)
    jars = depset(
        direct = toolchain.files.clojure_jars,
        transitive = [d[JavaInfo].transitive_runtime_jars for d in ctx.attr.deps],
    )

    merge_jars(ctx, jars, output_jar, main_class = ctx.attr.main_class)

    return [
        DefaultInfo(
            files = depset([output_jar]),
        )
    ]

clojure_binary_jar = rule(
    implementation = _clojure_binary_jar_impl,
    toolchains = ["@rules_clojure//:toolchain"],
    attrs = {
        "deps": attr.label_list(providers = [JavaInfo]),
        "main_class": attr.string(),
        "_singlejar": attr.label(
            executable = True,
            cfg = "host",
            default = Label("@bazel_tools//tools/jdk:singlejar"),
            allow_files = True,
        ),
    }
)

def _clojure_binary_runner_impl(ctx):
    runner = ctx.actions.declare_file(ctx.label.name)
    jar_rlocation = "$(rlocation {workspace}/{jar})".format(
        workspace = ctx.workspace_name,
        jar = ctx.file.jar.short_path
    )

    classpath_items = [jar_rlocation]
    if ctx.attr.for_repl:
        classpath_items += ["."]

    ctx.actions.expand_template(
        template = ctx.file._template,
        output = runner,
        substitutions = {
            "%prolog%": "cd $BUILD_WORKING_DIRECTORY" if ctx.attr.for_repl else "",
            "%classpath%": ctx.configuration.host_path_separator.join(classpath_items),
            "%main_class%": ctx.attr.main_class,
        },
        is_executable = True,
    )

    return [
        DefaultInfo(
            files = depset([runner]),
            runfiles = ctx.runfiles(files = ctx.files.jar),
        ),
    ]

clojure_binary_runner = rule(
    implementation = _clojure_binary_runner_impl,
    attrs = {
        "jar": attr.label(allow_single_file = True),
        "main_class": attr.string(),
        "for_repl": attr.bool(
            default = False,
            doc = """
            REPL binaries run from the build workspace directory, and
            have source code properly accessible on the classpath.
            """,
        ),
        "_template": attr.label(
            allow_single_file = True,
            default = "clojure_binary_runner.template",
        )
    }
)

def clojure_binary(name = None,
                   deps = [],
                   main_class = None,
                   repl = False):
    jar = name + ".jar"
    runner = name + "_runner"
    clojure_binary_jar(
        name = jar,
        deps = deps,
        main_class = main_class
    )
    clojure_binary_runner(
        name = runner,
        jar = jar,
        main_class = main_class,
        for_repl = repl,
    )

    native.sh_binary(
        name = name,
        srcs = [runner],
        data = [jar],
        deps = ["@bazel_tools//tools/bash/runfiles"],
        visibility = ["//visibility:public"],
    )
