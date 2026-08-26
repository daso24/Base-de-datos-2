DROP TABLE IF EXISTS estudiantes CASCADE;
DROP TABLE IF EXISTS materias CASCADE;
DROP TABLE IF EXISTS docentes CASCADE;
DROP TABLE IF EXISTS carreras CASCADE;
DROP TABLE IF EXISTS facultades CASCADE;
DROP TABLE IF EXISTS aulas CASCADE;
DROP TABLE IF EXISTS periodos_academicos CASCADE;
DROP TABLE IF EXISTS "Alumno" CASCADE;
DROP TABLE IF EXISTS "Carrera" CASCADE;

CREATE TABLE facultades (
    id_facultad SERIAL PRIMARY KEY,	
    nombre VARCHAR(150) NOT NULL,
    codigo VARCHAR(10) UNIQUE NOT NULL,
    decano VARCHAR(100),
    telefono VARCHAR(20)
);

CREATE TABLE carreras (
    id_carrera SERIAL PRIMARY KEY,
    id_facultad INT NOT NULL,
    nombre VARCHAR(150) NOT NULL,
    codigo VARCHAR(10) UNIQUE NOT NULL,
    duracion_semestres INT NOT NULL,
    estado VARCHAR(20) DEFAULT 'ACTIVA',

    CONSTRAINT fk_carrera_facultad
        FOREIGN KEY (id_facultad)
        REFERENCES facultades(id_facultad)
);

CREATE TABLE estudiantes (
    id_estudiante SERIAL PRIMARY KEY,
    matricula VARCHAR(20) UNIQUE NOT NULL,
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    telefono VARCHAR(20),
    fecha_nacimiento DATE,
    id_carrera INT NOT NULL,
    fecha_ingreso DATE DEFAULT CURRENT_DATE,
    estado VARCHAR(20) DEFAULT 'ACTIVO',

    CONSTRAINT fk_estudiante_carrera
        FOREIGN KEY (id_carrera)
        REFERENCES carreras(id_carrera)
);

CREATE TABLE docentes (
    id_docente SERIAL PRIMARY KEY,
    numero_empleado VARCHAR(20) UNIQUE NOT NULL,
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    telefono VARCHAR(20),
    id_facultad INT NOT NULL,
    es_tiempo_completo BOOLEAN DEFAULT FALSE,

    CONSTRAINT fk_docente_facultad
        FOREIGN KEY (id_facultad)
        REFERENCES facultades(id_facultad)
);

CREATE TABLE materias (
    id_materia SERIAL PRIMARY KEY,
    id_carrera INT NOT NULL,
    clave VARCHAR(20) UNIQUE NOT NULL,
    nombre VARCHAR(150) NOT NULL,
    creditos INT NOT NULL,
    tipo VARCHAR(50),
    descripcion TEXT,

    CONSTRAINT fk_materia_carrera
        FOREIGN KEY (id_carrera)
        REFERENCES carreras(id_carrera)
);


CREATE TABLE aulas (
    id_aula SERIAL PRIMARY KEY,
    codigo VARCHAR(20) UNIQUE NOT NULL,
    edificio VARCHAR(100),
    capacidad INT NOT NULL,
    tipo VARCHAR(50)
);

CREATE TABLE periodos_academicos (
    id_periodo SERIAL PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    fecha_inicio DATE NOT NULL,
    fecha_fin DATE NOT NULL,
    estado VARCHAR(20) DEFAULT 'ACTIVO'
);

INSERT INTO facultades (nombre, codigo, decano, telefono) VALUES
('Facultad de Ingeniería', 'FING', 'Dr. Roberto Martínez', '6121234567'),
('Facultad de Ciencias', 'FCIE', 'Dra. Elena Gómez', '6129876543');

INSERT INTO carreras (id_facultad, nombre, codigo, duracion_semestres) VALUES
(1, 'Ingeniería en Desarrollo de Software', 'IDS', 8),
(1, 'Ingeniería en Inteligencia Artificial', 'IIA', 8),
(2, 'Licenciatura en Matemáticas', 'LMAT', 8);

INSERT INTO docentes (numero_empleado, nombre, apellido, email, telefono, id_facultad, es_tiempo_completo) VALUES
('EMP001', 'Pedro', 'Martínez', 'pedro@universidad.mx', '6125551111', 1, TRUE),
('EMP002', 'Sofía', 'Hernández', 'sofia@universidad.mx', '6125552222', 1, TRUE),
('EMP003', 'Miguel', 'García', 'miguel@universidad.mx', '6125553333', 2, FALSE);

INSERT INTO materias (id_carrera, clave, nombre, creditos, tipo, descripcion) VALUES
(1, 'IDS101', 'Metodología de la Programación', 8, 'Obligatoria', 'Fundamentos de programación'),
(1, 'IDS201', 'Programación Web', 8, 'Obligatoria', 'Desarrollo de aplicaciones web'),
(1, 'IDS301', 'Base de Datos II', 8, 'Obligatoria', 'Bases de datos avanzadas'),
(2, 'ITC101', 'Redes de Computadoras', 7, 'Obligatoria', 'Fundamentos de redes');

INSERT INTO aulas (codigo, edificio, capacidad, tipo) VALUES
('A-101', 'Edificio A', 30, 'Laboratorio'),
('A-102', 'Edificio A', 40, 'Aula'),
('B-201', 'Edificio B', 25, 'Laboratorio'),
('B-202', 'Edificio B', 35, 'Aula');

INSERT INTO periodos_academicos (nombre, fecha_inicio, fecha_fin, estado) VALUES
('2026-1', '2026-01-20', '2026-06-15', 'FINALIZADO'),
('2026-2', '2026-08-10', '2026-12-15', 'ACTIVO');

INSERT INTO estudiantes (matricula, nombre, apellido, email, telefono, fecha_nacimiento, id_carrera) VALUES
('2024001', 'Ana', 'García', 'ana.garcia@uabcs.mx', '6121112233', '2004-05-12', 1),
('2024002', 'Carlos', 'Pérez', 'carlos.perez@uabcs.mx', '6122223344', '2003-11-20', 1),
('2024003', 'María', 'López', 'maria.lopez@uabcs.mx', '6123334455', '2005-02-15', 2),
('2024004', 'Pedro', 'Sánchez', 'pedro.sanchez@uabcs.mx', '6124445566', '2004-09-30', 3);

SELECT 
    e.id_estudiante,
    e.matricula,
    CONCAT(e.nombre, ' ', e.apellido) AS estudiante,
    e.email,
    c.nombre AS carrera,
    c.codigo AS codigo_carrera,
    f.nombre AS facultad,
    e.estado AS estado_estudiante
FROM 
    estudiantes e
INNER JOIN 
    carreras c ON e.id_carrera = c.id_carrera
INNER JOIN 
    facultades f ON c.id_facultad = f.id_facultad
ORDER BY 
    e.id_estudiante ASC;	