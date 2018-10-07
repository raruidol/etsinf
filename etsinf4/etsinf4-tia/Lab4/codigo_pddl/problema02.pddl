(define(problem viajcomdirigido) 
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
	(= (distance Kobe Osaka) 25)
	(= (distance Kobe Kyoto) 50)
	(= (distance Kobe Himeji) 30)
	(= (distance Osaka Kobe) 40)
	(= (distance Osaka Kyoto) 15)
	(= (distance Osaka Himeji) 60)
	(= (distance Kyoto Osaka) 20)
	(= (distance Kyoto Kobe) 45)
	(= (distance Kyoto Himeji) 120)
	(= (distance Himeji Osaka) 49)
	(= (distance Himeji Kobe) 33)
	(= (distance Himeji Kyoto) 100)
)

(:goal (and
        (visited Kobe)
        (visited Kyoto)
        (visited Osaka)
        (visited Himeji)
        (at Shinosuke Kyoto)
    )
)

(:metric minimize (total-time))
)
