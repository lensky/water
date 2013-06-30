(asdf:defsystem water
  :description "water: essential utility functions for common lisp."
  :version "0.3"
  :author "YL"
  :components ((:file "packages")
               (:file "macro" :depends-on ("packages"))
               (:file "sequence" :depends-on ("macro"))
               (:file "control" :depends-on ("macro"))
               (:file "function" :depends-on ("macro"))
               (:file "generic-comp" :depends-on ("macro"))))
