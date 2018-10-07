/*1 table*/
/*1*/
SELECT DISTINCT cod_pais
FROM CS_Actor 
ORDER BY cod_pais ASC;
/*2*/
SELECT cod_peli, titulo
FROM CS_Pelicula 
WHERE cod_lib IS NULL
AND anyo < 1970
ORDER BY titulo ASC;
/*3*/
SELECT cod_act, nombre
FROM CS_Actor
WHERE nombre LIKE'%John%';
/*4*/
SELECT cod_peli, titulo
FROM CS_Pelicula
WHERE duracion>120
AND anyo >= 1980 AND anyo <1990;
/*5*/
SELECT cod_peli, titulo
FROM CS_Pelicula
WHERE cod_lib IS NOT NULL
AND director LIKE '%Pakula%';
/*6*/
SELECT COUNT(*)
FROM CS_Pelicula
WHERE duracion >120
AND anyo >= 1980 AND anyo <1990;
/*7*/
SELECT COUNT(DISTINCT cod_peli)AS Cuantas_Pelis
FROM CS_Clasificacion 
WHERE cod_gen = 'BB5'
OR cod_gen = 'GG4'
OR cod_gen = 'JH6';
/*8*/
SELECT MIN(anyo)AS ANYO
FROM CS_Libro;
/*9*/
SELECT AVG(duracion)AS DURACION_MEDIA
FROM CS_Pelicula
WHERE anyo = 1987;
/*10*/
SELECT SUM(duracion)AS DURAN_MIN
FROM CS_Pelicula
WHERE director = 'Steven Spielberg';

/*.................................*/
/*multiple table*/
/*11*/
SELECT P.cod_peli, P.titulo
FROM CS_Pelicula P, CS_Actor A, CS_Actua X
WHERE A.nombre LIKE P.director
AND A.cod_act = X.cod_act
AND P.cod_peli = X.cod_peli
ORDER BY P.titulo;
/*12*/
SELECT P.cod_peli, P.titulo
FROM CS_Pelicula P, CS_Clasificacion C,CS_Genero G
WHERE P.cod_peli = C.cod_peli
AND C.cod_gen = G.cod_gen
AND G.nombre = 'Comedia'
ORDER BY titulo;
/*13*/
SELECT P.cod_peli, P.titulo 
FROM CS_Pelicula P, CS_Libro L
WHERE P.cod_lib = L.cod_lib
AND L.anyo <1950
ORDER BY P.titulo;
/*14*/
SELECT DISTINCT P.cod_pais AS cod_p, P.nombre
FROM CS_Pais P, CS_Actor A, CS_Actua X, CS_Clasificacion C, CS_Genero G
WHERE P.cod_pais = A.cod_pais
AND A.cod_act = X.cod_act
AND X.cod_peli = C.cod_peli
AND C.cod_gen = G.cod_gen
AND G.nombre LIKE 'Comedia'
ORDER BY nombre;

/*.................................*/
/*subqueries*/
/*15*/
/* 11,12,13,14*/
/*11*/
SELECT P.cod_peli, P.titulo
FROM CS_Pelicula P
WHERE P.director IN (SELECT A.nombre
					FROM CS_Actor A
					WHERE A.cod_act IN (SELECT X.cod_act
										FROM CS_Actua X
										WHERE X.cod_peli = P.cod_peli)
				)
ORDER BY P.titulo;

/*12*/
SELECT cod_peli, titulo
FROM CS_Pelicula P
WHERE cod_peli IN (
          SELECT cod_peli
					FROM CS_Clasificacion 
					WHERE cod_gen IN(
                  SELECT cod_gen
									FROM CS_Genero 
									WHERE nombre = 'Comedia')
					)
ORDER BY P.titulo;

/*13*/
SELECT P.cod_peli, P.titulo
FROM CS_Pelicula P
WHERE P.cod_lib IN (SELECT L.cod_lib
					FROM CS_Libro L
					WHERE L.anyo < 1950)
ORDER BY P.titulo;

