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
        format_joined = ".{}%s".format(_CLASSPATH_SEPARATOR),
    )
    args.add("clojure.main")
    args.add("-i", ctx.file._clojurec.path)
    args.add("-m", "clojurec")
    args.add("outpath", class_dir.path)
    args.add("package", ctx.label.package)
    args.add("name", ctx.label.name)
    args.add("file", ctx.file.src.path)
    args.add("output-jar", jar.path)

    print("ARGS", args)
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
            deps = [dep[JavaInfo] for dep in ctx.attr.deps],
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
