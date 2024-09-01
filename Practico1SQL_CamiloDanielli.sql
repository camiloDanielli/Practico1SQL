USE practico1;
SELECT * FROM compra;
-- cada parte esta separada por un espacio (linea vacia) y se encuentran en orden alfabetico.
-- parte 1 --
INSERT INTO compra (email, nombre_videojuego, nombre_expansion, valor, fecha)
VALUES ('persona1@gmail.com', 'Project Zomboid', NULL, 429, CURDATE());

INSERT INTO compra (email, nombre_videojuego, nombre_expansion, valor, fecha)
VALUES ('persona1@gmail.com', 'Battlefield 2042', 'Battlefield 2042 Ultimate Edition', 4800, CURDATE());

INSERT INTO compra (email, nombre_videojuego, nombre_expansion, valor, fecha)
VALUES ('persona8@gmail.com', 'Magic: The Gathering Arena', NULL, 0, CURDATE());
INSERT INTO compra (email, nombre_videojuego, nombre_expansion, valor, fecha)
VALUES ('persona8@gmail.com', 'Tower of Fantasy', NULL, 0, CURDATE());

UPDATE videojuegos
SET costo = 500
WHERE nombre = 'Magic: The Gathering Arena';

INSERT INTO compra (email, nombre_videojuego, nombre_expansion, valor, fecha)
VALUES ('persona7@gmail.com', 'Magic: The Gathering Arena', NULL, 500, CURDATE());

INSERT INTO compra (email, nombre_videojuego, nombre_expansion, valor, fecha)
VALUES ('persona9@gmail.com', 'Battlefield 2042', NULL, 2600, CURDATE());

UPDATE videojuegos
SET costo = costo - 200
WHERE nombre = 'Battlefield 2042';

-- Por Restriccion debemos debo sumar valor de juego + expanción, por lo que icluyo consulta para extraer el dato
SELECT costo INTO @expansion FROM expansiones WHERE nombre = 'Battlefield 2042 Ultimate Edition';
-- asi que lo hacemos es sumar el valor al registro ya existente
UPDATE compra
SET nombre_expansion = 'Battlefield 2042 Ultimate Edition', valor = valor + @expansion
WHERE email = 'persona9@gmail.com'
  AND nombre_videojuego = 'Battlefield 2042'
  AND nombre_expansion IS NULL;

-- Va a dar advertencia porque no lleva where
-- pero esta bien por sé lo que hago (o mejor dicho como volver todo a la normalidad si le erro)

UPDATE videojuegos
SET costo = costo * 1.10;

-- Parte 2

SELECT nombre_videojuego
FROM juega
WHERE email = 'persona1@gmail.com'
ORDER BY fecha DESC
LIMIT 1;

SELECT personas.nombre, personas.apellido
FROM amigos
JOIN personas ON amigos.email_amigo = personas.email
WHERE amigos.email_persona = 'persona1@gmail.com';

-- aqui uso DISTINCT porque no quiero que se repitan las entradas (no pasa con los datos de la incerciones actuales, pero seria incorrecto no ponerlo)
SELECT nombre_videojuego, COUNT(DISTINCT email) AS cantidad_jugadores
FROM juega
WHERE nombre_videojuego = 'Project Zomboid';
-- para la siguientes partes que dependen de esta
-- añado datos random para probar mejor
INSERT INTO juega (email, nombre_videojuego, fecha) VALUES
('persona4@gmail.com', 'Project Zomboid', '2024-02-01'),
('persona5@gmail.com', 'Project Zomboid', '2024-02-02'),
('persona6@gmail.com', 'Project Zomboid', '2024-02-03'),
('persona7@gmail.com', 'Magic: The Gathering Arena', '2024-02-04'),
('persona8@gmail.com', 'Battlefield 2042', '2024-02-05'),
('persona2@gmail.com', 'Battlefield 2042', '2024-02-06'),
('persona3@gmail.com', 'Tower of Fantasy', '2024-02-07'),
('persona10@gmail.com', 'Magic: The Gathering Arena', '2024-02-08'),
('persona1@gmail.com', 'Battlefield 2042', '2024-02-09'),
('persona9@gmail.com', 'Magic: The Gathering Arena', '2024-02-10');

SELECT YEAR(CURDATE()) - YEAR(personas.fecha_nacimiento) AS edad, COUNT(DISTINCT juega.email) AS cantidad_jugadores
FROM juega
JOIN personas ON juega.email = personas.email
WHERE juega.nombre_videojuego = 'Tower of Fantasy'
GROUP BY edad;

SELECT
    juega.nombre_videojuego,
    CASE
        WHEN YEAR(CURDATE()) - YEAR(personas.fecha_nacimiento) >= 18 THEN 'Mayor de edad'
        ELSE 'Menor de edad'
    END AS grupo_edad,
    COUNT(DISTINCT juega.email) AS cantidad_jugadores
FROM juega
JOIN personas ON juega.email = personas.email
WHERE juega.nombre_videojuego = 'Project Zomboid'
GROUP BY grupo_edad;

SELECT compra.nombre_videojuego, SUM(compra.valor) AS ganancias_totales
FROM compra
GROUP BY compra.nombre_videojuego
ORDER BY ganancias_totales DESC
LIMIT 1;

SELECT personas.email, personas.nombre
FROM personas
LEFT JOIN amigos ON personas.email = amigos.email_persona
WHERE amigos.email_persona IS NULL;

SELECT SUM(c.valor) AS total_invertido, c.email
FROM compra c
WHERE c.email = 'persona9@gmail.com';

SELECT nombre_videojuego, COUNT(*) AS cantidad
FROM expansiones
GROUP BY nombre_videojuego;

SELECT c.email, SUM(c.valor) AS total
FROM compra c
GROUP BY c.email
ORDER BY total DESC;

