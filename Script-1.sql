/* =========================================================
   1. TRIGGER - VALIDAR CUPO DEL GRUPO
   ========================================================= */

CREATE OR REPLACE FUNCTION validar_cupo_grupo()
RETURNS TRIGGER
AS $$
DECLARE
    total_inscritos INT;
    limite_grupo INT;
BEGIN

	--obtener el total de inscritos
    SELECT COUNT(*)
    INTO total_inscritos
    FROM inscripciones
    WHERE id_grupo = NEW.id_grupo
      AND estado = 'INSCRITO';


	--total de cupos maximos
    SELECT cupo_maximo
    INTO limite_grupo
    FROM grupos
    WHERE id_grupo = NEW.id_grupo;


    IF total_inscritos >= limite_grupo THEN
        RAISE EXCEPTION
        'No se puede realizar la inscripción. El grupo está lleno.';
    END IF;


    RETURN NEW;

END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER trg_validar_cupo_grupo
BEFORE INSERT
ON inscripciones
FOR EACH ROW
EXECUTE FUNCTION validar_cupo_grupo();



/* =========================================================
   PRUEBA DEL TRIGGER
   ========================================================= */

SELECT
    g.id_grupo,
    m.nombre AS materia,
    g.grupo,
    g.cupo_maximo,
    COUNT(i.id_inscripcion) AS alumnos_inscritos
FROM grupos g
INNER JOIN materias m
    ON g.id_materia = m.id_materia
LEFT JOIN inscripciones i
    ON g.id_grupo = i.id_grupo
    AND i.estado = 'INSCRITO'
GROUP BY
    g.id_grupo,
    m.nombre,
    g.grupo,
    g.cupo_maximo
ORDER BY g.id_grupo;


/*
Ejemplo:

INSERT INTO inscripciones
(id_estudiante, id_grupo, id_periodo)
VALUES
(4, 1, 2);
*/


--ejercicio 2

CREATE OR REPLACE FUNCTION validar_monto()
RETURNS TRIGGER
AS $$
BEGIN
    IF NEW.monto > 20000 THEN
        RAISE EXCEPTION 'El monto supera el límite permitido.';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER trg_validar_monto
BEFORE INSERT
ON pagos
FOR EACH ROW
EXECUTE FUNCTION validar_monto();

--prueba de trigger

-- consulta para verificar los pagos actuales
SELECT * FROM pagos ORDER BY id_pago;

/*
ejemplo 1: fallara y lanzara el error monto:$25,000

INSERT INTO pagos
(id_estudiante, id_periodo, concepto, monto, metodo_pago, referencia)
VALUES
(1, 2, 'Colegiatura Anual', 25000.00, 'Transferencia', 'REF_ERROR');
*/

/*
ejemplo 2: registrara correctamente monto:$15,000

INSERT INTO pagos
(id_estudiante, id_periodo, concepto, monto, metodo_pago, referencia)
VALUES
(1, 2, 'Colegiatura Semestral', 15000.00, 'Transferencia', 'REF_EXITO');
*/




/* =========================================================
   5. PROCEDIMIENTO - CAMBIAR ESTADO DE ESTUDIANTE
   ========================================================= */

CREATE OR REPLACE PROCEDURE cambiar_estado_estudiante(
    p_matricula VARCHAR,
    p_estado VARCHAR
)
LANGUAGE plpgsql
AS $$
BEGIN

    UPDATE estudiantes
    SET estado = p_estado
    WHERE matricula = p_matricula;


    IF NOT FOUND THEN

        RAISE EXCEPTION
        'No existe un estudiante con la matrícula %',
        p_matricula;

    END IF;


    RAISE NOTICE
    'Estado del estudiante actualizado correctamente.';

END;
$$;

/* =========================================================
   EJECUTAR PROCEDIMIENTO
   ========================================================= */

CALL cambiar_estado_estudiante(
    '2024001',
    'INACTIVO'
);


/* Verificar */

SELECT
    matricula,
    nombre,
    apellido,
    estado
FROM estudiantes
WHERE matricula = '2024001';

--select * from estudiantes e 


--1.7 | Actividad: CREACION DE Procedimiento Almacenado

CREATE OR REPLACE PROCEDURE cambiar_docente_grupo(
    p_id_grupo INT,
    p_id_nuevo_docente INT
)
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE grupos
    SET id_docente = p_id_nuevo_docente
    WHERE id_grupo = p_id_grupo;
END;
$$;

--prueba cambiar_docente-grupo
CALL cambiar_docente_grupo(1, 2);

SELECT g.id_grupo, g.id_docente, d.nombre, d.apellido 
FROM grupos g
INNER JOIN docentes d ON g.id_docente = d.id_docente
WHERE g.id_grupo = 1;
