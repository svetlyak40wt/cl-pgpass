(in-package :cl-user)
(defpackage pgpass-postmodern
  (:use :cl)
  (:export #:connect)
  (:import-from #:pgpass
                #:parse-file))
(in-package :pgpass-postmodern)


(defmacro connect (dbname user host &key (port 5432) pooled-p (use-ssl :yes))
  (let ((get-password (gensym))
        (pass (gensym)))
    `(let* ((,get-password (parse-file))
           (,pass (funcall ,get-password :host ,host :port ,port :user ,user :dbname ,dbname)))
      (postmodern:connect ,dbname ,user ,pass ,host :port ,port :pooled-p ,pooled-p :use-ssl ,use-ssl))))
