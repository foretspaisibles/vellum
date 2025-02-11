(cl:in-package #:cl-user)


(defpackage vellum.table
  (:use #:cl #:vellum.aux-package)
  (:nicknames #:vellum.table)
  (:export
   #:*current-row*
   #:*transform-control*
   #:*table*
   #:*transform-in-place*
   #:alter-columns
   #:at
   #:bind-row
   #:bind-row-closure
   #:brr
   #:column-at
   #:column-count
   #:column-name
   #:column-names
   #:column-type
   #:current-row-as-vector
   #:drop-row
   #:group-by
   #:aggregated-value
   #:aggregation-prohibited-and-found
   #:aggregation-required-and-not-found
   #:*wrap-errors*
   #:*enable-restarts*
   #:erase!
   #:finish-transformation
   #:fundamental-table
   #:header
   #:hstack
   #:hstack*
   #:make-table-row
   #:make-setfable-table-row
   #:iterator
   #:make-table
   #:distinct
   #:make-table*
   #:no-transformation
   #:aggregate
   #:nullify
   #:remove-nulls
   #:retry
   #:row-at
   #:row-count
   #:row-to-list
   #:row-to-vector
   #:rr
   #:select
   #:setfable-table-row
   #:show
   #:skip-row
   #:standard-table
   #:standard-table-range
   #:standard-transformation-row
   #:to-table
   #:transform
   #:transform-row
   #:transformation
   #:transformation-error
   #:transformation-result
   #:vmask
   #:vstack
   #:vstack*
   #:with-table))
