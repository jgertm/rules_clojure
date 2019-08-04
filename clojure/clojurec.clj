(ns clojurec
  (:require [clojure.pprint :refer [pprint]]
            [clojure.string :as str]))

(defn -main [& {:strs [outpath package name]}]
  (let [ns (symbol (str/join "." [package name]))]
    (binding [*compile-path* outpath]
      (require ns)
      (compile ns))))
