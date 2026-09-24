/* Parte 1: Respuestas a las preguntas

   1. ¿Para qué sirve BEGIN?
   Sirve para iniciar una nueva transaccion, 
   indicando al sistema gestor de bases de datos que las instrucciones SQL posteriores deben ser 
   tratadas como una unica unidad logica de trabajo indivisible
   
   2. ¿Qué ocurrió cuando utilizaste COMMIT?
   El cambio realizado durante la transaccion (la actualizacion del numero de telefono a '6129999999' 
   para el estudiante 1) se confirmo y guardo de manera permanente en la base de datos
   
   3. ¿Qué ocurrió cuando utilizaste ROLLBACK?
   La transacción se cancelo por completo. El cambio que se habia intentado (modificar el estado del estudiante 2 a 'INACTIVO') 
   fue deshecho de forma automática, dejando el registro tal como estaba antes de ejecutar BEGIN
   
   4. ¿Cuál es la diferencia entre COMMIT y ROLLBACK?
   La diferencia radica en el resultado final de la transaccion: COMMIT aprueba y 
   guarda de forma definitiva todos los cambios realizados, mientras que ROLLBACK los rechaza, revierte y 
   restaura la base de datos a su estado original previo al inicio de la transacción.
*/

-- Parte 2: Script de las transacciones 

-- Ejercicio 1 — COMMIT

-- consulta primero al estudiante con id_estudiante = 1
SELECT *
FROM estudiantes
WHERE id_estudiante = 1;

-- inicia una transaccion
BEGIN;

-- cambia el telefono del estudiante
UPDATE estudiantes
SET telefono = '6129999999'
WHERE id_estudiante = 1;

-- consulta nuevamente al estudiante para observar el cambio temporal
SELECT *
FROM estudiantes
WHERE id_estudiante = 1;

-- confirma el cambio permanentemente
COMMIT;

-- se vuelve a realizar el SELECT y se comprueba que el nuevo telefono quedo guardado
SELECT *
FROM estudiantes
WHERE id_estudiante = 1;


-- Ejercicio 2 — ROLLBACK

-- inicia una nueva transacción
BEGIN;

-- cambia su estado
UPDATE estudiantes
SET estado = 'INACTIVO'
WHERE id_estudiante = 2;

-- comprueba el cambio dentro de la transaccion activa
SELECT *
FROM estudiantes
WHERE id_estudiante = 2;

-- ahora cancela la modificacion
ROLLBACK;

-- se consulta nuevamente para comprobar que el estado volvio a 'ACTIVO'
SELECT *
FROM estudiantes
WHERE id_estudiante = 2;