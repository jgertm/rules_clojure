(ns hello.library
  (:require
   [hello.macros :as m]))

(def greeting "a greeting 2")

(def macro-call (m/my-macro :some :stuff))
