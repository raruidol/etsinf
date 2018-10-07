(define(problem viajcomnodirigido8) 
(:domain viajcom)

(:objects
	Shinosuke - merchant
	Kobe -city
    Osaka -city
    Kyoto -city
    Himeji -city
    Tokyo -city
    Yokohama -city
    Nagoya -city
    Odawara -city
)

(:init
	(at Shinosuke Kyoto)
    (not (visited Kobe))
    (not (visited Kyoto))
    (not (visited Osaka))
    (not (visited Himeji))
    (not (visited Tokyo))
    (not (visited Yokohama))
    (not (visited Nagoya))
    (not (visited Odawara))
    (= (visit Kobe) 15)
    (= (visit Kyoto) 120)
    (= (visit Osaka) 60)
    (= (visit Himeji) 10)
    (= (visit Tokyo) 200)
    (= (visit Yokohama) 70)
    (= (visit Nagoya) 55)
    (= (visit Odawara) 24)
)

(:goal (and
        (visited Kobe)
        (visited Kyoto)
        (visited Osaka)
        (visited Himeji)
        (visited Tokyo)
        (visited Yokohama)
        (visited Nagoya)
        (visited Odawara)
        (at Shinosuke Kyoto)
    )
)

(:metric minimize (total-time))
)
