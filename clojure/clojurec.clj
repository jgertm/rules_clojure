(ns clojurec
  (:require [clojure.pprint :refer [pprint]]
            [clojure.string :as str]
            [clojure.tools.namespace.parse :refer [deps-from-ns-decl]]
            [clojure.tools.namespace.file :refer [read-file-ns-decl]]
            [clojure.java.io :as io]))

(defn -main [& {:strs [outpath package name file]}]
  (let [deps (-> file io/file read-file-ns-decl deps-from-ns-decl)
        ns (symbol (str/join "." [package name]))]
    (binding [*compile-path* outpath
              *compiler-options* {:direct-linking true}
              *compile-files* true]
      (run! require deps)
      (require ns)
      (compile ns))))
