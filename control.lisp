(in-package #:water.control)

(defmacro generic-case ((var-form &key (test '#'equal) (otherwise-key :otherwise)) &body cases)
  (let ((var (gensym)))
    `(let ((,var ,var-form))
       (cond
         ,@(loop for case in cases
                collect `(,(if (eq (car case) otherwise-key)
                              t
                              `(funcall ,test ,var ,(car case)))
                          ,@(cdr case)))))))
