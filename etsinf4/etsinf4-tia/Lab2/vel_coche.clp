(deftemplate dist 0 50 metros
        ((cerca (0 1)(15 0))
        (medio (10 0)(25 1)(35 1)(40 0))
        (lejos (35 0)(50 1))))
 
(deftemplate vel_relativa -30 30 Km/h
        ((alejando (-30 1)(0 0))
        (constante (-10 0)(0 1)(10 0))
        (acercando (0 0)(30 1))))

(deftemplate presion_freno 0 100 percent
        ((nula (z 10 25))
        (media (pi 25 65))
        (alta (s 65 90))))

(deffunction fuzzify (?fztemplate ?value ?delta)
 (bind ?low (get-u-from ?fztemplate))
 (bind ?hi (get-u-to ?fztemplate))
 (if (<= ?value ?low)
 then
 (assert-string
 (format nil "(%s (%g 1.0) (%g 0.0))" ?fztemplate ?low ?delta))
 else
 (if (>= ?value ?hi)
 then
 (assert-string
 (format nil "(%s (%g 0.0) (%g 1.0))"
 ?fztemplate (- ?hi ?delta) ?hi))
 else
 (assert-string
 (format nil "(%s (%g 0.0) (%g 1.0) (%g 0.0))"
 ?fztemplate (max ?low (- ?value ?delta))
 ?value (min ?hi (+ ?value ?delta)) ))
 ))) 

(defrule inputdist
 (initial-fact)
=>
 (assert (evaluado no))
 (printout t "Inserte la distancia que separa ambos vehiculos:" crlf)
 (bind ?Rdist (read))
 (fuzzify dist ?Rdist 0)
 (printout t "Inserte la velocidad relativa entre ambos vehiculos:" crlf)
 (bind ?Rvel (read))
 (fuzzify vel_relativa ?Rvel 0)) 
 

(defrule alejando-cerca
        ?g<-(dist cerca)(vel_relativa alejando)
        ?f<-(evaluado no)
=>
(retract ?f)
(assert (evaluado si)(presion_freno nula)))

(defrule constante-cerca
        ?g<-(dist cerca)(vel_relativa constante)
        ?f<-(evaluado no)
=>
(retract ?f)
(assert (evaluado si)(presion_freno media)))

(defrule acercando-cerca
        ?g<-(dist cerca)(vel_relativa acercando)
        ?f<-(evaluado no)
=>
(retract ?f)
(assert (evaluado si)(presion_freno alta)))

(defrule alejando-medio
        ?g<-(dist medio)(vel_relativa alejando)
        ?f<-(evaluado no)
=>
(retract ?f)
(assert (evaluado si)(presion_freno nula)))

(defrule constante-medio
        ?g<-(dist medio)(vel_relativa constante)
        ?f<-(evaluado no)
=>
(retract ?f)
(assert (evaluado si)(presion_freno nula)))

(defrule acercando-medio
        ?g<-(dist medio)(vel_relativa acercando)
        ?f<-(evaluado no)
=>
(retract ?f)
(assert (evaluado si)(presion_freno media)))

(defrule alejando-lejos
        ?g<-(dist lejos)(vel_relativa alejando)
        ?f<-(evaluado no)
=>
(retract ?f)
(assert (evaluado si)(presion_freno nula)))

(defrule constante-lejos
        ?g<-(dist lejos)(vel_relativa constante)
        ?f<-(evaluado no)
=>
(retract ?f)
(assert (evaluado si)(presion_freno nula)))

(defrule acercando-lejos
        ?g<-(dist lejos)(vel_relativa acercando)
        ?f<-(evaluado no)
=>
(retract ?f)
(assert (evaluado si)(presion_freno media)))

(defrule defusificar
        ?f<-(presion_freno ?pres)(evaluado si)(dist ?d)(vel_relativa ?v)
=> (bind ?e (maximum-defuzzify ?pres))
(retract ?f)
(printout t "El conductor tiene que apretar el freno a una presion del " ?e "%"))
