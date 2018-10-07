(deftemplate ORDENADOR
    (slot codigo)
    (slot enciende (allowed-values nil si no))
    (slot fuente (allowed-values nil bien mal))
    (slot placa (allowed-values nil bien mal))
    (slot cpu (allowed-values nil bien mal))
    (slot gpu (allowed-values nil bien mal))
    (slot ram (allowed-values nil bien mal))
    (slot hay_pitido (allowed-values nil si no))
    (slot enciende_monitor (allowed-values nil si no))
    (slot luz_placa (allowed-values nil si no))
    (slot enciende_ventilador_cpu (allowed-values nil si no))
    (slot pantalla_azul (allowed-values nil si no))
    (slot diagnostico (default nil)))
 
(do-backward-chaining ORDENADOR) 
    
(deffacts inicio
        (ORDENADOR (codigo pc1) (enciende no))
        (ORDENADOR (codigo pc2) (enciende si) (hay_pitido no) (luz_placa si) (enciende_monitor no))
        (ORDENADOR (codigo pc3) (enciende si))
        (ORDENADOR (codigo pc4) (enciende si) (enciende_ventilador_cpu no)))

(defrule todo_bien
        (declare (salience 250)(no-loop TRUE))
?ordenador<-(ORDENADOR (codigo ?cod)(ram bien)(cpu bien)(gpu bien)(placa bien)(fuente bien))
        =>  (modify ?ordenador (diagnostico nada))
            (printout t "Funciona correctamente "?cod crlf))

(defrule ram
        (declare (salience 150)(no-loop TRUE))
?ordenador<-(ORDENADOR (codigo ?cod)(ram mal))
        =>  (modify ?ordenador (diagnostico ram))
            (printout t "Hay que cambiar la RAM "?cod crlf))

(defrule placa
        (declare (salience 150)(no-loop TRUE))
?ordenador<-(ORDENADOR (codigo ?cod)(placa mal))
        =>  (modify ?ordenador (diagnostico placa))
            (printout t "Hay que cambiar la placa base "?cod crlf))

(defrule cpu
        (declare (salience 150)(no-loop TRUE))
?ordenador<-(ORDENADOR (codigo ?cod)(cpu mal))
        =>  (modify ?ordenador (diagnostico cpu))
            (printout t "Hay que cambiar la CPU "?cod crlf))

(defrule gpu
        (declare (salience 150)(no-loop TRUE))
?ordenador<-(ORDENADOR (codigo ?cod)(gpu mal))
        =>  (modify ?ordenador (diagnostico gpu))
            (printout t "Hay que cambiar la GPU "?cod crlf))

(defrule fuente
        (declare (salience 150)(no-loop TRUE))
?ordenador<-(ORDENADOR (codigo ?cod)(fuente mal))
        =>  (modify ?ordenador (diagnostico fuente))
            (printout t "Hay que cambiar la fuente de alimentación "?cod crlf))

(defrule no_arranca
        (declare (salience 100))
?ordenador<-(ORDENADOR (enciende no)(diagnostico nil))
        => (modify ?ordenador (fuente mal)))

(defrule si_arranca
        (declare (salience 200))
?ordenador<-(ORDENADOR (enciende si)(diagnostico nil))
        => (modify ?ordenador (fuente bien)))

(defrule pitidos1
        (declare (salience 50))
?ordenador<-(ORDENADOR (fuente bien)(hay_pitido si)(diagnostico nil))
        => (modify ?ordenador (ram mal)))

(defrule pitidos2
        (declare (salience 200))
?ordenador<-(ORDENADOR (fuente bien)(hay_pitido no)(diagnostico nil))
        => (modify ?ordenador (ram bien)))

(defrule luz_apagada1
        (declare (salience 50))
?ordenador<-(ORDENADOR (fuente bien)(luz_placa no)(diagnostico nil))
        => (modify ?ordenador (placa mal)))

(defrule ventilador_apagado1
        (declare (salience 50))
?ordenador<-(ORDENADOR (fuente bien)(enciende_ventilador_cpu no)(diagnostico nil))
        => (modify ?ordenador (placa mal)))

(defrule luz_apagada2
        (declare (salience 200))
?ordenador<-(ORDENADOR (fuente bien)(luz_placa si)(diagnostico nil))
        => (modify ?ordenador (placa bien)))

(defrule ventilador_apagado2
        (declare (salience 200))
?ordenador<-(ORDENADOR (fuente bien)(enciende_ventilador_cpu si)(diagnostico nil))
        => (modify ?ordenador (placa bien)))

(defrule monitor_apagado1
        (declare (salience 50))
?ordenador<-(ORDENADOR (fuente bien)(enciende_monitor no)(diagnostico nil))
        => (modify ?ordenador (gpu mal)))

(defrule monitor_apagado2
        (declare (salience 200))
?ordenador<-(ORDENADOR (fuente bien)(enciende_monitor si)(diagnostico nil))
        => (modify ?ordenador (gpu bien)))

(defrule pantallazo_azul1
        (declare (salience 50))
?ordenador<-(ORDENADOR (fuente bien)(pantalla_azul si)(diagnostico nil))
        => (modify ?ordenador (cpu mal)))

(defrule pantallazo_azul2
        (declare (salience 200))
?ordenador<-(ORDENADOR (fuente bien)(pantalla_azul no)(diagnostico nil))
        => (modify ?ordenador (cpu bien)))


(defrule preguntapitido 
    (declare (salience 0))
  (exists (need-ORDENADOR(codigo ?cod)(hay_pitido nil)))
?g<- (ORDENADOR (codigo ?cod)(hay_pitido nil)(diagnostico nil))
        => (printout t "Hay un pitido al encender el ordenador " ?cod "? (responder con si o no)")
           (modify ?g (hay_pitido(read)))
        )

(defrule pregunta_luzplaca 
        (declare (salience 0))
        (exists (need-ORDENADOR (codigo ?cod)(luz_placa nil)))
?g<- (ORDENADOR (codigo ?cod)(luz_placa nil)(diagnostico nil))
    => (printout t "Se enciende la luz de la placa al encender el ordenador " ?cod "? (responder con si o no)")
           (modify ?g (luz_placa(read))))

(defrule pregunta_ventiladorcpu 
        (declare (salience 0))
        (exists (need-ORDENADOR (codigo ?cod)(enciende_ventilador_cpu nil)))
?g<- (ORDENADOR (codigo ?cod)(enciende_ventilador_cpu nil)(diagnostico nil))
        => (printout t "Se activa el disipador al encender el ordenador " ?cod "? (responder con si o no)")
           (modify ?g (enciende_ventilador_cpu(read)))
        )

(defrule pregunta_monitor
        (declare (salience 0))
        (exists (need-ORDENADOR (codigo ?cod)(enciende_monitor nil)))
?g<- (ORDENADOR (codigo ?cod)(enciende_monitor nil)(diagnostico nil))
        => (printout t "Se enciende el monitor al encender el ordenador " ?cod "? (responder con si o no)")
           (modify ?g (enciende_monitor(read))))

(defrule pregunta_pantallazo 
        (declare (salience 0))
        (exists (need-ORDENADOR (codigo ?cod)(pantalla_azul nil)))
?g<- (ORDENADOR (codigo ?cod)(pantalla_azul nil)(diagnostico nil))
        => (printout t "Hay un pantallazo azul en el monitor al encender el ordenador " ?cod "? (responder con si o no)")
           (modify ?g (pantalla_azul(read))))
(reset)
(facts)
(run) 

