(defpackage #:water.macro
  (:use #:cl)
  (:export :with-gensyms
           :eval-once))

(defpackage #:water.function
  (:use #:cl)
  (:export :compose
           :constant
           :flip
           :mappend
           :map-functions
           :extract-args
           :memoized-fn
           :*memoized-test-key*
           :*memoized-parameter-symbol*
           :memoize-fn
           :defun-memo))

(defpackage #:water.collection
  (:use #:cl #:water.function)
  (:export :split-seq-on-seq
           :split-seq-on-elt
           :split-seq-on-fn
           :split-seq-on-elts
           :map-over-hash-values
           :hash-values
           :hash-keys
           :hash-alist
           :remove-items
           :delete-items
           :repeat-element))

(use-package '(#:water.collection) '#:water.function)

(defpackage #:water.control
  (:use #:cl)
  (:export :generic-case))

(defpackage #:water.g/=
  (:use #:cl)
  (:export :g/=
           :g/=-bin))
