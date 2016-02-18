(defparameter SYSFS_GPIO_DIR "/sys/class/gpio")
(defparameter SYSFS_ADC_DIR "/sys/bus/iio/devices/iio:device0")               
(defparameter SYSFS_PWM_DIR "/sys/devices/ocp.3/pwm_test_" )
(defparameter LED "38")
(defparameter motor1 "P8_13.16")
(defparameter motor2 "P9_16.12")
(defparameter motor3 "P9_28.13")
(defparameter motor4 "P9_29.14")
(defparameter motor5 "P9_42.15")


(defun setValue (gpio value)
 (let ((buf (concatenate 'string SYSFS_GPIO_DIR "/gpio" (write-to-string gpio) "/value")))
   (with-open-file (fd buf :direction :output :if-exists :supersede :if-does-not-exist nil)
     (cond
       ((string= value "LOW") (format fd "0"))
       ((string= value "HIGH") (format fd "1"))
       (t (format fd "0"))
       )
     )
   ))

(defun setDirection (gpio direction)
  (let ((buf (concatenate 'string SYSFS_GPIO_DIR "/gpio" (write-to-string gpio) "/direction")))
    (with-open-file (fd buf :direction :output :if-exists :supersede :if-does-not-exist nil)
     (cond
       ((string= direction "IN") (format fd "in"))
       ((string= direction "OUT") (format fd "out"))
       (t (format fd "in"))
       )
     )
   ))

(defun GPIO_export (gpio)
  (let ((buf (concatenate 'string SYSFS_GPIO_DIR "/export")))
    (with-open-file (fd buf :direction :output :if-exists :append :if-does-not-exist nil)
		    (format fd "~s" (write-to-string gpio))
		    )
    ))
  

(defun getAD (porta)
  (let ((buf (concatenate 'string SYSFS_ADC_DIR "/in_voltage" (write-to-string porta) "_raw")))
    (with-open-file (fd buf)
      (parse-integer (read-line fd)))))


(defun configPWM(pino periodo duty polaridade)
  (let ((buf (concatenate 'string SYSFS_PWM_DIR pino "/period")))
    (with-open-file (fd buf :direction :output :if-exists :supersede :if-does-not-exist nil)
      (format fd "~s" periodo)))
  (let ((buf (concatenate 'string SYSFS_PWM_DIR pino "/duty")))
    (with-open-file (fd buf :direction :output :if-exists :supersede :if-does-not-exist nil)
      (format fd "~s" duty)))
  (let ((buf (concatenate 'string SYSFS_PWM_DIR pino "/polarity")))
    (with-open-file (fd buf :direction :output :if-exists :supersede :if-does-not-exist nil)
      (format fd "~s" polaridade)))
  (let ((buf (concatenate 'string SYSFS_PWM_DIR pino "/run")))
    (with-open-file (fd buf :direction :output :if-exists :supersede :if-does-not-exist nil)
      (format fd "1")))
  )

(defun setDuty (pino duty)
  (let ((buf (concatenate 'string SYSFS_PWM_DIR pino "/duty")))
    (with-open-file (fd buf :direction :output :if-exists :supersede :if-does-not-exist nil)
      (format fd "~s" 
	      duty
	      ))
    ))

