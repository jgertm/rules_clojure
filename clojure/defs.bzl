# ; on windows, : on linux...
_CLASSPATH_SEPARATOR = ";"

def _impl(ctx):
    class_dir = ctx.actions.declare_directory(ctx.label.name + "/classes")
    jar = ctx.actions.declare_file(ctx.label.name + ".jar")
    args = ctx.actions.args()
    args.add("-cp")
    args.add_joined(
        depset(direct = ctx.files._clojure_jars,
               transitive = [dep[JavaInfo].compile_jars for dep in ctx.attr.deps]),
        join_with = _CLASSPATH_SEPARATOR,
        format_joined = "%s{}.".format(_CLASSPATH_SEPARATOR),
    )
    args.add("clojure.main")
    args.add("-i", ctx.file._clojurec.path)
    args.add("-m", "clojurec")
    args.add("outpath", class_dir.path)
    args.add("package", ctx.label.package)
    args.add("name", ctx.label.name)
    args.add("file", ctx.file.src.path)
    args.add("output-jar", jar.path)

    ctx.actions.run(
        mnemonic = "clojurec",
        executable = "java",
        arguments = [args],
        inputs = [ctx.file.src]
                 + ctx.files.deps
                 + ctx.files._clojure_jars
                 + ctx.files._clojurec,
        outputs = [class_dir, jar],
    )

    return [
        DefaultInfo(
            files = depset([class_dir, jar]),
        ),
        JavaInfo(
            output_jar = jar,
            compile_jar = jar,
            deps = [dep[JavaInfo] for dep in ctx.attr._clojure_jars + ctx.attr.deps],
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
            allow_files = [".class"],
            default = [],
        ),
        "_clojurec": attr.label(
            allow_single_file = True,
            default = "clojurec.clj",
        ),
        "_clojure_jars": attr.label_list(default=[
            Label("@org_clojure//jar"),
            Label("@org_clojure_spec_alpha//jar"),
            Label("@org_clojure_core_specs_alpha//jar"),
            Label("@org_clojure_tools_namespace//jar"),
            Label("@org_clojure_tools_reader//jar"),
        ]),
        # "_jdk": attr.label(
        #     default = Label("//tools/defaults:jdk"),
        # ),
    },
)

def merge_jars(ctx, input_jars, output_jar, main_class = "", progress_message = ""):
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

def _clojure_binary_impl(ctx):
    print("binary deps", ctx.attr.deps)
    output_jar = ctx.actions.declare_file(ctx.label.name)
    jars = depset(transitive = [d[JavaInfo].transitive_runtime_jars for d in ctx.attr.deps])

    merge_jars(ctx, jars, output_jar, main_class = ctx.attr.main_class)

    return [
        DefaultInfo(
            files = depset([output_jar]),
        )
    ]

clojure_binary_jar = rule(
    implementation = _clojure_binary_impl,
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
    ctx.actions.expand_template(
        template = ctx.file._template,
        output = runner,
        substitutions = {
            "%jar%": "$(rlocation {workspace}/{jar})".format(
                workspace = ctx.workspace_name,
                jar = ctx.file.jar.short_path
            ),
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
        "_template": attr.label(
            allow_single_file = True,
            default = "clojure_binary_runner.template",
        )
    }
)

def clojure_binary(name = None, **kwargs):
    jar = name + ".jar"
    runner = name + "_runner"
    clojure_binary_jar(name = jar, **kwargs)
    clojure_binary_runner(name = runner, jar = jar)

    native.sh_binary(
        name = name,
        srcs = [runner],
        data = [jar],
        deps = ["@bazel_tools//tools/bash/runfiles"],
        visibility = ["//visibility:public"],
    )
