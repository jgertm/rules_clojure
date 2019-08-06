load('@rules_clojure//clojure:defs.bzl', 'clojure_ns')

clojure_ns(
    name = "aux",
    src = "aux.clj",
)

clojure_ns(
    name = "core",
    src = "core.clj",
    deps = [":aux"],
)

