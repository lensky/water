(in-package #:water)

(defmacro with-gensyms (symbols &body body)
  `(let ,(loop for sym in symbols
              collect (list sym '(gensym))) ,@body))

(defmacro eval-once (symbols &body body)
  (let ((val-syms (loop repeat (length symbols) collect (gensym)))
        (sym-syms (loop repeat (length symbols) collect (gensym))))
    `(let* ,(mapcar #'list val-syms symbols)
       (let ,(mapcar #'(lambda (x y) `(,x ',y)) symbols sym-syms)
         `(let (,,@(loop for sym in symbols 
                      for val in val-syms
                      collect ``(,,sym ,,val)))
            ,,@body)))))
