(defun matDH(teta alfa a d)
  (let ((mat (make-array '(4 4))))
    (setf (aref mat 0 0)  (cos teta))
    (setf (aref mat 0 1)  (- (* (sin teta) (cos alfa))))
    (setf (aref mat 0 2)  (* (sin teta) (sin alfa)))
    (setf (aref mat 0 3)  (* (cos teta) a))
    (setf (aref mat 1 0)  (sin teta))
    (setf (aref mat 1 1)  (* (cos teta) (cos alfa)))
    (setf (aref mat 1 2)  (- (* (sin alfa) (cos teta))))
    (setf (aref mat 1 3)  (* (sin teta) a))
    (setf (aref mat 2 0)  0)
    (setf (aref mat 2 1)  (sin alfa))
    (setf (aref mat 2 2)  (cos alfa))
    (setf (aref mat 2 3)  d)
    (setf (aref mat 3 0)  0)
    (setf (aref mat 3 1)  0)
    (setf (aref mat 3 2)  0)
    (setf (aref mat 3 3)  1)
    mat
    ))


(defun array-to-list (array)
  (let* ((dimensions (array-dimensions array))
	 (depth      (1- (length dimensions)))
	 (indices    (make-list (1+ depth) :initial-element 0)))
    (labels ((recurse (n)
	       (loop for j below (nth n dimensions)
		  do (setf (nth n indices) j)
		  collect (if (= n depth)
			      (apply #'aref array indices)
			      (recurse (1+ n))))))
            (recurse 0))))

(defun *M (A B)
  (let* ((m (car (array-dimensions A)))
	 (n (cadr (array-dimensions A)))
	 (l (cadr (array-dimensions B)))
	 (C (make-array `(,m ,l) :initial-element 0)))
    (loop for i from 0 to (- m 1) do
	 (loop for k from 0 to (- l 1) do
	      (setf (aref C i k)
		    (loop for j from 0 to (- n 1)
		       sum (* (aref A i j)
			      (aref B j k))))))
        C))
