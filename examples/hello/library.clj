(ns hello.library
  (:require
   [hello.macros :as m]))

(def greeting "a greeting 299")

(def macro-call (m/my-macro :some :stuff))
