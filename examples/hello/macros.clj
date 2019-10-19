(ns hello.macros)

(defmacro my-macro
  [& body]
  (prn 'running-macro (System/currentTimeMillis) body)
  `(hash-map ~@body))
