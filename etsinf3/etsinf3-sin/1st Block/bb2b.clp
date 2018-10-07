(deffacts bulb_robot
	(grid 5 4)
	(warehouse 2 3)
	(max_bulbs 3)
	(robot 1 3 0 0 lamp 3 4 3 0 lamp 4 2 0 2 lamp 5 4 2 0 level 0)
	)
	
(deffunction inicio ()
    (reset)
	(printout t "Maximum Depth:= " )
	(bind ?depth (read))
	(assert (maxD ?depth))
	)
	
(defrule left
	?f<-(robot ?x $?rest level ?l) (maxD ?d)
	(test (> ?x 1))
	(test (<= ?l ?d))
	=>
	(assert (robot (- ?x 1) $?rest level (+ ?l 1))))
	
(defrule right
	?f<-(robot ?x $?rest level ?l) (grid ?a ?b) (maxD ?d)
	(test (< ?x ?a))
	(test (<= ?l ?d))
	=>
	(assert (robot (+ ?x 1) $?rest level (+ ?l 1))))
	
(defrule up
	?f<-(robot ?x ?y $?rest level ?l) (grid ?a ?b) (maxD ?d)
	(test (< ?y ?b))
	(test (<= ?l ?d))
	=>
	(assert (robot ?x (+ ?y 1) $?rest level (+ ?l 1))))
	
(defrule down
	?f<-(robot ?x ?y $?rest level ?l) (maxD ?d)
	(test (> ?y 1))
	(test (<= ?l ?d))
	=>
	(assert (robot ?x (- ?y 1) $?rest level (+ ?l 1))))
	
(defrule replace1
	(declare (salience 10))
	?f<-(robot ?x ?y ?bulb1 ?b2 $?rest lamp ?x ?y ?b1 ?b2 $?rest1 level ?l) (maxD ?d)
	(test (>= ?bulb1 ?b1))
	(test (<= ?l ?d))
	(test (= ?b2 0))
	=>
	(assert (robot ?x ?y (- ?bulb1 ?b1) $?rest $?rest1 level (+ ?l 1))))

(defrule replace2
	(declare (salience 10))
	?f<-(robot ?x ?y ?b1 ?bulb2 $?rest lamp ?x ?y ?b1 ?b2 $?rest1 level ?l) (maxD ?d)
	(test (>= ?bulb2 ?b2))
	(test (<= ?l ?d))
	(test(= ?b1 0))
	=>
	(assert (robot ?x ?y (- ?bulb2 ?b2) $?rest $?rest1 level (+ ?l 1))))
	
(defrule load1
	(declare (salience 10))
	?f<-(warehouse ?warX ?warY) (robot ?x ?y ?bulb1 ?bulb2 $?rest level ?l) (max_bulbs ?maxBulbs) (maxD ?d)
	(test (and (= ?warX ?x) (= ?warY ?y)))
	(test (<= ?l ?d))
	(test (= ?bulb2 0))
	=>
	(assert (robot ?x ?y ?maxBulbs ?bulb2 $?rest level (+ ?l 1))))

(defrule load2
	(declare (salience 5))
	?f<-(warehouse ?warX ?warY) (robot ?x ?y ?bulb1 ?bulb2 $?rest level ?l) (max_bulbs ?maxBulbs) (maxD ?d)
	(test (and (= ?warX ?x) (= ?warY ?y)))
	(test (<= ?l ?d))
	(test(= ?bulb1 0))
	=>
	(assert (robot ?x ?y ?bulb1 ?maxBulbs $?rest level (+ ?l 1))))
	
(defrule checkIsRight
	(declare (salience 9999))
	?f<-(robot ?x ?y ?z ?b1 ?b2 level ?l) (maxD ?d)
	(test(<= ?l ?d))
	=>
	(printout t "Lamps repaired.")
	(halt))
	
(defrule checkNOsol
	(declare (salience -99))
	?f<-(robot $?r level ?l) (maxD ?d)
	(test(> ?l ?d))
	=>
	(printout t "Robot is not working.")
	(halt)
)