/*14*/
SELECT cod_pais, nombre
FROM CS_Pais 
WHERE cod_pais IN(
          SELECT cod_pais
					FROM CS_Actor
					WHERE cod_act IN(
                    SELECT cod_act
										FROM CS_Actua 
										WHERE cod_peli IN(
                              SELECT cod_peli
															FROM CS_Pelicula 
															WHERE cod_peli IN(
                                        SELECT cod_peli
																				FROM CS_Clasificacion 
																				WHERE cod_gen IN(
                                                  SELECT cod_gen
                                                  FROM CS_Genero
                                                  WHERE nombre = 'Comedia')
															)
										)
					))
ORDER BY nombre;

/*16*/

SELECT cod_act, nombre
From CS_Actor 
WHERE EXTRACT(YEAR FROM fecha_nac) < 1950
AND cod_act IN (
  SELECT cod_act
  FROM CS_Actua
	WHERE papel LIKE 'Principal')
ORDER BY nombre;

/*17*/

SELECT cod_lib, autor, titulo
FROM CS_Libro 
WHERE cod_lib IN (
          SELECT cod_lib
					FROM CS_Pelicula 
					WHERE anyo > 1989
					AND anyo < 2000)
ORDER BY titulo;

/*18*/

SELECT cod_lib, titulo, autor
FROM CS_Libro
WHERE cod_lib NOT IN(
          SELECT cod_lib
					FROM CS_Pelicula
          WHERE cod_lib IS NOT NULL);

/*19*/

SELECT nombre
FROM CS_Genero
WHERE cod_gen IN 
	(SELECT cod_gen
	FROM CS_Clasificacion
	WHERE cod_peli IN
		(SELECT cod_peli
		FROM CS_Pelicula
		WHERE cod_peli NOT IN
			(SELECT cod_peli
			FROM CS_Actua)))
ORDER BY nombre;

/*20*/

SELECT titulo
FROM CS_Libro
WHERE cod_lib IN
	(SELECT cod_lib
	FROM CS_Pelicula
	WHERE cod_peli NOT IN
		(SELECT cod_peli
		FROM CS_Actua
		WHERE cod_act IN
			(SELECT cod_act
			FROM CS_Actor
			WHERE cod_pais IN
				(SELECT cod_pais
				FROM CS_Pais
				WHERE nombre LIKE 'USA'))))
ORDER BY titulo;

/*21*/

SELECT COUNT(cod_peli)
FROM CS_Pelicula
WHERE cod_peli IN
	(SELECT cod_peli
	FROM CS_Clasificacion
	WHERE cod_gen IN
		(SELECT cod_gen
		FROM CS_Genero
		WHERE nombre LIKE 'Comedia'))
AND cod_peli IN
	(SELECT cod_peli
	FROM CS_Actua
	WHERE papel LIKE 'Secundario'
	AND 1 =
		(SELECT COUNT(cod_act)
		FROM CS_Actor
		WHERE CS_Actor.cod_act = CS_Actua.cod_act));

/*22*/

SELECT MIN(anyo) 
FROM CS_Pelicula
WHERE cod_peli IN
	(SELECT cod_peli
	FROM CS_Actua
	WHERE papel LIKE 'Principal'
	AND cod_act IN
		(SELECT cod_act
		FROM CS_Actor
		WHERE nombre LIKE 'Jude Law'));

/*23*/

SELECT cod_act, nombre
FROM CS_Actor
WHERE fecha_nac = 
	(SELECT MIN(fecha_nac)
	FROM CS_Actor);

/*24*/

SELECT cod_act, nombre, fecha_nac
FROM CS_Actor
WHERE fecha_nac =
	(SELECT MIN(fecha_nac)
	FROM CS_Actor
	WHERE fecha_nac >= '01/01/1940')
AND fecha_nac >= '01/01/1940';

/*25*/

SELECT nombre
FROM CS_Genero
WHERE cod_gen IN
	(SELECT cod_gen
	FROM CS_Clasificacion
	WHERE cod_peli IN	
		(SELECT cod_peli
		FROM CS_Pelicula
		WHERE duracion = 
			(SELECT MAX(duracion)
			FROM CS_Pelicula)));

/*26*/

