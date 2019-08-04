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


