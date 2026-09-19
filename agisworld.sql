--agisworld


CREATE DATABASE agisworld;

create table cursos(
    codigo VARCHAR(5) PRIMARY KEY,
    nombre VARCHAR(50),
    detalle TEXT,
    cerrado BOOLEAN
);

create table metodologias(
    nombre_metodologia VARCHAR(50) PRIMARY KEY
);


create table cursos_metodologias(
    codigo_curso VARCHAR(5),
    metodologia VARCHAR(50),
    PRIMARY KEY(codigo_curso,metodologia),
    FOREIGN KEY(codigo_curso)
    REFERENCES cursos(codigo),
    FOREIGN KEY(metodologia)
    REFERENCES metodologias(nombre_metodologia)
);

create table habilidades(
    nombreCorto VARCHAR(50) PRIMARY KEY,
    nombre VARCHAR(50)
);

create table planesformacion(
    numero serial primary key,
    fecha DATE,
    fechafin DATE NULL,
    estado VARCHAR(10) NOT NULL,
    evaluador VARCHAR(50) NOT NULL,
    UNIQUE (evaluador)
);

create table avances(
    fecha DATE,
    tipo varchar(50)
);

alter table metodologias
add column codigo_cursos varchar(5)

alter table metodologias
add constraint fk_curso
FOREIGN KEY (codigo_cursos)
references cursos(codigo)

create table certificaciones(
    codigo VARCHAR(5),
    vigencia INTEGER,
    valor INTEGER
);

alter table certificaciones
add constraint ck_vigencia
check(vigencia between 0 and 9)

alter table certificaciones
add constraint valor
check(valor between 0 and 99999)

create table candidatos(
    correo VARCHAR(50),
    nombres VARCHAR(50)
);

alter table candidatos
add constraint pk_correo
PRIMARY KEY(correo)

create table tieneprioridad(
    prioridad VARCHAR(50)
);

create table candidatoesconexion(
    correo_candidato VARCHAR(50),
    nombre varchar(50)
);

create table notificaciones(
    id_notificacion INT,
    fecha_generacion DATE,
    accion varchar,
    asunto varchar(50),
    destinatario varchar,
    mensaje varchar(50),
    detalle_notificacion varchar,
    fecha_lectura DATE,
    lectura VARCHAR
);

alter table notificaciones
add constraint pk_notificaciones
PRIMARY KEY(id_notificacion)
-- relacion muchos a muchos relacion con habilidades y candidato
CREATE TABLE candidatos_habilidades (
    correo_candidato VARCHAR(50),
    nombre_habilidad VARCHAR(50),
    PRIMARY KEY (correo_candidato, nombre_habilidad),
    FOREIGN KEY (correo_candidato)
        REFERENCES candidatos(correo),
    FOREIGN KEY (nombre_habilidad)
        REFERENCES habilidades(nombreCorto)
);

--crear restricciones
ALTER TABLE habilidades ADD COLUMN correo_candidato_distinguido VARCHAR(50);
ALTER TABLE habilidades ADD CONSTRAINT fk_habilidad_distinguido FOREIGN KEY (correo_candidato_distinguido) REFERENCES candidatos(correo);

CREATE TABLE curso_habilidades(
    codigo_curso VARCHAR(5),
    nombreCorto_habilidad VARCHAR(50),
    PRIMARY KEY(codigo_curso, nombreCorto_habilidad)
);
ALTER TABLE curso_habilidades ADD CONSTRAINT fk_cursohab_curso FOREIGN KEY (codigo_curso) REFERENCES cursos(codigo);
ALTER TABLE curso_habilidades ADD CONSTRAINT fk_cursohab_habilidad FOREIGN KEY (nombreCorto_habilidad) REFERENCES habilidades(nombreCorto);

ALTER TABLE planesformacion ADD COLUMN correo_candidato VARCHAR(50);
ALTER TABLE planesformacion ADD CONSTRAINT fk_plan_candidato FOREIGN KEY (correo_candidato) REFERENCES candidatos(correo);
ALTER TABLE planesformacion ADD CONSTRAINT fk_plan_evaluador FOREIGN KEY (evaluador) REFERENCES candidatos(correo);

