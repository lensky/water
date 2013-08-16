(asdf:defsystem water
  :description "water: essential utility functions for common lisp."
  :version "0.3"
  :author "YL"
  :depends-on (:iterate)
  :serial t
  :components ((:file "packages")
               (:file "macro")
               (:file "collection")
               (:file "control")
               (:file "function")
               (:file "generic-comp")))
