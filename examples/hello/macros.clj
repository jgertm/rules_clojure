(ns hello.macros)

;; Change me: 1

(defmacro my-macro
  [& body]
  (let [t (System/currentTimeMillis)]
    (prn 'running-macro t  body)
    (vector t `(hash-map ~@body))))
