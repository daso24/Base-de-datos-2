/* Parte 1: justificacion y respuestas teoricas
   
   1 justificacion:
   Las tres operaciones (reducir cupo, registrar inscripcion y registrar pago) deben 
   formar parte de una misma transacción obligatoriamente porque conforman una unidad 
   de trabajo indivisible. Si una de ellas se ejecutara de forma independiente y las 
   otras fallaran, la base de datos quedaría inconsistente (por ejemplo, un estudiante 
   ocupando un lugar en el grupo sin haber pagado, o perdiendo un cupo que nadie usa).

   2 operaciones en la misma transaccion:
   Las tres operaciones forman parte de la misma transacción:
   - Reducir el cupo del grupo.
   - Registrar la inscripción.
   - Registrar el pago.

   3 ¿COMMIT o ROLLBACK cuando falla el paso 3?:
   El sistema debe ejecutar un ROLLBACK. Como el paso 3 (pago) fallo, la transaccion 
   queda incompleta y debe cancelarse de inmediato para no guardar datos a medias.

   4. ¿Que sucede con los cambios de los pasos 1 Y 2?:
   Al ejecutar el ROLLBACK, todos los cambios previos se deshacen automaticamente. 
   El cupo del grupo vuelve a su estado original y la inscripción se descarta por 
   completo, quedando la base de datos exactamente como estaba antes de empezar.

   5. Propiedad ACID principal:
   La propiedad clave aquí es la ATOMICIDAD. Esta propiedad establece el principio 
   de "todo o nada", dice que todas las instrucciones de una transacción se apliquen 
   exitosamente en conjunto, o que ninguna de ellas se guarde si ocurre algún error.

   6. Flujo del sistema:
   [inicio: BEGIN TRANSACTION]
               │
               ▼
   [Paso 1: UPDATE cupo_maximo en tabla grupos]
               │
               ▼
   [Paso 2: INSERT en tabla inscripciones]
               │
               ▼
   [Paso 3: INSERT en tabla pagos] ──► ¿Fallo el pago? ──► SÍ ──► [ROLLBACK] ──► [FIN]
                                            │
                                            └──► NO  ──► [COMMIT]   ──► [FIN]
*/


-- Parte 2: script de la transaccion (escenario de fallo con ROLLBACK)

BEGIN; 

-- 1: Reducir en 1 el cupo del grupo 
UPDATE grupos 
SET cupo_maximo = cupo_maximo - 1 
WHERE id_grupo = 1;

-- 2: Registrar la inscripcion 
INSERT INTO inscripciones (id_estudiante, id_grupo, id_periodo) 
VALUES (4, 1, 2);

-- 3: El registro del pago (Falla intencional)
-- Se intenta insertar un monto negativo (-500.00), lo cual provocara un error
-- en la base de datos debido al CONSTRAINT chk_monto CHECK (monto > 0)
INSERT INTO pagos (id_estudiante, id_periodo, concepto, monto, metodo_pago, referencia)
VALUES (4, 2, 'Inscripción', -500.00, 'Tarjeta', 'REF_ERROR');

-- Al detectarse el error provocado en el paso 3, el sistema aborta y revierte todo:
ROLLBACK;

-- COMPROBACIÓN:
-- Si se consulta las tablas despues del ROLLBACK, el cupo del grupo 1 
-- seguira intacto y el estudiante 4 no aparecerá en la tabla de inscripciones