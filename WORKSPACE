workspace(name = "rules_clojure")

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive", "http_file")

skylib_version = "0.8.0"

http_archive(
    name = "bazel_skylib",
    type = "tar.gz",
    url = "https://github.com/bazelbuild/bazel-skylib/releases/download/{}/bazel-skylib.{}.tar.gz".format (skylib_version, skylib_version),
    sha256 = "2ef429f5d7ce7111263289644d233707dba35e39696377ebab8b0bc701f7818e",
)
