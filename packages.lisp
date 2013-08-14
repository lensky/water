(defpackage #:water
  (:use #:cl
        #:iterate)
  (:export :split-seq-on-seq
           :split-seq-on-elt
           :map-over-hash-values
           :hash-values
           :hash-keys
           :hash-alist
           :delete-items
           :repeat-element
           :generic-case
           :with-gensyms
           :eval-once
           :assign-once
           :compose
           :constant
           :flip
           :map-functions
           :mappend
           :memoized-fn
           :extract-args
           :*memoized-test-key*
           :*memoized-parameter-symbol*
           :memoize-fn
           :defun-memo
           :g/=
           :g/=-bin))
