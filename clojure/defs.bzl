def _impl(ctx):
    ctx.actions.run(
        mnemonic = "clojurec",
        executable = "java",
        arguments = [
            "-cp", ":".join([".", ctx.bin_dir.path] + [jar.path for jar in ctx.files._clojure_jars]),
            "clojure.main",
            "-i", ctx.file._clojurec.path, "-m", "clojurec",
            "outpath", ctx.bin_dir.path,
            "package", ctx.label.package,
            "name", ctx.label.name,
            "file", ctx.file.src.path,
        ],
        inputs = [ctx.file.src]
                 + ctx.files.deps
                 + ctx.files._clojure_jars
                 + ctx.files._jdk
                 + ctx.files._clojurec,
        outputs = [ctx.outputs.classfile],
    )

clojure_ns = rule(
    implementation = _impl,
    attrs = {
        "src": attr.label(
            allow_single_file = [".clj"],
            mandatory = True,
        ),
        "deps": attr.label_list(
            allow_files = [".clj", ".class"],
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
        "_jdk": attr.label(
            default = Label("//tools/defaults:jdk"),
        ),
    },
    outputs = {
        "classfile": "%{name}.class"
    },
)
