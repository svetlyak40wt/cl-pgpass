(in-package :cl-user)
(defpackage pgpass.postmodern
  (:use :cl)
  (:export #:connect
           #:get-spec)
  (:import-from #:pgpass
                #:parse-file))
(in-package :pgpass.postmodern)


#+pgpass.features:postmodern
(defmacro connect (dbname user host &key (port 5432) pooled-p (use-ssl :yes))
  (let ((get-password (gensym))
        (pass (gensym)))
    `(let* ((,get-password (parse-file))
           (,pass (funcall ,get-password :host ,host :port ,port :user ,user :dbname ,dbname)))
      (postmodern:connect ,dbname ,user ,pass ,host :port ,port :pooled-p ,pooled-p :use-ssl ,use-ssl))))


#-pgpass.features:postmodern
(defmacro connect (&rest args)
  (declare (ignore args))
  (error "Please, load \"Postmodern\" library and reload pgpass with \"force\" key (asdf:load-system 'pgpass :force t)."))


(defun get-spec (dbname user host &key (port 5432) pooled-p (use-ssl :yes))
  "Returns spec list to use with postmodern:with-connection macro."
  
  (let* ((get-password (parse-file))
         (pass (funcall get-password
                        :host host
                        :port port
                        :user user
                        :dbname dbname)))
    (list dbname user pass host :port port :pooled-p pooled-p :use-ssl use-ssl)))
