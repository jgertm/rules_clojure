load("@bazel_tools//tools/build_defs/repo:jvm.bzl", "jvm_maven_import_external")

version_and_sha = {
    "clojure": struct(
        version = "1.10.0",
        sha256 = "5014094a58c0576edf82cbd64de2536511b2f70e9c17ac78c1121524eabbae38"
    ),
    "spec.alpha": struct(
        version = "0.2.176",
        sha256 = "fc4e96ecff34ddd2ab7fd050e74ae1379342ee09daa6028da52024c5de836cc4",
    ),
    "core.specs.alpha": struct(
        version = "0.2.44",
	    sha256 = "3b1ec4d6f0e8e41bf76842709083beb3b56adf3c82f9a4f174c3da74774b381c",
    ),
    "tools.namespace": struct(
        version = "0.3.1",
        sha256 = "542f85ce618d29a63ecd902c60c0d13e41dc4a651dbb8e7dc73871b963768297",
    ),
    "tools.reader": struct(
        version = "1.3.2",
        sha256 = "13b7536d7903753fb026f5471930e2ee7cb55e187a9e1411e7572b9b9e876980",
    )
}


def import_clojure_jars():
    for (name, artifact) in version_and_sha.items():
        jvm_maven_import_external(
            name = "org_clojure_" + name,
            artifact = "org.clojure:{}:{}".format(name, artifact.version),
            artifact_sha256 = artifact.sha256,
            server_urls = ["https://repo1.maven.org/maven2/"],
        )

exclusions = {
    "clojure": [
        "org.clojure:core.specs.alpha",
        "org.clojure:spec.alpha",
    ],
    "spec.alpha": [
        "org.clojure:clojure",
        "org.clojure:spec.alpha"
    ],
    "core.specs.alpha": [
        "org.clojure:clojure",
        "org.clojure:core.specs.alpha"
    ],
}

def clojure_maven_artifacts(maven):
    v =  [
        maven.artifact(
            "org.clojure",
            name,
            artifact.version,
            exclusions = exclusions[name] if name in exclusions else None
        )
        for (name, artifact) in version_and_sha.items()
    ]
    return v
        
        

def get_exclusions():
    return [
        "org.clojure:{}".format(name) for name in version_and_sha.keys()
        
    ]
