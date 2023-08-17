(cl:in-package #:vellum.int)


(defgeneric gather-column-data (range definitions result))

(defgeneric fill-columns-buffer-impl (range position buffer
                                      finish-callback key))


(defmethod fill-columns-buffer-impl ((range cl-ds.alg:group-by-result-range)
                                     position buffer finish-callback key)
  (cl-ds:across range
                (lambda (group)
                  (setf (aref buffer position)
                        (car group))
                  (fill-columns-buffer-impl (cdr group) (1+ position)
                                            buffer finish-callback key))))


(defmethod fill-columns-buffer-impl ((range cl-ds.alg:summary-result-range)
                                     position buffer finish-callback key)
  (cl-ds:across range
                (lambda (group)
                  (setf (aref buffer position)
                        (funcall key (cdr group)))
                  (incf position)))
  (funcall finish-callback))


(defmethod fill-columns-buffer-impl ((range t) position buffer
                                     finish-callback key)
  (setf (aref buffer position) (funcall key range))
  (funcall finish-callback))


(defmethod gather-column-data ((range cl-ds.alg:group-by-result-range)
                               definitions result)
  (gather-column-data (~> range cl-ds:peek-front cdr)
                      (rest definitions)
                      (cons (first definitions) result)))


(defmethod gather-column-data ((range cl-ds.alg:summary-result-range)
                               definitions result)
  (cl-ds:across range
                (lambda (data)
                  (push (append (pop definitions)
                                (list :name (car data)))
                        result)))
  (nreverse result))


(defmethod gather-column-data ((range t)
                               definitions result)
  (nreverse (cons (first definitions) result)))


(defun common-to-table (range key class header body after)
  (bind ((column-count (vellum.header:column-count header))
         (columns (make-array column-count))
         (columns-buffer (make-array column-count))
         (function (vellum:bind-row-closure body :header header)))
    (iterate
      (for i from 0 below column-count)
      (setf (aref columns i)
            (vellum.column:make-sparse-material-column
             :element-type (vellum.header:column-type header i))))
    (let* ((iterator (vellum.column:make-iterator columns))
           (row (vellum.table:make-setfable-table-row :iterator iterator))
           (box-row (box row)))
      (fill-columns-buffer-impl
       range 0 columns-buffer
       (lambda ()
         (iterate
           (for i from 0 below column-count)
           (setf (vellum.column:iterator-at iterator i)
                 (aref columns-buffer i)))
         (vellum.header:with-header (header)
           (let ((vellum.header:*row* box-row))
             (funcall function row)))
         (vellum.column:move-iterator iterator 1))
       key)
      (vellum.column:finish-iterator iterator)
      (funcall after (make class
                           :header header
                           :columns columns)))))


(defmethod vellum:to-table ((range cl-ds.alg:group-by-result-range)
                           &key
                             (key #'identity)
                             (class 'vellum.table:standard-table)
                             (columns '())
                             (body nil)
                             (after #'identity)
                             (header (apply #'vellum:make-header
                                            (gather-column-data range columns '())))
                             &allow-other-keys)
  (break)
  (common-to-table range key class header body after))


(defmethod vellum:to-table ((range cl-ds.alg:summary-result-range)
                           &key
                             (key #'identity)
                             (class 'vellum.table:standard-table)
                             (columns '())
                             (body nil)
                             (after #'identity)
                             (header (apply #'vellum:make-header
                                            (gather-column-data range columns '())))
                            &allow-other-keys)
  (common-to-table range key class header body after))