ALTER TABLE tieneprioridad ADD COLUMN nombreCorto_habilidad VARCHAR(50);
ALTER TABLE tieneprioridad ADD COLUMN numero_plan INTEGER;
ALTER TABLE tieneprioridad ADD CONSTRAINT fk_tieneprioridad_habilidad FOREIGN KEY (nombreCorto_habilidad) REFERENCES habilidades(nombreCorto);
ALTER TABLE tieneprioridad ADD CONSTRAINT fk_tieneprioridad_plan FOREIGN KEY (numero_plan) REFERENCES planesformacion(numero);

ALTER TABLE avances ADD COLUMN id_avance SERIAL;
ALTER TABLE avances ADD CONSTRAINT pk_avance PRIMARY KEY (id_avance);
ALTER TABLE avances ADD COLUMN numero_plan INTEGER;
ALTER TABLE avances ADD COLUMN codigo_curso VARCHAR(5);
ALTER TABLE avances ADD CONSTRAINT fk_avance_plan FOREIGN KEY (numero_plan) REFERENCES planesformacion(numero);
ALTER TABLE avances ADD CONSTRAINT fk_avance_curso FOREIGN KEY (codigo_curso) REFERENCES cursos(codigo);

ALTER TABLE certificaciones ADD CONSTRAINT fk_certificacion_curso FOREIGN KEY (codigo) REFERENCES cursos(codigo);

ALTER TABLE candidatoesconexion RENAME COLUMN nombre TO correo_candidato_conexion;
ALTER TABLE candidatoesconexion ADD CONSTRAINT fk_conexion_candidato FOREIGN KEY (correo_candidato) REFERENCES candidatos(correo);
ALTER TABLE candidatoesconexion ADD CONSTRAINT fk_conexion_candidato2 FOREIGN KEY (correo_candidato_conexion) REFERENCES candidatos(correo);

ALTER TABLE notificaciones ADD COLUMN id_avance INTEGER;
ALTER TABLE notificaciones ADD CONSTRAINT fk_notificacion_avance FOREIGN KEY (id_avance) REFERENCES avances(id_avance);
--revisar tipos en notificaciones


INSERT INTO cursos (codigo, nombre, detalle, cerrado) VALUES
('C001', 'Modelado UML', 'Fundamentos de modelado con UML', FALSE),
('C002', 'Bases de Datos', 'Diseño y normalización de bases de datos relacionales', FALSE),
('C003', 'Liderazgo Agil', 'Practicas de liderazgo en equipos agiles', TRUE),
('C004', 'Machine Learning', 'Introduccion al aprendizaje automatico', FALSE),
('C005', 'Pruebas de Software', 'Estrategias de testing y QA', FALSE);

INSERT INTO metodologias (nombre_metodologia) VALUES
('Aprendizaje basado en proyectos'),
('Clases magistrales'),
('Aprendizaje colaborativo'),
('Estudio de casos');

INSERT INTO cursos_metodologias (codigo_curso, metodologia) VALUES
('C001', 'Clases magistrales'),
('C001', 'Estudio de casos'),
('C002', 'Aprendizaje basado en proyectos'),
('C003', 'Aprendizaje colaborativo'),
('C004', 'Aprendizaje basado en proyectos'),
('C005', 'Estudio de casos');

INSERT INTO candidatos (correo, nombres) VALUES
('juan.perez@mail.com', 'Juan Perez'),
('maria.gomez@mail.com', 'Maria Gomez'),
('carlos.ruiz@mail.com', 'Carlos Ruiz'),
('ana.lopez@mail.com', 'Ana Lopez'),
('luis.torres@mail.com', 'Luis Torres');

INSERT INTO habilidades (nombreCorto, nombre, correo_candidato_distinguido) VALUES
('UML', 'Modelado UML', 'juan.perez@mail.com'),
('SQL', 'Bases de Datos SQL', 'maria.gomez@mail.com'),
('LIDER', 'Liderazgo de equipos', NULL),
('ML', 'Aprendizaje automatico', 'carlos.ruiz@mail.com'),
('TEST', 'Pruebas de software', NULL);

