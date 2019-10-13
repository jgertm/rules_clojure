load('@rules_clojure//clojure:defs.bzl', 'clojure_ns')

clojure_ns(
    name = "library",
    src = "library.clj",
)

clojure_ns(
    name = "core",
    src = "core.clj",
    deps = [":library"],
)

