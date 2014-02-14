;;;; web-calc.lisp
(defpackage #:web-calc
  (:use #:cl)
  (:export #:with-web-calc
	   #:test))


(in-package #:web-calc)

;;; "web-calc" goes here. Hacks and glory await!



(defun make-html-form (parameter &key (action-uri "") (method "POST"))
  (with-output-to-string (s)
    (format s "<form action='~A' method='~A'>~%" action-uri method)
    (format s "~{  <div>~A: <input type='text' name='~:*~(~A~)'></div>~%~}~%" parameter)
    (format s "  <div><input type='submit' value='submit'>~%")
    (format s "</form>~%")))

(defun to-number (object &optional (retrun-nil-when-conversion-not-possible nil))
  "Convert to number if possible.
If conversion is not possible check 
  retrun-nil-when-conversion-not-possible=nil => return object
  retrun-nil-when-conversion-not-possible=t   => return nil"
  (let ((obj (format nil "~A" object)))
    (handler-case
	(parse-number:parse-number obj)
      (error (e) 
	(declare (ignore e))
	(if retrun-nil-when-conversion-not-possible
	    nil
	    object)))))


(defmacro with-web-calc ((path parameter-list) &body body)
  (let ((function-name (intern (string-upcase path)))
	(result (gensym)))
    `(hunchentoot:define-easy-handler (,function-name :uri ,path) ,parameter-list
       (let ((,result ,@body))
	 (format nil "<html><head><title>test</title></head><body><div id='result'>~A</div><div id='form'>~A</div></body></html>" ,result (make-html-form ',parameter-list))))))
       
    
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