INSERT INTO curso_habilidades (codigo_curso, nombreCorto_habilidad) VALUES
('C001', 'UML'),
('C002', 'SQL'),
('C003', 'LIDER'),
('C004', 'ML'),
('C005', 'TEST');

INSERT INTO candidatos_habilidades (correo_candidato, nombre_habilidad) VALUES
('juan.perez@mail.com', 'UML'),
('juan.perez@mail.com', 'SQL'),
('maria.gomez@mail.com', 'SQL'),
('maria.gomez@mail.com', 'LIDER'),
('carlos.ruiz@mail.com', 'ML'),
('carlos.ruiz@mail.com', 'TEST'),
('ana.lopez@mail.com', 'UML'),
('luis.torres@mail.com', 'LIDER');

INSERT INTO planesformacion (fecha, fechafin, estado, evaluador, correo_candidato) VALUES
('2025-01-10', NULL, 'ACTIVO', 'maria.gomez@mail.com', 'juan.perez@mail.com'),
('2025-02-15', '2025-06-15', 'FINALIZADO', 'carlos.ruiz@mail.com', 'ana.lopez@mail.com'),
('2025-03-01', NULL, 'ACTIVO', 'juan.perez@mail.com', 'luis.torres@mail.com'),
('2025-04-20', NULL, 'ACTIVO', 'ana.lopez@mail.com', 'maria.gomez@mail.com');

INSERT INTO tieneprioridad (nombreCorto_habilidad, numero_plan, prioridad) VALUES
('UML', 1, 'ALTA'),
('SQL', 1, 'MEDIA'),
('LIDER', 2, 'ALTA'),
('ML', 3, 'ALTA'),
('TEST', 4, 'MEDIA');

INSERT INTO avances (fecha, tipo, numero_plan, codigo_curso) VALUES
('2025-01-12', 'inscripcion', 1, 'C001'),
('2025-02-20', 'inscripcion', 2, 'C003'),
('2025-06-10', 'finalizacion_exito', 2, 'C003'),
('2025-03-05', 'inscripcion', 3, 'C004'),
('2025-04-25', 'abandono', 4, 'C002');

INSERT INTO certificaciones (codigo, vigencia, valor) VALUES
('C001', 2, 500),
('C002', 3, 800),
('C004', 1, 1200);

INSERT INTO candidatoesconexion (correo_candidato, correo_candidato_conexion) VALUES
('juan.perez@mail.com', 'maria.gomez@mail.com'),
('juan.perez@mail.com', 'carlos.ruiz@mail.com'),
('maria.gomez@mail.com', 'ana.lopez@mail.com'),
('carlos.ruiz@mail.com', 'luis.torres@mail.com'),
('ana.lopez@mail.com', 'luis.torres@mail.com');

INSERT INTO notificaciones (id_notificacion, fecha_generacion, accion, asunto, destinatario, mensaje, detalle_notificacion, fecha_lectura, lectura, id_avance) VALUES
(1, '2025-01-12', 'inscripcion', 'Inscripcion-2025-01-ModeladoUML', 'maria.gomez@mail.com', 'Se registro una inscripcion en el curso Modelado UML', 'Avance de plan de formacion', '2025-01-13', 'si', 1),
(2, '2025-02-20', 'inscripcion', 'Inscripcion-2025-02-LiderazgoAgil', 'carlos.ruiz@mail.com', 'Se registro una inscripcion en el curso Liderazgo Agil', 'Avance de plan de formacion', NULL, 'no', 2),
(3, '2025-06-10', 'finalizacion_exito', 'Finalizacion-2025-06-LiderazgoAgil', 'carlos.ruiz@mail.com', 'El candidato finalizo con exito el curso Liderazgo Agil', 'Avance de plan de formacion', '2025-06-11', 'si', 3),
(4, '2025-03-05', 'inscripcion', 'Inscripcion-2025-03-MachineLearning', 'juan.perez@mail.com', 'Se registro una inscripcion en el curso Machine Learning', 'Avance de plan de formacion', '2025-03-06', 'si', 4),
(5, '2025-04-25', 'abandono', 'Abandono-2025-04-BasesDeDatos', 'ana.lopez@mail.com', 'El candidato abandono el curso Bases de Datos', 'Avance de plan de formacion', NULL, 'no', 5);

