SELECT nombre
FROM Autor
WHERE nacionalidad = 'Argentina';

SELECT titulo
FROM Obra
WHERE titulo LIKE'%mundo%';

SELECT DISTINCT id_lib, num_obras
FROM Libro
WHERE año < 1990
AND num_obras > 1;

SELECT COUNT(DISTINCT id_lib)
FROM Libro
WHERE año IS NOT NULL;

SELECT COUNT(DISTINCT id_lib)
FROM Libro
WHERE num_obras > 1;

SELECT id_lib
FROM Libro
WHERE año = '1997'
AND titulo IS NULL;

SELECT titulo
FROM Libro
WHERE titulo IS NOT NULL
ORDER BY titulo DESC;

SELECT SUM(num_obras)
FROM Libro
WHERE año >= 1990
AND año <= 1999;

/************************/

SELECT COUNT(DISTINCT A.autor_id)
FROM Autor A, Escribir E, Obra O
WHERE A.autor_id=E.autor_id
AND O.cod_ob = E.cod_ob
AND O.titulo LIKE '%ciudad%';

SELECT O.titulo
FROM Obra O, Escribir E, Autor A
WHERE A.autor_id=E.autor_id
AND O.cod_ob = E.cod_ob
AND A.nombre = 'Camús, Albert';

SELECT A.nombre
FROM Obra O, Escribir E, Autor A
WHERE A.autor_id=E.autor_id
AND O.cod_ob = E.cod_ob
AND O.titulo = 'La tata';

SELECT F.nombre
FROM Amigo F, Leer L, Obra O, Escribir E
WHERE F.num = L.num
AND L.cod_ob = O.cod_ob
AND O.cod_ob = E.cod_ob
AND E.autor_id = 'RUKI';

SELECT DISTINCT L.titulo, L.id_lib
FROM Libro L, Esta_en E
WHERE L.id_lib = E.id_lib
AND L.titulo IS NOT NULL
AND 1 < (
  SELECT COUNT(DISTINCT cod_ob)
  FROM Esta_en);

/*************************************/

SELECT A.nombre, O.titulo
FROM Autor A, Obra O, Escribir E
WHERE A.autor_id = E.autor_id
AND E.cod_ob = O.cod_ob
AND 1 = (
  SELECT COUNT(DISTINCT autor_id)
  FROM Escribir
  WHERE Escribir.autor_id = A.autor_id)
AND A.nacionalidad = 'Francesa';

SELECT COUNT(DISTINCT autor_id) AS sin_obra
FROM Autor
WHERE autor_id NOT IN (
  SELECT autor_id
  FROM Escribir);
  
SELECT nombre
FROM Autor
WHERE autor_id NOT IN (
  SELECT autor_id
  FROM Escribir);
  
SELECT A.nombre
FROM Autor A
WHERE A.nacionalidad = 'Española'
AND A.autor_id IN(
  SELECT E2.autor_id
  FROM Escribir E2
  WHERE  1 <(
    SELECT COUNT(DISTINCT E1.cod_ob)
    FROM Escribir E1
    WHERE E1.autor_id = E2.autor_id));
    
SELECT nombre
FROM Autor 
WHERE autor_id IN(
  SELECT autor_id
  FROM Escribir
  WHERE cod_ob IN(
    SELECT cod_ob
    FROM Obra
    WHERE cod_ob IN(
      SELECT cod_ob
      FROM Esta_en )
    AND 2 <(
      SELECT COUNT(DISTINCT id_lib)
      FROM Esta_en
      WHERE Esta_en.cod_ob = Obra.cod_ob)))
AND nacionalidad = 'Española';
  
SELECT DISTINCT O.titulo, O.cod_ob
FROM Obra O, Escribir E
WHERE E.cod_ob = O.cod_ob
AND 1 < (
  SELECT COUNT(DISTINCT E2.autor_id)
  FROM Escribir E2
  WHERE E.cod_ob = E2.cod_ob);
  
/**********************************/

SELECT nombre
FROM Amigo
WHERE NOT EXISTS(
  SELECT *
  FROM Escribir
  WHERE autor_id = 'RUKI'
  AND cod_ob NOT IN(
    SELECT cod_ob
    FROM Obra
    WHERE cod_ob IN(
      SELECT cod_ob
      FROM Leer
      WHERE Leer.num = Amigo.num)));
      
SELECT nombre
FROM Amigo
WHERE NOT EXISTS(
  SELECT *
  FROM Escribir
  WHERE autor_id = 'GUAP'
  AND cod_ob NOT IN (
    SELECT cod_ob
    FROM Obra
    WHERE cod_ob IN(
      SELECT cod_ob
      FROM Leer
      WHERE Leer.num = Amigo.num)))
AND EXISTS(
  SELECT *
  FROM Escribir
  WHERE autor_id = 'GUAP' 
  AND cod_ob IN(
    SELECT cod_ob
    FROM Obra
    WHERE cod_ob IN(
      SELECT cod_ob
      FROM Leer
      WHERE Leer.num = Amigo.num)));
      
SELECT DISTINCT nombre
FROM Amigo
WHERE NOT EXISTS(
  SELECT *
  FROM Obra
  WHERE cod_ob IN(
    SELECT cod_ob
    FROM Escribir
    WHERE autor_id IS NOT NULL)
  AND NOT EXISTS(
    SELECT * 
    FROM Leer
    WHERE Leer.num = Amigo.num
    AND Leer.cod_ob = Obra.cod_ob))
