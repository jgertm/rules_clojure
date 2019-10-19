(ns hello.macros)

(println "compiling macro ns")

(defmacro my-macro
  [& body]
  (prn 'running-macro (System/currentTimeMillis) body)
  `(hash-map ~@body))