SELECT cod_lib, titulo
FROM CS_Libro
WHERE cod_lib IN
	(SELECT cod_lib
	FROM CS_Pelicula
	WHERE cod_peli IN
		(SELECT cod_peli
		FROM CS_Actua
		WHERE cod_act IN
			(SELECT cod_act
			FROM CS_Actor
			WHERE cod_pais IN
				(SELECT cod_pais
				FROM CS_Pais
				WHERE nombre LIKE 'España'))))
ORDER BY titulo;

/*27*/

SELECT titulo
FROM CS_Pelicula
WHERE anyo < 1950
AND 1 < (SELECT COUNT(DISTINCT cod_gen)
		FROM CS_Clasificacion
		WHERE CS_Pelicula.cod_peli = CS_Clasificacion.cod_peli)
ORDER BY titulo;

/*28*/

SELECT COUNT(cod_peli)
FROM CS_Pelicula
WHERE 4 > (SELECT COUNT(DISTINCT cod_act)
			FROM CS_Actua
			WHERE CS_Pelicula.cod_peli=CS_Actua.cod_peli);

/*29*/

SELECT DISTINCT director
FROM CS_Pelicula
WHERE 250 < (SELECT SUM(duracion)
			FROM CS_Pelicula p
			WHERE CS_Pelicula.director = p.director);

/*30*/

SELECT DISTINCT EXTRACT(YEAR FROM fecha_nac) AS AÑO
FROM CS_Actor
WHERE 3 < (SELECT COUNT(A.FECHA_NAC)
			FROM CS_Actor A
      WHERE EXTRACT(YEAR FROM CS_Actor.fecha_nac) = EXTRACT(YEAR FROM A.fecha_nac));

/*31*/

SELECT cod_act, nombre
FROM CS_Actor
WHERE fecha_nac =
	(SELECT MAX(fecha_nac)
	FROM CS_Actor 
  WHERE cod_act IN(
    SELECT cod_act
		FROM CS_Actua
		WHERE cod_peli IN
			(SELECT cod_peli
			FROM CS_Pelicula
			WHERE cod_peli IN
				(SELECT cod_peli
				FROM CS_Clasificacion
				WHERE cod_gen = 'DD8'))));

/*.................................*/
/*universally quantified*/

/*32*/

SELECT cod_pais, nombre
FROM CS_Pais
WHERE NOT EXISTS(SELECT *
				FROM CS_Actor
				WHERE  2000 < EXTRACT(YEAR FROM fecha_nac) 
        OR 1900 > EXTRACT(YEAR FROM fecha_nac)
        AND CS_Actor.cod_pais = CS_Pais.cod_pais)
AND EXISTS (SELECT *
			FROM CS_Actor
			WHERE CS_Actor.cod_pais = CS_Pais.cod_pais)
ORDER BY nombre;

/*33*/

SELECT cod_act, nombre
FROM CS_Actor
WHERE NOT EXISTS(SELECT *
				FROM CS_Actua
				WHERE papel <> 'Secundario'
				AND CS_Actor.cod_act = CS_Actua.cod_act)
AND EXISTS (SELECT *
			FROM CS_Actua
			WHERE CS_Actor.cod_act = CS_Actua.cod_act)
ORDER BY nombre;

/*34*/
SELECT A.cod_act, A.nombre
FROM CS_Actor A
WHERE NOT EXISTS (SELECT *
                  FROM CS_Pelicula P
                  WHERE P.director = 'Guy Ritchie'
                  AND NOT EXISTS ( SELECT *
                                  FROM  CS_Actua AC
                                  WHERE AC.cod_act = A.cod_act
                                  AND AC.cod_peli = P.cod_peli))
AND EXISTS (
  SELECT *
  FROM CS_Pelicula P
  WHERE P.director = 'Guy Ritchie');

/*35*/

SELECT A.cod_act, A.nombre
FROM CS_Actor A
WHERE NOT EXISTS (SELECT *
                  FROM CS_Pelicula P
                  WHERE P.director = 'John Steel'
                  AND NOT EXISTS ( SELECT *
                                  FROM  CS_Actua AC
                                  WHERE AC.cod_act = A.cod_act
                                  AND AC.cod_peli = P.cod_peli))
