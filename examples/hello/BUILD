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

clojure_ns(
    name = "nrepl-server",
    deps = [
        "@maven//:cider_cider_nrepl",
        "@maven//:com_cemerick_pomegranate",
        "@maven//:me_raynes_fs",
        "@maven//:compliment_compliment",
    ],
    src = "nrepl_server.clj",
    
)

# Since the bare repl does not depend on project sources, you have to run it from the correct directory
clojure_binary(
    name = "bare_repl",
    deps = [":nrepl-server"],
    main_class = "hello.nrepl_server",
    repl = True,
)

clojure_binary(
    name = "repl",
    deps = [
        ":nrepl-server",
        ":core"
    ],
    main_class = "hello.nrepl_server",
    repl = True,
)


