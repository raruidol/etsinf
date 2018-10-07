(deftemplate ENTORNO
    (slot codigo)
    (slot enciende (allowed-values nil si no))
    (slot fuente (allowed-values nil bien mal))
    (slot enchufe (allowed-values nil bien mal))
    (slot regleta (allowed-values nil bien mal))
    (slot corriente (allowed-values nil bien mal))
    (slot boton_power (allowed-values nil bien mal))
    (slot conexion_botpow_placa (allowed-values nil si no))
    (slot conexion_regl_ench (allowed-values nil si no))
    (slot luz_boton_regleta (allowed-values nil si no))
    (slot luz_corriente_placa (allowed-values nil si no))
    (slot boton_regleta_pos (allowed-values nil encendido apagado))
    (slot boton_fuente_pos (allowed-values nil encendido apagado))
    (slot luz_ENTORNO (allowed-values nil si no))
    (slot conexion (allowed-values nil ench regl no))
    (slot diagnostico (default nil)))

(do-backward-chaining ENTORNO) 

(deffacts inicio
        (ENTORNO (codigo pc1) (enciende no) (conexion regl))
        (ENTORNO (codigo pc2) (enciende no) (luz_boton_regleta si) (luz_corriente_placa si) )
        (ENTORNO (codigo pc3) (enciende si))
    	(ENTORNO (codigo pc4) (boton_fuente_pos encendido)))

;---------------------------------------------------------------------------------------------

(defrule todo_bien
        (declare (salience 500)(no-loop TRUE))
?entorno<-(ENTORNO (codigo ?cod)(enciende si))
        =>  (modify ?entorno (diagnostico nada))
            (printout t "Funciona correctamente "?cod crlf))

(defrule fuente
        (declare (salience 500)(no-loop TRUE))
?entorno<-(ENTORNO (codigo ?cod)(fuente mal))
        =>  (modify ?entorno (diagnostico fuente))
            (printout t "La fuente no funciona "?cod crlf))

(defrule enchufe
        (declare (salience 500)(no-loop TRUE))
?entorno<-(ENTORNO (codigo ?cod)(enchufe mal))
        =>  (modify ?entorno (diagnostico enchufe))
            (printout t "El problema esta en el enchufe "?cod crlf))

(defrule regleta
        (declare (salience 500)(no-loop TRUE))
?entorno<-(ENTORNO (codigo ?cod)(regleta mal))
        =>  (modify ?entorno (diagnostico regleta))
            (printout t "La regleta no proporciona electicidad "?cod crlf))

(defrule corriente
        (declare (salience 500)(no-loop TRUE))
?entorno<-(ENTORNO (codigo ?cod)(corriente mal))
        =>  (modify ?entorno (diagnostico corriente))
            (printout t "El fallo esta en la corriente de la sala "?cod crlf))

(defrule boton_power
        (declare (salience 500)(no-loop TRUE))
?entorno<-(ENTORNO (codigo ?cod)(boton_power mal))
        =>  (modify ?entorno (diagnostico boton))
            (printout t "El boton de encendido esta estropeado "?cod crlf))

(defrule conex_bpow
        (declare (salience 500)(no-loop TRUE))
?entorno<-(ENTORNO (codigo ?cod)(conexion_botpow_placa no))
        =>  (modify ?entorno (diagnostico conexion1))
            (printout t "El boton de encendido no esta conectado a la placa "?cod crlf))

(defrule boton_reglpos
        (declare (salience 500)(no-loop TRUE))
?entorno<-(ENTORNO (codigo ?cod)(boton_regleta_pos apagado))
        =>  (modify ?entorno (diagnostico conexion2))
            (printout t "Enciende la relgeta! "?cod crlf))

(defrule boton_fuenpos
        (declare (salience 500)(no-loop TRUE))
?entorno<-(ENTORNO (codigo ?cod)(boton_fuente_pos apagado))
        =>  (modify ?entorno (diagnostico conexion3))
            (printout t "La fuente esta apagada "?cod crlf))

