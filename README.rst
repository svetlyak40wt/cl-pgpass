=====================================================
 Pgpass - utility to store your Postgres file safely
=====================================================

Pgpass parses
`PostgreSQL's credential files <https://www.postgresql.org/docs/9.4/static/libpq-pgpass.html>`_
and returns passwords for given ``host/port/user/dbname``.


Usage
=====

.. code-block:: lisp
   (let ((postmodern:*database*
            (pgpass-postmodern:connect
               "db_ro_local"
               "proj"
               "pg.40ants.com"
               :port 12000
               :pooled-p t)))
               
           (postmodern:query "SELECT COUNT(*) FROM users")
           ...)

Under the hood ``pgpass-postmodern:connect`` is a macro which will use
``pgpass:parse-file`` to read credentials from the file pointed to by
``PGPASSFILE`` or from ``~/.pgpass``. You can also call ``pgpass:parse-file``
manually and it will return a closure to be called to retrive a password
for given ``host/port/user/dbname``.


Installation
============


This library is not in the quicklisp yet, so::

  git clone https://github.com/svetlyak40wt/cl-pgpass ~/common-lisp/pgpass
  (ql:quickload 'pgpass)


Caveats
=======

This library does not understand escaped ``:`` and ``\`` in credentials and
does not check that file has ``0600`` permissions.


Author
======

* Alexander Artemenko

License
=======

Licensed under the BSD License.
