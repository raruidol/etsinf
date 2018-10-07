SELECT codigo, tipo, color, premio
FROM MAILLOT;

SELECT dorsal, nombre
FROM Ciclista
WHERE edad <= 25;

SELECT nompuerto, altura
FROM Puerto
WHERE categoria = 'E';

SELECT netapa
FROM etapa
WHERE salida = llegada;

SELECT COUNT(*)
FROM Ciclista;

SELECT COUNT(*)
FROM Ciclista
WHERE edad > 25;

SELECT COUNT(nomeq)
FROM Equipo;

SELECT AVG(edad)
FROM Ciclista;

SELECT MIN(altura), MAX(altura)
FROM Puerto;

/********************************/

SELECT P.nompuerto, P.categoria
FROM Puerto P, ciclista C
WHERE P.dorsal = C.dorsal
AND C.nomeq = 'Banesto';

SELECT P.nompuerto, P.netapa, E.km
FROM Puerto P, Etapa E
WHERE E.netapa = P.netapa;

SELECT T.nomeq, T.director
FROM Equipo T
WHERE EXISTS(
  SELECT *
  FROM Ciclista C
  WHERE C.edad > 33
  AND T.nomeq = C.nomeq) ;
  
SELECT DISTINCT C.nombre, M.color
FROM Ciclista C, Llevar L, Maillot M
WHERE C.dorsal =  L.dorsal
AND M.codigo = L.codigo;

SELECT DISTINCT C.nombre, E.netapa
FROM Ciclista C, Etapa E, Llevar L, Maillot M
WHERE C.dorsal = E.dorsal
AND C.dorsal = L.dorsal
AND L.codigo = M.codigo
AND M.color = 'Amarillo';

SELECT netapa
FROM etapa
WHERE salida NOT IN(
  SELECT llegada 
  FROM etapa);

/*********************************/

SELECT netapa, salida
FROM etapa
WHERE netapa NOT IN(
  SELECT netapa
  FROM puerto);
  
SELECT AVG(edad)
FROM Ciclista
WHERE dorsal IN(
  SELECT dorsal
  FROM etapa);
  
SELECT nompuerto
FROM Puerto
WHERE altura > (
  SELECT AVG(altura)
  FROM Puerto);
  
SELECT Salida, llegada
FROM Etapa
WHERE netapa IN(
  SELECT netapa
  FROM Puerto
  WHERE pendiente >= ALL(
    SELECT pendiente
    FROM Puerto));
    
SELECT nombre
FROM ciclista
WHERE edad <= ALL(
  SELECT edad
  FROM ciclista);
  
SELECT nombre 
FROM ciclista
WHERE 1 < (
  SELECT COUNT(*)
  FROM puerto
  WHERE puerto.dorsal = ciclista.dorsal);
  
/***********************************/

SELECT e1.netapa
FROM etapa e1
WHERE NOT EXISTS(
  SELECT * 
  FROM Puerto
  WHERE 700 > pendiente
  AND NOT EXISTS(
    SELECT *
    FROM etapa e2
    WHERE e2.netapa = e1.netapa))
AND EXISTS (
    SELECT *
    FROM puerto
    WHERE e1.netapa = netapa
);




