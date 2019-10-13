(ns hello.core
  (:gen-class)
  (:require [hello.library :as lib]))

(defn -main
  [& args]
  (println "hello")
  (println lib/greeting))
