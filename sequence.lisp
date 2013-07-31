(in-package #:water)

(defun split-seq-backend (seq step-incr search-fun &key (include-splitter nil))
  "A backend for splitting a sequence on a generic delimiter type."
  (loop
     for search-start = 0 then (+ sep step-incr)
     for sep = (funcall search-fun seq search-start)
     collect (let ((split (subseq seq search-start sep)))
               (if include-splitter
                   (cons (subseq seq
                                 (max (- search-start step-incr) 0)
                                 search-start)
                         split)
                   split)) into splits
     when (null sep) return splits))

(defun split-seq-on-seq (delimiter seq)
  "Split the sequence on a delimiter that is a subsequence."
  (split-seq-backend seq (length delimiter)
                     (lambda (seq search-start)
                       (search delimiter seq :start2 search-start))))

(defun split-seq-on-elt (delimiter seq)
  "Split the sequence on a delimiter that is an element of the sequence."
  (split-seq-backend seq 1
                     (lambda (seq search-start)
                       (position delimiter seq :start search-start))))

(defun split-seq-on-fn (predicate seq &key (include-splitter nil))
  "Split the sequence on a predicate."
  (split-seq-backend seq 1
                     (lambda (seq search-start)
                       (position-if predicate seq :start search-start))
                     :include-splitter include-splitter))

(defun split-seq-on-elts (delimiters seq &key (include-splitter nil))
  "Split the sequence on one of several delimiters."
  (split-seq-backend seq 1 
                     (lambda (seq search-start)
                       (position delimiters seq :start search-start :test (flip #'member)))
                     :include-splitter include-splitter))

(defun map-over-hash-values (fn hash)
  (loop for val being the hash-values in hash
       collect (funcall fn val)))

(defun hash-values (hash)
  (loop for val being the hash-values in hash
       collect val))

(defun hash-keys (hash)
  (loop for val being the hash-keys in hash
       collect val))

(defun hash-alist (hash)
  (loop for key being the hash-keys in hash using (hash-value val)
       collect (cons key val)))

(defun remove-items (items sequence)
  (remove items sequence :test (flip #'find)))

(defun delete-items (items sequence)
  (delete items sequence :test (flip #'find)))

(defun repeat-element (element n)
  (loop for i from 1 to n collect element))
