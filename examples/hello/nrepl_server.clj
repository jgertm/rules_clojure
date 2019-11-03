(ns hello.nrepl-server
  (:require
   [nrepl.server :as nrepl-server]
   [clojure.main :as main])
  (:gen-class))

(defn nrepl-handler []
  (require 'cider.nrepl)
  (ns-resolve 'cider.nrepl 'cider-nrepl-handler))

(defn -main []
  (let [{:keys [port]} (nrepl-server/start-server
                        :handler (nrepl-handler))]
    (spit ".nrepl-port" port)
    (println "started nrepl server on port" port)
    (main/main)))
