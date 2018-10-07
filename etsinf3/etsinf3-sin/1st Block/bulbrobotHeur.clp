;; =========================================================
;; ===    M A N H A T T A N    H E U R I S T I C         ==
;; =========================================================

(defglobal ?*gen-nod* = 0)
(defglobal ?*f* = 1)
	
(deffunction manhattan(?x ?y ?xx ?yy)
	(bind ?manhattan (+ (abs (- ?x ?xx)) (abs(- ?y ?yy))))
	?manhattan
)
	
(deffunction distance (?x ?y ?b ?xx ?yy ?lamps)
	(bind ?dist 0)
	(bind ?li (/ (length$ ?lamps) 4))
        (if (> ?li 0) then
	(if(<= ?b 0) then (bind ?dist (+ ?dist (manhattan ?x ?y ?xx ?yy) 1)))
	(if(> ?b 0) then (bind ?dist (+ ?dist 1 (manhattan ?x ?y (nth$ (- (* ?li 4) 2) ?lamps) (nth$ (- (* 4 ?li) 1) ?lamps))))
		(bind ?dist (+ ?dist (+ 1 (manhattan (nth$ (- (* ?li 4) 2) ?lamps) (nth$ (- (* ?li 4) 1) ?lamps) ?xx ?yy))))
		(bind ?li (- ?li 1))
	)
	(while(> ?li 1)
		(bind ?dist (+ ?dist 2 (* (manhattan ?xx ?yy (nth$ (- (* ?li 4) 2) ?lamps) (nth$ (- (* 4 ?li) 1) ?lamps)) 2)))
		(bind ?li (- ?li 1))
	)
        (if (= ?li 1)
	      then (bind ?dist (+ ?dist (manhattan ?xx ?yy (nth$ (- (* ?li 4) 2) ?lamps) (nth$ (- (* ?li 4) 1) ?lamps)) 1))
	)
        )

    ?dist)

(deffunction control (?x ?y ?b ?xx ?yy ?lamps ?level)
    (bind ?*f* (distance ?x ?y ?b ?xx ?yy ?lamps))
    (bind ?*f* (+ ?*f* ?level 1))
)
	
(defrule left
	(declare (salience (- 0 ?*f*)))
	?f<-(robot ?x ?y ?b $?rest level ?l) 
        (maxD ?d) 
        (warehouse ?xx ?yy)
	(test (> ?x 1))
	(test (<= ?l ?d))
	(test (control (- ?x 1) ?y ?b ?xx ?yy $?rest ?l))
	=>
	(assert (robot (- ?x 1) ?y ?b $?rest level (+ ?l 1))))
	
(defrule right
	(declare (salience (- 0 ?*f*)))
	?f<-(robot ?x ?y ?b $?rest level ?l) 
        (grid ?a ?c) 
        (maxD ?d)
	(warehouse ?xx ?yy)
	(test (< ?x ?a))
	(test (<= ?l ?d))
	(test (control (+ ?x 1) ?y ?b ?xx ?yy $?rest ?l))
	=>
	(assert (robot (+ ?x 1) ?y ?b $?rest level (+ ?l 1))))
	
(defrule up
	(declare (salience (- 0 ?*f*)))
	?f<-(robot ?x ?y ?b $?rest level ?l) 
        (grid ?a ?c) 
        (maxD ?d)
	(warehouse ?xx ?yy)
	(test (< ?y ?c))
	(test (<= ?l ?d))
	(test (control ?x (+ ?y 1) ?b ?xx ?yy $?rest ?l))
	=>
	(assert (robot ?x (+ ?y 1) ?b $?rest level (+ ?l 1))))
	
(defrule down
	(declare (salience (- 0 ?*f*)))
	?f<-(robot ?x ?y ?b $?rest level ?l) 
        (maxD ?d)
	(warehouse ?xx ?yy)
	(test (> ?y 1))
	(test (<= ?l ?d))
	(test (control ?x (- ?y 1) ?b ?xx ?yy $?rest ?l))
	=>
	(assert (robot ?x (- ?y 1) ?b $?rest level (+ ?l 1))))
	
(defrule replace
	(declare (salience (- 0 ?*f*)))
	?f<-(robot ?x ?y ?b $?rest lamp ?x ?y ?b1 $?rest1 level ?l) 
        (maxD ?d) 
        (warehouse ?xx ?yy)
	(test (>= ?b ?b1))
	(test (<= ?l ?d))
	(test (control ?x ?y (- ?b ?b1) ?xx ?yy (create$  $?rest $?rest1) ?l))
	=>
	(assert (robot ?x ?y (- ?b ?b1) $?rest $?rest1 level (+ ?l 1))))
	
(defrule load
	(declare (salience (- 0 ?*f*)))
	?f<-(robot ?x ?y ?b $?rest level ?l) 
        (warehouse ?x ?y) 
        (max_bulbs ?maxBulbs) 
        (maxD ?d)
        (test(< ?b ?maxBulbs))
	(test (<= ?l ?d))
	(test (control ?x ?y ?maxBulbs ?x ?y $?rest ?l))
	=>
	(assert (robot ?x ?y ?maxBulbs $?rest level (+ ?l 1))))
	
;; ========================================================
;; =========   S E A R C H       S T R A T E G Y   ========
;; ========================================================
;; The "goal" rule is used to detect when the goal state is reached
	
(deffunction start ()
        (set-salience-evaluation when-activated)
        (reset)
	(printout t "Maximum Depth:= " )
	(bind ?depth (read))
	(assert (maxD ?depth))
	(assert (grid 5 4))
	(assert (warehouse 2 3))
	(assert (max_bulbs 3))
	(assert (robot 1 3 0 lamp 5 4 2 lamp 3 4 3 lamp 4 2 2 lamp 3 2 1 lamp 1 4 2 level 0))
)

(defrule checkIsRight
	(declare (salience 9999))
	?f<-(robot ? ? ? level ?l) 
        (maxD ?d)
	(test(<= ?l ?d))
	=>
	(printout t "Lamps repaired at level: " ?l crlf)
	(halt)
)

(defrule checkNOsol
	(declare (salience -99))
	?f<-(robot $?r lamp ? ? ? $?k level ?l) 
        (maxD ?d)
	(test(> ?l ?d))
	=>
	(printout t "Robot failed repairing.")
	(halt)
)
