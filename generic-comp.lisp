(in-package #:water.g/=)

(defgeneric g/=-bin (x y)
  (:documentation "Generic binary equal comparator."))

(defun g/= (&rest operands)
  (reduce #'g/=-bin operands))

(defmethod g/=-bin (x y)
  (equalp x y))

(defmethod g/=-bin ((x string) (y string))
  (string-equal x y))

(defmethod g/=-bin ((x number) (y number))
  (= x y))

(defmethod g/=-bin ((x character) (y character))
  (char-equal x y))

(defmethod g/=-bin ((x sequence) (y sequence))
  (every #'g/= x y))
