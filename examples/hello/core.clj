(ns hello.core
  (:gen-class)
  (:require [hello.aux :as aux]))

(defn -main
  [& args]
  (println aux/greeting))
