# cbr

Instruções de utilização:

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

* (ql:quickload :hunchentoot)

* (ql:quickload :hunchentoot-test)

* (hunchentoot:start (make-instance 'hunchentoot:easy-acceptor :port 4242))

* (load "paginaComando.lisp")

Acesse o seguinte endereço no browser: http://localhost:4242/micro

