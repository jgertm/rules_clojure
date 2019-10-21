(ns clojurec
  (:require [clojure.pprint :refer [pprint]]
            [clojure.string :as str]
            [clojure.tools.namespace.parse :refer [deps-from-ns-decl]]
            [clojure.tools.namespace.file :refer [read-file-ns-decl]]
            [clojure.java.io :as io])
  (:import [java.io File]
           [java.util.jar JarEntry Manifest Attributes Attributes$Name JarOutputStream]))

(defn produce-jar
  [^File root ^File output-jar]
  (let [root-path (.toPath root)
        manifest (Manifest.)]
    (.put (.getMainAttributes manifest) Attributes$Name/MANIFEST_VERSION, "1.0")
    (with-open [jos (JarOutputStream. (io/output-stream output-jar))]
      ;; skip the first item in the file-seq, ie the root itself
      (doseq [^File f (rest (file-seq root))]
        (let [name (-> root-path
                       (.relativize (.toPath f))
                       (str)
                       (.replace "\\" "/"))
              entry (JarEntry. name)]
          
          (.setTime entry 4481049600000) ; 2112/1/1
          (.putNextEntry jos entry)
          
          (when-not (.isDirectory f)
            (io/copy f jos))
          
          (.closeEntry jos))))))

(defn -main [& {:strs [outpath package name file output-jar]}]
  (let [deps (-> file io/file read-file-ns-decl deps-from-ns-decl)
        ns (symbol (str/join "." [package name]))]
    (binding [*compile-path* outpath
              *compiler-options* {:direct-linking true}
              *compile-files* true]
      (compile ns))
    (produce-jar (io/file outpath) (io/file output-jar))))
