-- tabla "acceso"
DROP TABLE IF EXISTS acceso CASCADE;

CREATE TABLE acceso (
    id_acceso SERIAL PRIMARY KEY,
    id_estudiante INT NOT NULL,
    correo VARCHAR(100) NOT NULL UNIQUE,
    contrasena VARCHAR(255) NOT NULL,

    CONSTRAINT fk_acceso_estudiante
        FOREIGN KEY (id_estudiante)
        REFERENCES estudiantes(id_estudiante)
        ON DELETE CASCADE
);

-- datos de prueba
INSERT INTO acceso (id_estudiante, correo, contrasena) VALUES
(1, 'ana.garcia@uabcs.mx', 'Password123'),
(2, 'carlos.perez@uabcs.mx', 'Segura2026'),
(3, 'maria.lopez@uabcs.mx', 'ClaveSecreta');

--procedimiento almacenado
CREATE OR REPLACE PROCEDURE pr_login(
    IN p_correo VARCHAR(100),
    IN p_contrasena VARCHAR(255),
    INOUT p_resultado VARCHAR(50) DEFAULT NULL
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_coincidencia INT;
BEGIN
    SELECT COUNT(*)
    INTO v_coincidencia
    FROM acceso
    WHERE correo = p_correo 
      AND contrasena = p_contrasena;

    IF v_coincidencia > 0 THEN
        p_resultado := 'Acceso Correcto';
    ELSE
        p_resultado := 'Acceso Denegado';
    END IF;
END;
$$;

-- pruebas
--debe retornar acceso correcto
CALL pr_login('ana.garcia@uabcs.mx', 'Password123', NULL); 

--debe retornar acceso denegado
CALL pr_login('carlos.perez@uabcs.mx', 'PasswordMala', NULL);