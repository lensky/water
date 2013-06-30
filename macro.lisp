(in-package #:water)

(defmacro with-gensyms (symbols &body body)
  `(let ,(loop for sym in symbols
              collect (list sym '(gensym))) ,@body))