-- Los datos para poblar la base de datos fueron creador con inteligencia artificial

--

-- Caso 1: Notificacion leida antes de ser generada
-- Regla de negocio (caso de uso Modificar, punto 2): "la fecha de lectura debe ser
-- posterior a la fecha de generacion de la notificacion". No existe un CHECK que
-- compare fecha_lectura contra fecha_generacion, por lo que el INSERT se ejecuta sin error.
INSERT INTO notificaciones (id_notificacion, fecha_generacion, accion, asunto, destinatario, mensaje, detalle_notificacion, fecha_lectura, lectura, id_avance) VALUES
(6, '2025-09-10', 'inscripcion', 'Inscripcion-2025-09-PruebasDeSoftware', 'luis.torres@mail.com', 'Se registro una inscripcion en el curso Pruebas de Software', 'Avance de plan de formacion', '2025-09-01', 'si', 4);
-- Se inserta sin problema aunque fecha_lectura (01-sep) es anterior a fecha_generacion (10-sep).

-- Caso 2: Evaluador que evalua su propio plan de formacion
-- Regla de negocio: el evaluador debe ser un profesional distinto seleccionado por AGISWorld
-- entre los reconocidos, no el propio candidato dueño del plan. No hay CHECK que impida
-- evaluador = correo_candidato, por lo que la autoevaluacion se inserta sin error.
INSERT INTO planesformacion (fecha, fechafin, estado, evaluador, correo_candidato) VALUES
('2025-09-05', NULL, 'ACTIVO', 'luis.torres@mail.com', 'luis.torres@mail.com');
-- luis.torres queda como evaluador y dueño del mismo plan; la FK y el UNIQUE se cumplen igual.

-- Caso 3: Tipo de avance fuera del dominio permitido
-- Regla de negocio: "Las acciones posibles son inscripcion, finalizacion con exito o con
-- fracaso y abandono". La columna tipo es VARCHAR(50) sin dominio ni CHECK asociado, por lo
-- que cualquier texto se acepta.
INSERT INTO avances (fecha, tipo, numero_plan, codigo_curso) VALUES
('2025-09-12', 'reprobado_por_inasistencia', 3, 'C004');
-- Se inserta con un tipo que no pertenece al dominio del caso de estudio.






--Casos que ilustran la proteccion de integridad de la base de datos

-- Caso 1: No se viola integridad (FK avances -> cursos)
-- Se valida que no se pueda registrar un avance asociado a un curso inexistente.
INSERT INTO avances (fecha, tipo, numero_plan, codigo_curso) VALUES
('2025-07-01', 'inscripcion', 1, 'C099');
-- Resultado esperado: error de violación de llave foránea (C099 no existe en cursos).

-- Caso 2: No se viola restricción CHECK (ck_vigencia)
-- Se valida que la vigencia de una certificación no pueda salirse del rango de negocio (0 a 9 años).
INSERT INTO certificaciones (codigo, vigencia, valor) VALUES
('C005', 15, 700);
-- Resultado esperado: error de violación de CHECK (vigencia fuera de 0-9).

-- Caso 3: No se viola restricción UNIQUE (evaluador en planesformacion)
-- Se valida que un mismo candidato no pueda ser evaluador de más de un plan de formación a la vez.
INSERT INTO planesformacion (fecha, fechafin, estado, evaluador, correo_candidato) VALUES
('2025-08-01', NULL, 'ACTIVO', 'maria.gomez@mail.com', 'luis.torres@mail.com');
-- Resultado esperado: error de violación de UNIQUE (maria.gomez@mail.com ya es evaluador del plan 1).



