#|
  This file is a part of pgpass project.
  Copyright (c) 2016 Alexander Artemenko (svetlyak.40wt@gmail.com)
|#

#|
  Author: Alexander Artemenko (svetlyak.40wt@gmail.com)
|#

(in-package :cl-user)
(defpackage pgpass-asd
  (:use :cl :asdf))
(in-package :pgpass-asd)


(defsystem pgpass
  :version "0.3.0"
  :author "Alexander Artemenko"
  :license "BSD"
  :depends-on (:split-sequence
               :alexandria)
  :components ((:module "src"
                :components
                ((:file "features")
                 (:file "pgpass")
                 (:file "postmodern"))))
  :description ""
  :long-description
  #.(with-open-file (stream (merge-pathnames
                             #p"README.rst"
                             (or *load-pathname* *compile-file-pathname*))
                            :if-does-not-exist nil
                            :direction :input)
      (when stream
        (let ((seq (make-array (file-length stream)
                               :element-type 'character
                               :fill-pointer t)))
          (setf (fill-pointer seq) (read-sequence seq stream))
          seq)))
  :in-order-to ((test-op (test-op pgpass-test))))
