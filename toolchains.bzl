def _impl(ctx):
    return [
        platform_common.ToolchainInfo(
            clojure_jars = ctx.attr.clojure_jars,
            jdk = ctx.attr._jdk,
            java_home = ctx.attr._jdk[java_common.JavaRuntimeInfo].java_home,
            java = ctx.attr._jdk[java_common.JavaRuntimeInfo].java_executable_exec_path,
            java_runfiles = ctx.attr._jdk[java_common.JavaRuntimeInfo].java_executable_runfiles_path,
            files = struct(
                clojure_jars = ctx.files.clojure_jars,
                jdk = ctx.files._jdk,
                all = depset(ctx.files._jdk + ctx.files.clojure_jars)
            ),
            bin = struct(
                clojurec = ctx.file._clojurec
            )
        )]

clojure_toolchain = rule(
    implementation = _impl,
    attrs = {
        "clojure_jars": attr.label_list(
            doc = "List of JavaInfo dependencies which will be implictly added to library/repl/test/binary classpath. Must contain clojure.jar",
            providers = [JavaInfo],
        ),
        "_clojurec": attr.label(
            default = "//clojure:clojurec.clj",
            allow_single_file = True,
        ),
        "_jdk": attr.label(
            default = "@bazel_tools//tools/jdk:current_java_runtime",
            providers = [java_common.JavaRuntimeInfo],
        ),
    },
    provides = [platform_common.ToolchainInfo],
)