;
      
SELECT DISTINCT nombre 
FROM Amigo
WHERE NOT EXISTS (
  SELECT *
  FROM Escribir
  WHERE autor_id = 'CAMA'
  AND NOT EXISTS(
    SELECT *
    FROM Obra O, Leer L
    WHERE O.cod_ob = Escribir.cod_ob
    AND L.cod_ob = O.cod_ob
    AND L.num = Amigo.num));
      
SELECT nombre
FROM Amigo
WHERE NOT EXISTS(
  SELECT *
  FROM Escribir
  WHERE autor_id <> 'GUAP'
  AND NOT EXISTS(
    SELECT *
    FROM Obra 
    WHERE Obra.cod_ob = Escribir.cod_ob
    AND cod_ob IN(
      SELECT cod_ob
      FROM Leer
      WHERE Leer.num = Amigo.num)));

SELECT nombre
FROM Amigo
WHERE NOT EXISTS(
  SELECT *
  FROM Escribir
  WHERE 1 = (
    SELECT COUNT (DISTINCT autor_id)
    FROM Autor
    WHERE Autor.autor_id = Escribir.autor_id)
  AND NOT EXISTS(
    SELECT *
    FROM Obra
    WHERE Obra.cod_ob = Escribir.cod_ob
    AND cod_ob IN(
      SELECT cod_ob
      FROM Leer
      WHERE Leer.num = Amigo.num)));

/************************************/

SELECT DISTINCT L.id_lib, L.titulo
FROM Libro L, Esta_en E
WHERE L.id_lib = E.id_lib
AND L.titulo IS NOT NULL
GROUP BY L.id_lib, L.titulo
HAVING 1<COUNT(DISTINCT E.cod_ob);

SELECT DISTINCT F.nombre, COUNT(DISTINCT L.cod_ob)
FROM Amigo F, Leer L
WHERE F.num = L.num
GROUP BY F.nombre
HAVING 3 < COUNT(DISTINCT L.cod_ob);

SELECT T.tematica, COUNT (DISTINCT O.cod_ob)
FROM Tema T, Obra O
WHERE O.tematica IS NOT NULL
AND T.tematica = O.tematica
GROUP BY T.tematica;

SELECT O.tematica, COUNT (DISTINCT O.cod_ob)
FROM Obra O
GROUP BY O.tematica;

SELECT A.nombre
FROM Autor A, Escribir E
WHERE A.autor_id = E.autor_id
GROUP BY A.nombre
HAVING COUNT(DISTINCT E.cod_ob) >= ALL(
  SELECT COUNT (DISTINCT cod_ob)
  FROM Escribir
  GROUP BY autor_id);
  
SELECT A.nacionalidad
FROM Autor A, Escribir E
WHERE A.autor_id = E.autor_id
AND E.cod_ob IS NOT NULL
GROUP BY A.nacionalidad
HAVING count(DISTINCT A.nacionalidad) < ALL(
  SELECT count(DISTINCT nacionalidad)
  FROM Autor
  GROUP BY A.nacionalidad);

SELECT A.nombre
FROM Amigo A, Leer L
WHERE A.num = L.num
GROUP BY A.nombre
HAVING COUNT(L.cod_ob) >= ALL(
  SELECT COUNT (cod_ob)
  FROM Leer
  Group BY cod_ob);

/************************************/

SELECT L.titulo, L.id_lib
FROM Libro L, Esta_en E
WHERE L.id_lib = E.id_lib
AND L.titulo IS NOT NULL
GROUP BY L.titulo, L.id_lib
HAVING 1 = COUNT(DISTINCT E.cod_ob);

SELECT DISTINCT L.titulo
FROM Obra O, Libro L, Esta_en E
WHERE E.id_lib = L.id_lib
AND E.cod_ob = O.cod_ob;

SELECT nombre 
FROM Amigo 
WHERE EXISTS(
  SELECT *
  FROM Obra
  WHERE cod_ob IN(
    SELECT cod_ob
    FROM Escribir
    Where autor_id = 'CAMA')
  AND EXISTS(
    SELECT *
    FROM Leer
    WHERE Leer.cod_ob = Obra.cod_ob
    AND Leer.num = Amigo.num));

SELECT nombre 
FROM Amigo 
WHERE NOT EXISTS(
  SELECT *
  FROM Obra
  WHERE cod_ob IN(
    SELECT cod_ob
    FROM Escribir
    Where autor_id = 'CAMA')
  AND EXISTS(
    SELECT *
    FROM Leer
    WHERE Leer.cod_ob = Obra.cod_ob
    AND Leer.num = Amigo.num));

SELECT nombre 
FROM Amigo 
WHERE NOT EXISTS(
  SELECT *
  FROM Obra
  WHERE cod_ob IN(
    SELECT cod_ob
    FROM Escribir
    Where autor_id = 'CAMA')
  AND EXISTS(
    SELECT *
    FROM Leer
    WHERE Leer.cod_ob = Obra.cod_ob
    AND Leer.num = Amigo.num))
AND EXISTS(
  SELECT *
  FROM Leer
  WHERE Leer.num = Amigo.num
  AND cod_ob IS NOT NULL);
  
SELECT A.nombre 
FROM Amigo A, Leer L
WHERE A.num = L.num
GROUP BY A.nombre
HAVING COUNT(DISTINCT L.cod_ob) >= ALL(
  SELECT COUNT(cod_ob)
  FROM Leer
  Group BY cod_ob);




























