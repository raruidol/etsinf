(define (domain viajcom)
    (:requirements :typing :durative-actions :fluents)
    (:types merchant city - object)

    (:predicates (at ?x - merchant ?y - city)
                 (visited ?x - city)
    )

    (:functions (distance ?x - city ?y - city)
                (visit ?x - city)
    )

    (:durative-action visitar
    :parameters (?m - merchant ?c - city) 
    :duration (= ?duration (visit ?c))
    :condition (and (over all (at ?m ?c)) (over all(not(visited ?c))))
    :effect (at end(visited ?c))
    )

    (:durative-action viajar
    :parameters (?m - merchant ?c1 - city ?c2 - city) 
    :duration (= ?duration (distance ?c1 ?c2))
    :condition (and (at start (at ?m ?c1)) (over all(not(visited ?c2))))
    :effect (and (at start (not (at ?m ?c1))) (at end (at ?m ?c2)))
    )
)

