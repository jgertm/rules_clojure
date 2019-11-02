(ns hello.core
  (:require
   [hello.library :as lib]
   [hello.macros :as m])
  (:gen-class))

(defn -main
  [& args]
  (println "hello")
  (println lib/greeting)
  (println (m/my-macro :a :B :c :D)))

