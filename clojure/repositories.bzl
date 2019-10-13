clojure_jar = "https://repo1.maven.org/maven2/org/clojure/clojure/1.10.0/clojure-1.10.0.jar"
spec_jar = "http://central.maven.org/maven2/org/clojure/spec.alpha/0.2.176/spec.alpha-0.2.176.jar"
core_specs_jar = "http://central.maven.org/maven2/org/clojure/core.specs.alpha/0.2.44/core.specs.alpha-0.2.44.jar"

def rules_clojure_dependencies():
    native.maven_jar(
        name = "org_clojure",
        artifact = "org.clojure:clojure:1.10.0",
        
    )
    native.maven_jar(
        name = "org_clojure_spec_alpha",
        artifact = "org.clojure:spec.alpha:0.2.176",
    )
    native.maven_jar(
        name = "org_clojure_core_specs_alpha",
        artifact = "org.clojure:core.specs.alpha:0.2.44",
    )
    native.maven_jar(
        name = "org_clojure_tools_namespace",
        artifact = "org.clojure:tools.namespace:0.3.1",
        sha256 = "542f85ce618d29a63ecd902c60c0d13e41dc4a651dbb8e7dc73871b963768297",
    )
    native.maven_jar(
        name = "org_clojure_tools_reader",
        artifact = "org.clojure:tools.reader:1.3.2",
        sha256 = "13b7536d7903753fb026f5471930e2ee7cb55e187a9e1411e7572b9b9e876980",
    )
