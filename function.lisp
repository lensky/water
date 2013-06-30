(in-package #:water)

(defun compose (f g) (lambda (&rest args) (funcall f (apply g args))))
(defun constant (x) (lambda (&rest args) (declare (ignorable args)) x))

(defun flip (fn) (lambda (x y) (funcall fn y x)))

(defun mappend (fn seq &rest seqs)
  (apply #'append (apply #'mapcar fn seq seqs)))

(defun map-functions (fns seq &rest seqs)
  (apply #'mapcar #'funcall fns seq seqs))

(defparameter *lambda-list-keywords* '(&optional &rest &aux &key))

(defun extract-args (arg-spec)
  "Extracts argument names from an (ordinary) lambda list."
  (mapcar (lambda (x) (if (listp x) (car x) x))
          (remove-items *lambda-list-keywords* arg-spec)))

(defun call-form-args (arg-spec)
  "Turns an (ordinary) lambda list into a call with those arguments.

   I.E. (x &key (y default-value supplied-p)) -> (x :y y)"
  (let ((grouped-args
         (split-seq-on-elts *lambda-list-keywords*
                            arg-spec
                            :include-splitter t)))
    (mappend
     (lambda (x)
       (let ((key-p (eq '&key (caar x))))
         (mappend
          (lambda (y)
            (let ((var-name (if (listp y) (car y) y)))
              (if key-p
                  (list (intern (symbol-name var-name) "KEYWORD")
                        var-name)
                  (list var-name))))
          (cdr x))))
     grouped-args)))

(defmacro memoized-fn (fn arg-spec &key memoized-args test)
  (let* ((memd-args (let ((tmp-args (or memoized-args (extract-args arg-spec))))
                      (if (< 1 (length tmp-args))
                          tmp-args
                          (car tmp-args))))
         (test-fn (or test #'equalp)))
    (with-gensyms (hash-table hash-key value present-p fn-val)
      `(let ((,hash-table (make-hash-table :test ,test-fn)))
        (lambda ,arg-spec
          (let ((,hash-key ,(if (listp memd-args)
                                `(list ,@memd-args)
                                memd-args)))
            (multiple-value-bind (,value ,present-p) (gethash ,hash-key ,hash-table)
              (if ,present-p
                  ,value
                  (let ((,fn-val (funcall ,fn ,@(call-form-args arg-spec))))
                    (setf (gethash ,hash-key ,hash-table) ,fn-val))))))))))

(defparameter *memoized-test-key* '&mem-test)
(defparameter *memoized-parameter-symbol* :memoize)

(defmacro memoize-fn (fn arg-spec &key memoized-args test)
  `(setf (symbol-function ',fn)
         (memoized-fn ,(symbol-function fn) ,arg-spec
                      :memoized-args ,memoized-args :test ,test)))

(defmacro defun-memo (name args &body body)
  (destructuring-bind (fn-args &optional (memoized-test '(#'equalp)))
      (split-seq-on-elt '&mem-test args)
    (let ((memoized-args
           (mappend (lambda (arg)
                      (if (and (listp arg)
                               (eq (car (last arg)) *memoized-parameter-symbol*))
                          (list (car arg))
                          nil))
                    fn-args))
          (defun-args
           (mapcar (lambda (arg)
                     (if (and (listp arg)
                              (eq (car (last arg)) *memoized-parameter-symbol*))
                         (butlast arg)
                         arg))
                   fn-args))
          (test (car memoized-test)))
      `(progn
         (defun ,name ,defun-args ,@body)
         (memoize-fn ,name ,defun-args
                     :memoized-args ,memoized-args :test ,test)))))
