load("@rules_clojure//clojure:defs.bzl", "clojure_ns", "clojure_binary")

clojure_ns(
    name = "library",
    src = "library.clj",
    deps = [":macros"],
)

clojure_ns(
    name = "macros",
    src = "macros.clj",
)

clojure_ns(
    name = "core",
    src = "core.clj",
    deps = [":library", ":macros"],
)

clojure_binary(
    name = "core-bin",
    deps = [":core"],
    main_class = "hello.core",
)