(defrule conex_reglen
        (declare (salience 500)(no-loop TRUE))
?entorno<-(ENTORNO (codigo ?cod)(conexion_regl_ench no))
        =>  (modify ?entorno (diagnostico conexion4))
            (printout t "La regleta esta desconectada "?cod crlf))

(defrule conex
        (declare (salience 500)(no-loop TRUE))
?entorno<-(ENTORNO (codigo ?cod)(conexion no))
        =>  (modify ?entorno (diagnostico conexion))
            (printout t "El ordenador no esta conectado "?cod crlf))

;--------------------------------------------------------------------------------------------

(defrule botpow
		(declare (salience 400)(no-loop TRUE))
?entorno<-(ENTORNO (codigo ?cod)(conexion_botpow_placa si)(diagnostico nil)(enciende no)(luz_corriente_placa si))
        =>  (modify ?entorno (boton_power mal)))

(defrule corr
		(declare (salience 400)(no-loop TRUE))
?entorno<-(ENTORNO (codigo ?cod)(luz_ENTORNO no)(diagnostico nil))
        =>  (modify ?entorno (corriente mal)))

(defrule regl
		(declare (salience 400)(no-loop TRUE))
?entorno<-(ENTORNO (codigo ?cod)(luz_ENTORNO si)(diagnostico nil)(conexion_regl_ench si)(boton_regleta_pos encendido)(luz_boton_regleta no)(enciende no))
        =>  (modify ?entorno (regleta mal)))

(defrule ench
		(declare (salience 400)(no-loop TRUE))
?entorno<-(ENTORNO (codigo ?cod)(luz_ENTORNO si)(diagnostico nil)(boton_fuente_pos encendido)(enciende no)(luz_corriente_placa no))
        =>  (modify ?entorno (enchufe mal)))

(defrule psench
		(declare (salience 400)(no-loop TRUE))
?entorno<-(ENTORNO (codigo ?cod)(conexion ench)(diagnostico nil)(luz_ENTORNO si)(boton_fuente_pos encendido)(luz_corriente_placa no)(enciende no))
        =>  (modify ?entorno (fuente mal)))

(defrule psregl
		(declare (salience 400)(no-loop TRUE))
?entorno<-(ENTORNO (codigo ?cod)(conexion regl)(diagnostico nil)(luz_boton_regleta si)(boton_fuente_pos encendido)(luz_corriente_placa no)(enciende no))
        =>  (modify ?entorno (fuente mal)))
            
;---------------------------------------------------------------------------------------------

(defrule deduc_luzplacare
                (declare (salience 300))
?entorno<-(ENTORNO (codigo ?cod)(luz_corriente_placa si)(conexion regl)(diagnostico nil))
        =>  (modify ?entorno (boton_fuente_pos encendido)(regleta bien)))

(defrule deduc_reglet1
                (declare (salience 300))
?entorno<-(ENTORNO (codigo ?cod)(regleta bien)(diagnostico nil))
        =>  (modify ?entorno (luz_boton_regleta si)(boton_regleta_pos encendido)))

(defrule deduc_reglet2
                (declare (salience 300))
?entorno<-(ENTORNO (codigo ?cod)(luz_boton_regleta si)(diagnostico nil))
        =>  (modify ?entorno (conexion_regl_ench si)(enchufe bien)))

(defrule deduc_luzplacaen
                (declare (salience 300))
?entorno<-(ENTORNO (codigo ?cod)(luz_corriente_placa si)(conexion ench)(diagnostico nil))
        =>  (modify ?entorno (boton_fuente_pos encendido)(enchufe bien)))

(defrule deduc_enchuf
                (declare (salience 300))
?entorno<-(ENTORNO (codigo ?cod)(enchufe bien)(diagnostico nil))
        =>  (modify ?entorno (luz_ENTORNO si)))

(defrule deduc_conexion_regleta_enchufe
                (declare (salience 300))
?entorno<-(ENTORNO (codigo ?cod)(enchufe bien)(luz_boton_regleta si)(diagnostico nil))
        =>  (modify ?entorno (conexion_regl_ench si)(regleta bien)))

