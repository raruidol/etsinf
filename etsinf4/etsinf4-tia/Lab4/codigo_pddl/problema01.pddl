(define(problem viajcomnodirigidonores) 
(:domain viajcom)

(:objects
	Shinosuke - merchant
	Kobe -city
    Osaka -city
    Kyoto -city
    Himeji -city
)

(:init
	(at Shinosuke Kyoto)
    (not (visited Kobe))
    (not (visited Kyoto))
    (not (visited Osaka))
    (not (visited Himeji))
    (= (visit Kobe) 15)
    (= (visit Kyoto) 120)
    (= (visit Osaka) 60)
    (= (visit Himeji) 10)
)

(:goal 
    (or
        (visited Kobe)
        (visited Kyoto)
        (visited Osaka)
        (visited Himeji)
        (not (visited Kobe))
        (not (visited Kyoto))
        (not (visited Osaka))
        (not (visited Himeji))
    )
)

(:metric minimize (total-time))
)
