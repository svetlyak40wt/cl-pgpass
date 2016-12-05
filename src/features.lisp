(defpackage pgpass.features
  (:use #:cl)
  (:export #:postmodern))
(in-package :pgpass.features)


(eval-when (:compile-toplevel :load-toplevel)
  (when (find-package 'postmodern)
    (pushnew 'postmodern *features*)))
