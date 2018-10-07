(deffacts bulb_robot
	(grid 5 4)
	(max_bulbs 3)
	(robot 1 3 0 lamp 3 4 3 lamp 4 2 2 lamp 5 4 2 war1 2 3 7 war2 4 3 8 level 0)
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
	
(defrule replace
	(declare (salience 10))
	?f<-(robot ?x ?y ?bulb $?rest lamp ?x ?y ?bulb1 $?rest1 level ?l) (maxD ?d)
	(test (>= ?bulb ?bulb1))
	(test (<= ?l ?d))
	=>
	(assert (robot ?x ?y (- ?bulb ?bulb1) $?rest $?rest1 level (+ ?l 1))))
	
(defrule load1
	(declare (salience 10))
	?f<-(robot ?x ?y ?bulb $?rest war1 ?warX ?warY ?b $?q level ?l) (max_bulbs ?maxBulbs) (maxD ?d)
	(test (and (= ?warX ?x) (= ?warY ?y)))
	(test (<= ?l ?d))
	(test (> ?b 0))
	=>
	(assert (robot ?x ?y ?maxBulbs $?rest war1 ?warX ?warY (- ?b (- ?maxBulbs ?bulb)) $?q level (+ ?l 1))))
	
(defrule load2
	(declare (salience 10))
	?f<-(robot ?x ?y ?bulb $?rest war2 ?warX ?warY ?b level ?l) (max_bulbs ?maxBulbs) (maxD ?d)
	(test (and (= ?warX ?x) (= ?warY ?y)))
	(test (<= ?l ?d))
	(test (> ?b 0))
	=>
	(assert (robot ?x ?y ?maxBulbs $?rest war2 ?warX ?warY (- ?b (- ?maxBulbs ?bulb)) level (+ ?l 1))))

(defrule checkIsRight
	(declare (salience 9999))
	?f<-(robot ?x ?y ?z war1 $?a war2 $?b level ?l) (maxD ?d)
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
