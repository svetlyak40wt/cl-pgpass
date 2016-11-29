(in-package :cl-user)
(defpackage pgpass-test
  (:use :cl
        :pgpass
        :prove))
(in-package :pgpass-test)

;; NOTE: To run this test file, execute `(asdf:test-system :pgpass)' in your Lisp.

(plan nil)

(subtest
    "Check line matcher without wildcards"
  (let ((get-pgpass (pgpass::parse-line "the-host:6432:somedb:the-user:foo-pass")))
    
    (subtest
        "Simple match"
      (is (funcall get-pgpass
                   :host "the-host"
                   :port "6432"
                   :dbname "somedb"
                   :user "the-user")
          "foo-pass"))
    
    (subtest
        "Mismatch should result nil"
      (is (funcall get-pgpass
                   :host "unknown-host"
                   :port "6432"
                   :dbname "somedb"
                   :user "the-user")
          nil))
    
    (subtest
        "Integer as a port number should work too"
      (is (funcall get-pgpass
                   :host "the-host"
                   :port 6432
                   :dbname "somedb"
                   :user "the-user")
          "foo-pass"))))


(subtest
    "Check line matcher with all wildcards"
  (let ((get-pgpass (pgpass::parse-line "*:*:*:*:blah-pass")))
    
    (subtest
        "Any parameters should match"
      (is (funcall get-pgpass
                   :host "the-host"
                   :port "6432"
                   :dbname "somedb"
                   :user "the-user")
          "blah-pass")
      (is (funcall get-pgpass
                   :host "another-host"
                   :port 12000
                   :dbname "otherdb"
                   :user "other-user")
          "blah-pass"))))


(subtest
    "Check line matcher with some wildcards"
  (let ((get-pgpass (pgpass::parse-line "my-host:6432:*:my-user:the-pass")))
    
    (subtest
        "Database name can vary"
      (is (funcall get-pgpass
                   :host "my-host"
                   :port 6432
                   :dbname "db-one"
                   :user "my-user")
          "the-pass")
      (is (funcall get-pgpass
                   :host "my-host"
                   :port 6432
                   :dbname "db-two"
                   :user "my-user")
          "the-pass"))
    
    (subtest
        "But host is not"
      (is (funcall get-pgpass
                   :host "other-host"
                   :port 6432
                   :dbname "db-one"
                   :user "my-user")
          nil))

    (subtest
        "But port is not"
      (is (funcall get-pgpass
                   :host "my-host"
                   :port 12000
                   :dbname "db-one"
                   :user "my-user")
          nil))

    (subtest
        "And user is not"
      (is (funcall get-pgpass
                   :host "my-host"
                   :port 6432
                   :dbname "db-one"
                   :user "other-user")
          nil))))


(subtest
    "Check few rules"
  (let ((get-pgpass (pgpass:parse "
my-host:6432:*:my-user:the-pass
*:6432:*:my-user:second-pass
*:*:*:my-user:third-pass
")))
    
    (subtest
        "First row matches"
      (is (funcall get-pgpass
                   :host "my-host"
                   :port 6432
                   :dbname "db-one"
                   :user "my-user")
          "the-pass")
      (is (funcall get-pgpass
                   :host "my-host"
                   :port 6432
                   :dbname "db-two"
                   :user "my-user")
          "the-pass"))

    (subtest
        "Second row matches"
      (is (funcall get-pgpass
                   :host "any-host"
                   :port 6432
                   :dbname "any-db"
                   :user "my-user")
          "second-pass"))
    
    (subtest
        "If first two lines don't match, then third does"
      (is (funcall get-pgpass
                   :host "my-host"
                   :port 12000
                   :dbname "db-two"
                   :user "my-user")
          "third-pass"))
    
    (subtest
        "If nothing match, then NIL is returned"
      (is (funcall get-pgpass
                   :host "my-host"
                   :port 12000
                   :dbname "db-two"
                   :user "unknown-user")
          nil))
    ))

(finalize)
