(in-package :cl-user)
(defpackage pgpass
  (:use :cl)
  (:export #:parse
           #:parse-file))
(in-package :pgpass)


(defun to-string (value)
  (when value
    (format nil "~a" value)))


(defun parse-line (line)
  "Parses a line in PGPASSFILE format and returns a function
which is able to accept keyword arguments and returns a password or nil"
  
  (let ((wildcard "*")
        (line-parts (split-sequence:split-sequence #\: line)))
    (destructuring-bind (lhost lport ldbname luser pass)
        line-parts
      
     (lambda (&key host port dbname user)
       (when (and (or
                   (equal lhost wildcard)
                   (equal lhost host))
                  (or
                   (equal lport wildcard)
                   (equal lport (to-string port)))
                  (or
                   (equal luser wildcard)
                   (equal luser user))
                  (or
                   (equal ldbname wildcard)
                   (equal ldbname dbname)))
         pass)))))


(defun parse (text-with-rules)
  (let* ((lines (split-sequence:split-sequence
                 #\Newline
                 text-with-rules))
         (lines (remove-if
                 (lambda (line)
                   (zerop (length
                           (string-trim " " line))))
                 lines))
         (matchers (mapcar #'parse-line lines)))
    
    (lambda (&key host port dbname user)
      (loop
         :with result = nil
         :for matcher :in matchers
         :do (setf result (funcall matcher
                                   :host host
                                   :port port
                                   :dbname dbname
                                   :user user))
         :when result
         :return result))))


(defun parse-file (&optional filename)
  "Reads PGPASS database from a file.

If filename wasn't specified, then it searches it in PGPASSFILE
environement variable or in the ~/.pgpass"
  (unless filename
    (setf filename (uiop:getenv "PGPASSFILE")))
  
  ;; if it wasn't set with env variable, then will search in the home dir
  (unless filename
    (setf filename (probe-file #P"~/.pgpass"))
    
    ;; if file not found, probe-file will return nil
    (unless filename
      (error "Unable to find ~/.pgpass")))
  
  (let ((content (alexandria:read-file-into-string filename)))
    (parse content)))