(defrule deduc_enchufbien1
                (declare (salience 300))
?entorno<-(ENTORNO (codigo ?cod)(luz_ENTORNO si)(conexion ench)(luz_corriente_placa si)(diagnostico nil))
        =>  (modify ?entorno (enchufe bien)))

;---------------------------------------------------------------------------------------------

(defrule pregunta_enciende
        (declare (salience 0))
        (exists (need-ENTORNO (codigo ?cod)(enciende nil)))
?g<- (ENTORNO (codigo ?cod)(enciende nil)(diagnostico nil))
        => (printout t "Se enciende el ordenador? " ?cod " (responder con si o no)")
           (modify ?g (enciende(read))))

(defrule pregunta_conexbotpow
        (declare (salience 0))
        (exists (need-ENTORNO (codigo ?cod)(conexion_botpow_placa nil)))
?g<- (ENTORNO (codigo ?cod)(conexion_botpow_placa nil)(diagnostico nil))
        => (printout t "El cable del boton de encendido esta conectado a la placa? " ?cod " (responder con si o no)")
           (modify ?g (conexion_botpow_placa(read))))

(defrule pregunta_conexregleta
        (declare (salience 0))
        (exists (need-ENTORNO (codigo ?cod)(conexion_regl_ench nil)))
?g<- (ENTORNO (codigo ?cod)(conexion_regl_ench nil)(diagnostico nil))
        => (printout t "Esta conectada la regleta a la luz? " ?cod " (responder con si o no)")
           (modify ?g (conexion_regl_ench(read))))

(defrule pregunta_luzregleta
        (declare (salience 0))
        (exists (need-ENTORNO (codigo ?cod)(luz_boton_regleta nil)))
?g<- (ENTORNO (codigo ?cod)(luz_boton_regleta nil)(diagnostico nil))
        => (printout t "El boton de la regleta esta iluminado? " ?cod " (responder con si o no)")
           (modify ?g (luz_boton_regleta(read))))

(defrule pregunta_luzplaca
        (declare (salience 0))
        (exists (need-ENTORNO (codigo ?cod)(luz_corriente_placa nil)))
?g<- (ENTORNO (codigo ?cod)(luz_corriente_placa nil)(diagnostico nil))
        => (printout t "La luz de la placa que indica corriente esta encendida? " ?cod " (responder con si o no)")
           (modify ?g (luz_corriente_placa(read))))

(defrule pregunta_botonregleta
        (declare (salience 0))
        (exists (need-ENTORNO (codigo ?cod)(boton_regleta_pos nil)))
?g<- (ENTORNO (codigo ?cod)(boton_regleta_pos nil)(diagnostico nil))
        => (printout t "En que posicion esta el boton de la regleta? " ?cod " (responder con encendido o apagado)")
           (modify ?g (boton_regleta_pos(read))))

(defrule pregunta_botonfuente
        (declare (salience 0))
        (exists (need-ENTORNO (codigo ?cod)(boton_fuente_pos nil)))
?g<- (ENTORNO (codigo ?cod)(boton_fuente_pos nil)(diagnostico nil))
        => (printout t "En que posicion esta el boton de la fuente de alimentacion? " ?cod " (responder con encendido o apagado)")
           (modify ?g (boton_fuente_pos(read))))

(defrule pregunta_luzENTORNO
        (declare (salience 0))
        (exists (need-ENTORNO (codigo ?cod)(luz_ENTORNO nil)))
?g<- (ENTORNO (codigo ?cod)(luz_ENTORNO nil)(diagnostico nil))
        => (printout t "Hay luz en la habitacion? " ?cod " (responder con si o no)")
           (modify ?g (luz_ENTORNO(read))))

(defrule pregunta_conexion
        (declare (salience 0))
        (exists (need-ENTORNO (codigo ?cod)(conexion nil)))
?g<- (ENTORNO (codigo ?cod)(conexion nil)(diagnostico nil))
        => (printout t "Donde esta conectado el pc? " ?cod " (responder con ench(ufe) o regl(eta))")
           (modify ?g (conexion(read))))

;---------------------------------------------------------------------------------------------

(reset)
(facts)
(run) 