AND EXISTS (
  SELECT *
  FROM CS_Pelicula P
  WHERE P.director = 'John Steel');

/*36*/

SELECT cod_peli, titulo
FROM CS_Pelicula 
WHERE duracion < 100
AND cod_peli IN(
	SELECT cod_peli
	FROM CS_Actua X1
	WHERE cod_act IN(
		SELECT cod_act
		FROM CS_Actor A
		WHERE NOT EXISTS(
			SELECT *
			FROM CS_Actor B 
			WHERE A.cod_pais <> B.cod_pais
			AND B.cod_act IN(
				SELECT X2.cod_act
				FROM CS_Actua X2
				WHERE X1.cod_peli = X2.cod_peli))));

/*37*/

SELECT P.cod_peli, P.titulo, P.anyo
FROM CS_Pelicula P
WHERE NOT EXISTS(
	SELECT *
	FROM CS_Actor A
	WHERE  A.fecha_nac > '31/12/1942'
	AND NOT EXISTS(
		SELECT *
		FROM CS_Actua X
		WHERE P.cod_peli = X.cod_peli
		AND A.cod_act = X.cod_act));

/*38*/

SELECT cod_pais, nombre
FROM CS_Pais
WHERE NOT EXISTS(
	SELECT *
	FROM CS_Actor
	WHERE CS_Actor.cod_pais = CS_Pais.cod_pais
	AND cod_act NOT IN(
		SELECT cod_act
		FROM CS_Actua
		WHERE cod_peli IN (
			SELECT cod_peli
			FROM CS_Pelicula
			WHERE duracion > 120)))
AND EXISTS (
    SELECT *
    FROM cs_actor
    WHERE cs_actor.cod_pais = cs_pais.cod_pais
    AND cod_act IN (
        SELECT cod_act
        FROM cs_actua
    ))
ORDER BY nombre;
/*.................................*/
/*grouped queries*/
/*39*/
SELECT L.cod_lib, L.titulo, COUNT(P.cod_peli)
FROM CS_Pelicula P, CS_Libro L
WHERE L.cod_lib = P.cod_lib
GROUP BY L.cod_lib, L.titulo
HAVING COUNT(P.cod_peli)>=2;
/*40*/
SELECT G.cod_gen, G.nombre, COUNT(P.cod_peli), ROUND(AVG(P.duracion))
FROM CS_Pelicula P, CS_Genero G, CS_Clasificacion C
WHERE C.cod_gen = G.cod_gen
AND C.cod_peli = P.cod_peli
GROUP BY G.cod_gen, G.nombre
HAVING COUNT(C.cod_peli)>5
ORDER BY G.nombre;
/*41*/
SELECT P.cod_peli, P.titulo, COUNT(G.cod_gen)
FROM CS_Pelicula P, CS_Genero G, CS_CLASIFICACION C
WHERE C.cod_gen = G.cod_gen
AND C.cod_peli = P.cod_peli
AND P.anyo>2000
GROUP BY P.cod_peli, P.titulo
ORDER BY P.titulo;
/*42*/
SELECT P.director
FROM CS_Pelicula P
WHERE P.director LIKE '%George%'
GROUP BY P.director
HAVING COUNT(P.cod_peli)=2;
/*43*/
SELECT P.cod_peli, P.titulo, COUNT(DISTINCT T.cod_act)
FROM CS_Pelicula P, CS_Actua T, CS_Clasificacion C
WHERE P.cod_peli = T.cod_peli
AND C.cod_peli = P.cod_peli
GROUP BY P.cod_peli, P.titulo
HAVING COUNT(DISTINCT C.cod_gen)=1;

/*44*/
SELECT P.cod_pais, P.nombre, COUNT(A.cod_act)
FROM CS_Pais P, CS_Actor A, CS_Actua X, CS_Pelicula Y
WHERE P.cod_pais = A.cod_pais
AND X.cod_act = A.cod_act
AND X.cod_peli = Y.cod_peli
AND Y.anyo >= 1960
AND Y.anyo < 1970
GROUP BY P.cod_pais, P.nombre
HAVING COUNT(A.cod_act)>0
ORDER BY P.nombre;
/*45*/

