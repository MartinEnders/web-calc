;;;; web-calc.asd

(asdf:defsystem #:web-calc
  :serial t
  :description "Describe web-calc here"
  :author "Martin R. Enders"
  :license "Specify license here"
  :depends-on (#:hunchentoot #:parse-number)
  :components ((:file "web-calc")))

