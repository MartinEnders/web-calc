# web-calc 

based on Hunchentoot

## API

```cl
(web-calc:with-web-calc ([uri] [list-of-variables]) [body])
```

[uri]: Path for publishing e.g. "/web-calc-test"

[list-of-variables]: For these Variables are HTML-Form fields generated and can be accesd in [body] after submit.

[body]: Create output based on the variables

```cl
(web-calc:to-number ([object] &optional [retrun-nil-when-conversion-not-possible nil])
```

[object]: Lisp object

[return-nil-when-conversion-not-possible] (default nil): if nil return number when conversion is possible otherwise return object, if true return number when conversion is possible otherwise return nil


## Implementation
Developed on Debian GNU/Linux with Emacs and Slime on SBCL.

(I've not tested anything in other environments.)

## Example
Load web-calc and run (web-calc:test)


Testfunction (with parameter for the Hunchentootobject):
```cl
(defparameter *test-server* nil)
(defun test ()
  (unless *test-server*
    (print "Start Hunchentoot Webserver on Port 10000")
    (setf *test-server* (make-instance 'hunchentoot:easy-acceptor :port 10000))
    (hunchentoot:start *test-server*))
  
  (print "Create web-calc for localhost:10000/add")
  (with-web-calc ("/add" (number-1 number-2))
    (let ((n1 (to-number number-1 t))
	  (n2 (to-number number-2 t)))
      (if (and n1 n2)
	  (format nil "Result: ~A" (+ n1 n2))
	  (format nil "Please insert values.")))))
```


