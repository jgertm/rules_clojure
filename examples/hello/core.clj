(ns hello.core
  (:gen-class)
  (:require
   [hello.library :as lib]
   [hello.macros :as m]))

(defn -main
  [& args]
  (println "hello")
  (println lib/greeting)
  (println (m/my-macro :a :B :c :D)))
