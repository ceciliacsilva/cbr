(defun motorZero(nomeArquivo)
  (let ((buf (concatenate 'string "/root/micro/"
			  ;"/home/cecilia/Dropbox/7periodo/Micro/trabalho/usando/"
			  nomeArquivo)))
    (with-open-file (fdEscrita buf :direction :output :if-exists :supersede)
		    (format fdEscrita "~s" 0))
    )
  )

(defun motorNoventa(nomeArquivo)
  (let ((buf (concatenate 'string "/root/micro/"
			  ;"/home/cecilia/Dropbox/7periodo/Micro/trabalho/usando/"
			  nomeArquivo)))
    (with-open-file (fdEscrita buf :direction :output :if-exists :supersede)
		    (format fdEscrita "~s" 90))
    )
  )

(defun modificaArquivo(nomeArquivo valor)
  (let ((buf (concatenate 'string "/root/micro/"
			  ;"/home/cecilia/Dropbox/7periodo/Micro/trabalho/usando/"
			  nomeArquivo)))
    (with-open-file (fd buf)
      (let* ((leitura (read-line fd))
	     (valorAnt (parse-integer leitura)))
	(cond ((or ;(and (> (+ valor valorAnt) -180) (< (+ valor valorAnt) 0))
		(and (< (+ valor valorAnt) 90) (> (+ valor valorAnt) -90))
		   )
	      (with-open-file (fdEscrita buf :direction :output :if-exists :supersede)
		(format fdEscrita "~s" (+ valorAnt valor)))
	      ))
      ))))

(defun modificaArquivoM4(nomeArquivo valor)
  (let ((buf (concatenate 'string "/root/micro/"
			  ;"/home/cecilia/Dropbox/7periodo/Micro/trabalho/usando/"
			  nomeArquivo)))
    (with-open-file (fd buf)
      (let* ((leitura (read-line fd))
	     (valorAnt (parse-integer leitura)))
	(cond ((or ;(and (> (+ valor valorAnt) -180) (< (+ valor valorAnt) 0))
		(and (< (+ valor valorAnt) 120) (> (+ valor valorAnt) -95))
		   )
	      (with-open-file (fdEscrita buf :direction :output :if-exists :supersede)
		(format fdEscrita "~s" (+ valorAnt valor)))
	      ))
      ))))


(defun modificaArquivoM12(nomeArquivo valor)
  (let ((buf (concatenate 'string "/root/micro/"
			  ;"/home/cecilia/Dropbox/7periodo/Micro/trabalho/usando/"
			  nomeArquivo)))
    (with-open-file (fd buf)
      (let* ((leitura (read-line fd))
	     (valorAnt (parse-integer leitura)))
	(cond ((or (and (> (+ valor valorAnt) -180) (< (+ valor valorAnt) 0))
		;(and (< (+ valor valorAnt) 90) (> (+ valor valorAnt) -90))
		   )
	      (with-open-file (fdEscrita buf :direction :output :if-exists :supersede)
		(format fdEscrita "~s" (+ valorAnt valor)))
	      ))
      ))))

(defun modificaArquivoM5(nomeArquivo valor)
  (let ((buf (concatenate 'string "/root/micro/"
			  ;"/home/cecilia/Dropbox/7periodo/Micro/trabalho/usando/"
			  nomeArquivo)))
    (with-open-file (fd buf)
      (let* ((leitura (read-line fd))
	     (valorAnt (parse-integer leitura)))
	(cond ((or (and (> (+ valor valorAnt) -135) (< (+ valor valorAnt) -55))
		;(and (< (+ valor valorAnt) 90) (> (+ valor valorAnt) -90))
		   )
	      (with-open-file (fdEscrita buf :direction :output :if-exists :supersede)
		(format fdEscrita "~s" (+ valorAnt valor)))
	      ))
      ))))


(defun modificaArquivo2(nomeArquivo valor)
  (let ((buf (concatenate 'string "/root/micro/"
			  ;"/home/cecilia/Dropbox/7periodo/Micro/trabalho/usando/"
			  nomeArquivo)))
    (with-open-file (fdEscrita buf :direction :output :if-exists :supersede)
		    (format fdEscrita "~s" valor))
	)
  )


(defun lerMotor(nomeArquivo)
  (let ((buf (concatenate 'string "/root/micro/"
			  ;"/home/cecilia/Dropbox/7periodo/Micro/trabalho/usando/"
			  nomeArquivo)))
    (with-open-file (fd buf)
      (let* ((leitura (read-line fd))
	     (valor (parse-integer leitura)))
	valor
	))
    ))

(defun pegarPosicao (lista)
  (let ((px (fourth (first lista)))
	(py (fourth (second lista)))
	(pz (fourth (third lista))))
    (list px py pz)
    ))

(defun lerIP()
  (let ((buf (concatenate 'string "/root/micro/"
			  ;"/home/cecilia/Dropbox/7periodo/Micro/trabalho/usando/"
			  "ipEndereco")))
    (with-open-file (fd buf)
      (read-line fd))))

(defun escreverIP(novoIp)
  (let ((buf (concatenate 'string "/root/micro/"
			  ;"/home/cecilia/Dropbox/7periodo/Micro/trabalho/usando/"
			  "ipEndereco")))
    (with-open-file (fd buf :direction :output :if-exists :supersede)
      (format fd "~s" novoIp ))))
