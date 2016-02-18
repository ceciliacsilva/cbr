(in-package :hunchentoot-test)
(load "matDH.lisp")
(load "funcoes.lisp")
(load "graficoJS.lisp")


(defparameter *css* "
body { text-align: center; }
#site { width: 700px; }
#topo { width: 700px; height: 100px; }
#col1 { width: 150px; float: left; height: 300px; }
#col2 { width: 500px; float: left; height: 300px; }
#col3 { width: 270px; float: left; height: 300px; }
#imagem{
-webkit-transform:rotate(90deg); /* Chrome, Safari, Opera */
transform:rotate(90deg); /* Standard syntax */
}
.botao{
border:1px solid #495267; -webkit-border-radius: 3px; -moz-border-radius: 3px;border-radius: 3px;font-size:19px;font-family:arial, helvetica, sans-serif; padding: 18px 18px 18px 18px; text-decoration:none; display:inline-block;text-shadow: -1px -1px 0 rgba(0,0,0,0.3);font-weight:bold; color: #FFFFFF;
 background-color: #606c88; background-image: -webkit-gradient(linear, left top, left bottom, from(#606c88), to(#3f4c6b));
 background-image: -webkit-linear-gradient(top, #606c88, #3f4c6b);
 background-image: -moz-linear-gradient(top, #606c88, #3f4c6b);
 background-image: -ms-linear-gradient(top, #606c88, #3f4c6b);
 background-image: -o-linear-gradient(top, #606c88, #3f4c6b);
 background-image: linear-gradient(to bottom, #606c88, #3f4c6b);filter:progid:DXImageTransform.Microsoft.gradient(GradientType=0,startColorstr=#606c88, endColorstr=#3f4c6b);
}

.botao:hover{
 border:1px solid #363d4c;
 background-color: #4b546a; background-image: -webkit-gradient(linear, left top, left bottom, from(#4b546a), to(#2c354b));
 background-image: -webkit-linear-gradient(top, #4b546a, #2c354b);
 background-image: -moz-linear-gradient(top, #4b546a, #2c354b);
 background-image: -ms-linear-gradient(top, #4b546a, #2c354b);
 background-image: -o-linear-gradient(top, #4b546a, #2c354b);
 background-image: linear-gradient(to bottom, #4b546a, #2c354b);filter:progid:DXImageTransform.Microsoft.gradient(GradientType=0,startColorstr=#4b546a, endColorstr=#2c354b);
}
.text_box
{ 
background:#F8F8F8;
color:#594646;
border:3px solid #DCDCDC;
border-radius:11px ;
font-size:19px ;
height: 36px ;
line-height:36px ;
width: 235px ;
padding: 6px ;
box-shadow: 1px 0px 8px #0D0C0C; 
-webkit-box-shadow: 1px 0px 8px #0D0C0C; '
-moz-box-shadow: 1px 0px 8px #0D0C0C; 
}
")

(hunchentoot:define-easy-handler (trabalhoMicro :uri "/micro"
					    :default-request-type :get)
    ()
  (cond ((or (string= (get-parameter "bot") "Configuracoes") (get-parameter "conf"))
	 (multiple-value-bind (user password)
	     (authorization)
	   (cond ((and (equal user "admin")
		       (equal password "robotAdmin"))
		  (with-html
		      (:html
		       (:head (:title "Configuracoes")
			      (:style :type  "text/css"
				      (str *css*)
				      )
			      )
		       (:body
			(:div :style "text-align:center;"
			      (:h2 "Configuracoes iniciais realizadas.")
			      (:form :method :get
				     (:br)(:br)
				     "IP local:    "
				     (:input :type "text" :name "ip" :value  (string-trim "\"" (lerIP)) :class "text_box")"      "
				     (:input :type "submit" :name "conf" :value "OK" :class "botao")
				     (cond ((string= (get-parameter "conf") "OK")
					    (let ((novoIP (get-parameter "ip")))
					      (escreverIP novoIP)
					      (str (concatenate 'string "<p>IP local atualizado. Novo IP: " (string-trim "\"" (lerIP)) "</p>" ))
					      )))
				     (:br)(:br)(:br)(:br)
				     (:input :type "submit" :name "bot" :value "Inicio" :class "botao")(:br)(:br)
				     )
			      )
			)
		       (modificaArquivo2 "motor1" -90)
		       (modificaArquivo2 "motor2" -90)
		       (motorZero "motor3")
		       (motorZero "motor4")
		       (modificaArquivo2 "motor5" -90)
		       (configPWM motor1 20000000 0 0)
		       (configPWM motor2 20000000 0 0)
		       (configPWM motor3 20000000 0 0)
		       (configPWM motor4 20000000 0 0)
		       (configPWM motor5 20000000 0 0)
		       (setDuty motor1 (+ (* (+ (lerMotor "motor1") 90) 8334) 1450000))
		       (setDuty motor2 (+ (* (+ (lerMotor "motor2") 90) 8334) 1450000))
		       (setDuty motor3 (+ (* (lerMotor "motor3")  8334) 1450000))
		       (setDuty motor4 (+ (*  (lerMotor "motor4") 8572) 1300000))
		       (setDuty motor5 (+ (* (+ (lerMotor "motor5") 90) 9000) 1300000))
		       ;(GPIO_export LED)
		       (setDirection LED "OUT")
		       )
		    ))
		 (t (require-authorization)))
	   ))
	((or (string= (get-parameter "bot") "Lanterna") (string= (get-parameter "lan" ) "barra") (string= (get-parameter "lan") "sensor"))
	 (with-html
	     (:html
	      (cond ((string= (get-parameter "lan") "sensor")
		     (str
		      (concatenate 'string "<head><title>Lanterna</title><meta http-equiv='refresh' content='0.5'><meta charset='UTF-8'><style type=text/css>" *css* "</style></head>"))
		     )
		    (t 
		     (str (concatenate 'string "<head><title>Lanterna</title><style type=text/css>" *css* "</style></head>"))
			      )
		    )
	      (:body
	       (:div :style "text-align:center;"
		     (:h1 "Lanterna")
		     (:form :method :get
			    (:input :name "valorAD" :type :range :min :0 :max :300 :step :1 :value (let ((AD (get-parameter "valorAD")))
												     (if (not AD)
													 "50"
													 AD
													 )))
			    (cond ((string= (get-parameter "lan") "sensor")
				   (configPWM LED 409500 0 0)
				   (setDuty LED (* (getAD 0) 100))
				   )
				  (t
				   (let ((AD (get-parameter "valorAD")))
				     (cond (AD 
					;(configPWM LED 409500 0 0)
					;(setDuty LED (* (/ 4095 3) (parse-integer AD)))
					    (if (> (parse-integer AD) 150)
						(setValue LED "HIGH")
					      (setValue LED "LOW")
					      )
					    )
					   ))
				   ))
			    (:br)(:br)
			    (:input :type "submit" :name "lan" :value "sensor" :class "botao")"    "
			    (:input :type "submit" :name "lan" :value "barra" :class "botao")
			    (:br)(:br)(:br)(:br)
			    (:input :type "submit" :name "bot" :value "Inicio" :class "botao")
			    )
		     )
	       )))
	 )
	((or (string= (get-parameter "bot") "Movimentos") (get-parameter "mot1") (get-parameter "mot2") (get-parameter "mot3") (get-parameter "mot4") (get-parameter "mot5"))
	 (multiple-value-bind (user password)
	     (authorization)
	   (cond ((or (and (equal user "admin")
			   (equal password "robotAdmin"))
		      (and (equal user "professor")
			   (equal password "teste123")))
		  (with-html
		      (:html
		       (:head (:title "Robot")
			      (:style :type  "text/css"
				      (str *css*)
				      )
			      )
		       (:body
			(let ((bot (get-parameter "mot1"))
			      (grau 5))
			  (cond ((string= bot "E1")
				 (modificaArquivoM12 "motor1" (- grau)))
				((string= bot "D1")
				 (modificaArquivoM12 "motor1" grau))))
			(let ((bot (get-parameter "mot2"))
			      (grau 5))
			  (cond ((string= bot "A2")
				 (modificaArquivoM12 "motor2" (- grau)))
				((string= bot "R2")
				 (modificaArquivoM12 "motor2" grau))))
			
			(let ((bot (get-parameter "mot3"))
			      (grau 5))
			  (cond ((string= bot "A3")
				 (modificaArquivo "motor3" grau))
				((string= bot "R3")
				 (modificaArquivo "motor3" (- grau)))))

			(let ((bot (get-parameter "mot4"))
			      (grau 5))
			  (cond ((string= bot "<")
				 (modificaArquivoM4 "motor4" (- grau)))
				((string= bot ">")
				     (modificaArquivoM4 "motor4" grau))))
			(let ((bot (get-parameter "mot5"))
			      (grau 5))
			  (cond ((string= bot "A")
				 (modificaArquivoM5 "motor5" (- grau)))
				    ((string= bot "F")
				     (modificaArquivoM5 "motor5" grau))))
			
			    
			(setDuty motor1 (+ (* (+ (lerMotor "motor1") 90) 8334) 1450000))
			(setDuty motor2 (+ (* (+ (lerMotor "motor2") 90) 8334) 1450000))
			(setDuty motor3 (+ (* (lerMotor "motor3") 8334) 1450000))
			(setDuty motor4 (+ (* (lerMotor "motor4") 8572) 1300000))
			(setDuty motor5 (+ (* (+ (lerMotor "motor5") 90) 9000) 1300000))
			
			(:div :id "col1" ;:style "text-aling:left" 
			      (:div :id "imagem"
				    (cond ((< (lerMotor "motor5") -118)
				  (str "<img src='img/garra5.jpg' width='170' height='200'/>")
					   )
					  ((< (lerMotor "motor5") -101)
					   (str "<img src='img/garra4.jpg' width='170' height='200'/>")
					   )
					  ((< (lerMotor "motor5") -84)
					   (str "<img src='img/garra3.jpg' width='170' height='200'/>")
					   )
					  ((< (lerMotor "motor5") -67)
					   (str "<img src='img/garra2.jpg' width='170' height='200'/>")
					   )
					  (t
					   (str "<img src='img/garra1.jpg' width='170' height='200'/>")
					   )
					  )
				    )
			      (str (concatenate 'string "<h3>Inclinacao: " (write-to-string (lerMotor "motor4")) " graus</h3>"))
			      (:form :method :get
				     (:pre
				      (:input :type "submit" :name "mot5" :value "A" :class "botao")
				      "  "
				      (:input :type "submit" :name "mot5" :value "F" :class "botao")
				      )
				     
				     (:br)(:br)
				     (:pre
				      (:input :type "submit" :name "mot4" :value "<" :class "botao")
				      "    "
				      (:input :type "submit" :name "mot4" :value ">" :class "botao")
				      )
				     (:br)(:br)
				     )
			      )
			(:div :id "col2"
			      (let ((matDH (map 'list (lambda(a)
							(map 'list (lambda(b) (floor b)) a)) 
						(array-to-list
						 (*M (*M (matDH (* pi (/ (lerMotor "motor1") 180))
							  (- (/ pi 2)) 0 8.5) 
							 (matDH (* pi (/ (lerMotor "motor2") 180)) 0 10.5 7.5))
						     (matDH (* pi (/ (lerMotor "motor3") 180)) 0 17 0)))))
				    (matDH1 (map 'list (lambda(a)
							(map 'list (lambda(b) (floor b)) a)) 
						(array-to-list
						 (*M (matDH (* pi (/ (lerMotor "motor1") 180))
							    (- (/ pi 2)) 0 8.5) 
						     (matDH (* pi (/ (lerMotor "motor2") 180)) 0 10.5 7.5)))))
				    
				    (matDH2 (map 'list (lambda(a)
							(map 'list (lambda(b) (floor b)) a)) 
						(array-to-list
						 (*M (matDH (* pi (/ (lerMotor "motor1") 180))
							    (- (/ pi 2)) 0 8.5) 
						     (matDH (* pi (/ (lerMotor "motor2") 180)) 0 10.5 4)))))
				    
				    (matDH3 (map 'list (lambda(a)
							(map 'list (lambda(b) (floor b)) a)) 
						(array-to-list
						 (*M (matDH (* pi (/ (lerMotor "motor1") 180))
							    (- (/ pi 2)) 0 8.5) 
						     (matDH (* pi (/ (lerMotor "motor2") 180)) 0 0 4)))))
				    
				    (matDH4 (map 'list (lambda(a)
							 (map 'list (lambda(b) (floor b)) a)) 
						 (array-to-list
						  (matDH (* pi (/ (lerMotor "motor1") 180))
							 (- (/ pi 2)) 0 8.5) )))

				    #|
				    (matDH #2A((1.0d0 0.0d0 0.0d0 10d0)
					(-0.0d0 6.123233995736766d-17 1.0d0 10d0)
					(0 -1.0d0 6.123233995736766d-17 10d0)
					(0 0 0 1)))
				    
				    (matDH1 #2A((1.0d0 0.0d0 0.0d0 10d0)
					(-0.0d0 6.123233995736766d-17 1.0d0 -0.0d0)
					(0 -1.0d0 6.123233995736766d-17 0)
					(0 0 0 1)))
				    (matDH2 #2A((1.0d0 0.0d0 0.0d0 0.0d0)
					(-0.0d0 6.123233995736766d-17 1.0d0 10d0)
					(0 -1.0d0 6.123233995736766d-17 0)
					(0 0 0 1)))
				    (matDH3
				     #2A((0.9961946980917455d0 0.08715574274765817d0 0.0d0 19.92389396183491d0)
					 (-5.336750069161486d-18 6.099933241728101d-17 -1.0d0
								 -1.067350013832297d-16)
					 (-0.08715574274765817d0 0.9961946980917455d0 6.123233995736766d-17
								 2.2568851450468372d0)
					 (0.0d0 0.0d0 0.0d0 1.0d0))
				     )
				    (matDH4 #2A((1.0d0 0.0d0 0.0d0 0.0d0)
					(-0.0d0 6.123233995736766d-17 1.0d0 -0.0d0)
					(0 -1.0d0 6.123233995736766d-17 5)
				    (0 0 0 1)))
				    |#
				    )
				;;grafico
				
				(str (graficoJS matDH matDH1 matDH2 matDH3 matDH4))
				)
			      (:br)(:br)(:br)(:br)(:br)(:br)
			      (:form :method :get
				     (:input :type "submit" :name "bot" :value "Inicio" :class "botao")
				     )
			      )
			
			(:div :id "col3"
			      (let ((matDH (array-to-list (*M (*M (matDH (* pi (/ (lerMotor "motor1") 180))
									      (- (/ pi 2)) 0 8.5) 
								  (matDH (* pi (/ (lerMotor "motor2") 180)) 0 10.5 7.5))
								   (matDH (* pi (/ (lerMotor "motor3") 180)) 0 17 0)))))
				(str (concatenate 'string  "<table style='width:100%'>" 
						  "<tr><td>X:</td>"
						  "<td>"(write-to-string (first (pegarPosicao matDH))) "</td>"
						  "<td>M1:</td>"
						  "<td>"(write-to-string (+ (lerMotor "motor1") 90))  "</td></tr>"
						  "<tr><td>Y:</td>"
						  "<td>"(write-to-string (second (pegarPosicao matDH))) "</td>"
						  "<td>M2:</td>"
						  "<td>"(write-to-string (+ (lerMotor "motor2") 90))  "</td></tr>"
						  "<tr><td>Z:</td>"
						  "<td>" (write-to-string (third (pegarPosicao matDH))) "</td>"
						  "<td>M3:</td>"
						  "<td>"(write-to-string (lerMotor "motor3"))  "</td>""</tr></table>"))
				;(str "<p>oi</p>")
				)
			      (:br)(:br)(:br)(:br)
			      (:form :method :get
				     (:div :class "left"
					   (:pre
					    (:input :type "submit" :name "mot3" :value "A3" :class "botao")
					    "        "
					    (:input :type "submit" :name "mot2" :value "A2" :class "botao")
					    (:br))
					   (:pre
					    "               "
					    (:input :type "submit" :name "mot1" :value "E1" :class "botao")
					    "  "
					    (:input :type "submit" :name "mot1" :value "D1" :class "botao")
					    (:br))
					   (:pre 
					    (:input :type "submit" :name "mot3" :value "R3" :class "botao")
					    "        "
					    (:input :type "submit" :name "mot2" :value "R2" :class "botao")
					    )
					   )
				     
				     )
			      )
			)
		       )
		    )
		  )
		 (t
		  (require-authorization)) )))
	((string= (get-parameter "bot") "Camera")
	 (with-html
	     (:html
	      (:head (:title "Camera")
		     (:style :type  "text/css"
			     (str *css*)
			     )
		     )
	      (:body
	       (:div :style "text-align:center;"
		     (:br)
		     (:h1 "Camera")
		     (:form :action "http://192.168.7.2:8080/javascript_simple.html" :target "_blank"
			    (:input :type "submit" :value "PC-BBBone" :class "botao")
			    )
		     (:br)
		     (:form :action (concatenate 'string "http://" (string-trim "\"" (lerIP)) ":8080/javascript_simple.html") :target "_blank"
			    (:input :type "submit" :value "Rede Local" :class "botao")
			    )
		     (:br)(:br)(:br)(:br)
		     (:form :method :get
			    (:input :type "submit" :name "bot" :value "Inicio" :class "botao")
			    )
		     )
	       )
	      )
	   )
	 )
	(t
	 (with-html
	     (:html
	      (:head (:title "Trabalho Micro")
		     (:style :type  "text/css"
			     (str *css*)
			     )
		     )
	      (:body
	       (:div :style "text-align:center;"
		     (:br)
		     (:h1 "Trabalho de Microprocessadores")
		     (:form :method :get
			    (:br)(:br)
			    (:input :type "submit" :name "bot" :value "Configuracoes" :class "botao")(:br)(:br)
			    (:input :type "submit" :name "bot" :value "Lanterna" :class "botao")(:br)(:br)
			    (:input :type "submit" :name "bot" :value "Camera" :class "botao")(:br)(:br)
			    (:input :type "submit" :name "bot" :value "Movimentos" :class "botao")(:br)(:br)
			    )
		     (:br)(:br)
		     ;;(:img :src "img/made-with-lisp-logo.jpg")
		     (:h3 "Cecilia Carneiro e Silva - Marcelo Malaguitti Ricci")
		     (:h3 "Prof: Andrei Nakagawa")
		     )
	       )
	      )
	   )
	 )
	)
  )
