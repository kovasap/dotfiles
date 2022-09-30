#!/usr/bin/env bb

(require '[clojure.java.io]
         '[clojure.java.shell :refer [sh]]
         '[clojure.tools.cli :refer [parse-opts]])

(def cli-options
  ;; An option with a required argument
  [["-o" "--offset NUM" "Offset to add to each track number."
    :default 0
    :parse-fn #(Integer/parseInt %)]
   ["-h" "--help"]])

(defn file->track-num
  [filename]
  (Integer/parseInt (last (re-matches #"[^\d]*(\d+).*" filename))))

(file->track-num
  "./(15_51) Nudge_ Improving Decisions About Health, Wealth, and Hap - Richard H. Thaler, Cass R. Sunstein.mp3")

(def directory (clojure.java.io/file "."))
(def files (sort-by #(.getName %) (file-seq directory)))

(def offset (:offset (:options (parse-opts *command-line-args* cli-options))))

(doseq [file (filter #(not (.isDirectory %)) (file-seq directory))]
  (let [track (+ offset (file->track-num (.getName file)))]
    (prn (sh "id3tool" (.getName file)))
    (prn (sh "id3tool" (str "--set-track=" track) (.getName file)))))