SELECT G.cod_gen, G.nombre
FROM CS_Genero G, CS_Clasificacion C
WHERE G.cod_gen = C.cod_gen
GROUP BY G.cod_gen, G.nombre
HAVING COUNT(DISTINCT C.cod_peli) >= ALL (
                    SELECT COUNT(DISTINCT cod_peli)
										FROM CS_Clasificacion
                    GROUP BY cod_gen);

/*46*/

SELECT L.cod_lib, L.titulo, L.autor
FROM CS_Libro L, CS_Pelicula P
WHERE L.cod_lib = P.cod_lib
GROUP BY L.cod_lib, L.titulo, L.autor
HAVING COUNT(DISTINCT P.cod_peli) >= 
	ALL (SELECT COUNT(DISTINCT cod_peli)
	FROM CS_Pelicula
  WHERE cod_lib IS NOT NULL
  GROUP BY cod_lib);

/*47*/

SELECT C.cod_pais, C.nombre
FROM CS_Pais C, CS_Actor A, CS_Actua X
WHERE C.cod_pais = A.cod_pais
AND  A.cod_act = X.cod_act
GROUP BY C.cod_pais, C.nombre
HAVING COUNT(DISTINCT X.cod_peli) = 2;

/*48*/

SELECT EXTRACT( YEAR FROM A.fecha_nac), COUNT(cod_act)
FROM CS_Actor A
GROUP BY EXTRACT( YEAR FROM A.fecha_nac)
HAVING COUNT(cod_act) > 3;

/*49*/

SELECT P.cod_peli, P.titulo
FROM CS_Pelicula P, CS_Actua X, CS_Actor A
WHERE P.cod_peli = X.cod_peli
AND X.cod_act = A.cod_act
AND P.duracion < 100
GROUP BY P.cod_peli, P.titulo
HAVING COUNT(DISTINCT A.cod_pais) = 1;


/*.................................*/
/*concatenation queries*/

/*50*/

SELECT P.nombre, cod_pais, COUNT(A.cod_act)
FROM CS_pais P LEFT JOIN CS_Actor A USING(COD_PAIS)
GROUP BY P.nombre, cod_pais
ORDER BY P.nombre;

/*51*/

SELECT cod_lib, L.titulo, count(P.cod_peli)
FROM CS_Libro L LEFT JOIN CS_Pelicula P USING(cod_lib)
WHERE L.anyo > 1980
Group by cod_lib, L.titulo; 

/*52*/

SELECT cod_pais, P.nombre, COUNT(DISTINCT A.cod_act)
FROM CS_Pais P LEFT JOIN CS_Actor A USING (COD_PAIS)
  LEFT JOIN cs_actua ON papel = 'Secundario' AND a.cod_act = cs_actua.cod_act
GROUP BY cod_pais, P.nombre;

/*53*/

SELECT cod_peli, P.titulo, COUNT(DISTINCT C.cod_gen), COUNT (DISTINCT A.cod_act)
FROM CS_Pelicula P LEFT JOIN CS_Clasificacion C USING (cod_peli)
  left JOIN CS_ACTUA A USING(cod_peli)
  WHERE P.duracion >140
GROUP BY cod_peli, P.titulo
ORDER BY P.titulo;

/*.................................*/
/*set operations queries*/

/*54*/

SELECT anyo
FROM CS_Pelicula
WHERE anyo IS NOT NULL
AND anyo NOT LIKE '%9'
UNION
SELECT anyo
FROM CS_Libro
WHERE anyo NOT LIKE '%9'
AND anyo IS NOT NULL;

/*.................................*/
/*other queries*/

/*55*/

SELECT G.cod_gen, G.nombre
FROM CS_Genero G, CS_Clasificacion C, CS_Pelicula P
WHERE G.cod_gen = C.cod_gen
AND C.cod_peli = P.cod_peli
AND P.duracion >= (
  SELECT MAX(duracion)
  FROM CS_Pelicula);

