(ns hello.core
  (:require
   [hello.library :as lib]
   [hello.macros :as m])
  (:gen-class))

(defn -main
  [& args]
  (println "hello core 1")
  (println lib/greeting)
  ;; Toggle between these and change stuff to see what happens
  (println lib/macro-call)
  (println (m/my-macro :a :B :c :D)))
