# cbr
Criação de um braço robótico, controlado remotamente.

Fevereiro 2016.

Bem-vindos, esse projeto foi execultado como trabalho da disciplina de microprocessadores, curso de engenharia elétrica, Universidade Federal de Uberlândia.

Os programas foram feitos em Common Lisp (https://common-lisp.net/), foi instanciado um servidor Hunchentoot (http://weitz.de/hunchentoot/), além de utilizar MJPG-Streamer (https://sourceforge.net/projects/mjpg-streamer/) para interligar a WebCam e o Browser. 

O sistema foi embarcado no microcontrolador BeagleBone Black (http://beagleboard.org/bone), Sistema Operacional Debian.

# Instruções de utilização:

Na BeagleBone:

$ cd ~

$ mkdir micro

No computador:

$ git clone https://github.com/ceciliacsilva/cbr

$ cd cbr

$ scp * root@192.168.7.2:~/micro

Novamente na BeagleBone:

$ cd micro

$ sbcl

 \* (ql:quickload :hunchentoot)

 \* (ql:quickload :hunchentoot-test)

 \* (hunchentoot:start (make-instance 'hunchentoot:easy-acceptor :port 4242))

 \* (load "paginaComando.lisp")

Acesse o seguinte endereço no browser: http://localhost:4242/micro

# Tutoriais e páginas úteis:

* Ômegaflix, site dedicado a programação de sistemas embarcados: http://www.omegaflix.com/

* Apostilas para iniciantes em BeagleBone, programas em C: https://mega.nz/#F!Fl0RXQiQ!zOsTMBc-oZv_NI0pwTQoFQ

* Inspiração para a criação do modelo do braço em forma de gráfico: http://robotic-controls.com/book/export/html/39

* Tutoriais sobre programação Web em Common Lisp: http://www.adamtornhill.com/articles/lispweb.htm
                                                https://common-lisp.net/project/parenscript/tutorial.html
