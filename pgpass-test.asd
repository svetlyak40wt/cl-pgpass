#|
  This file is a part of pgpass project.
  Copyright (c) 2016 Alexander Artemenko (svetlyak.40wt@gmail.com)
|#

(in-package :cl-user)
(defpackage pgpass-test-asd
  (:use :cl :asdf))
(in-package :pgpass-test-asd)

(defsystem pgpass-test
  :author "Alexander Artemenko"
  :license "BSD"
  :depends-on (:pgpass
               :prove)
  :components ((:module "t"
                :components
                ((:test-file "pgpass"))))
  :description "Test system for pgpass"

  :defsystem-depends-on (:prove-asdf)
  :perform (test-op :after (op c)
                    (funcall (intern #.(string :run-test-system) :prove-asdf) c)
                    (asdf:clear-system c)))
