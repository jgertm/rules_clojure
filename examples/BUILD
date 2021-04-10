load("@rules_clojure//:toolchains.bzl", "clojure_toolchain")

clojure_toolchain(
    name = "clojure_toolchain_def",
    clojure_jars = [
        "@maven//:org_clojure_clojure",
        "@maven//:org_clojure_core_specs_alpha",
        "@maven//:org_clojure_spec_alpha",
        "@maven//:org_clojure_tools_namespace",
        "@maven//:org_clojure_tools_reader",
    ],
)

toolchain(
    name = "clojure_toolchain",
    toolchain = ":clojure_toolchain_def",
    toolchain_type = "@rules_clojure//:toolchain",
)
