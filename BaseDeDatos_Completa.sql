-- ============================================================
-- Proyecto MYSD 2026 - Base de datos completa (PostgreSQL)
-- Une: XTablas, Tablas, Atributos, Primarias, Llaves_Foraneas,
--      Unicas, PoblarOK, Consultas, PoblarNOK, Tuplas, TuplasOK,
--      TuplasNoOK y PoblarX
-- ============================================================


-- ============================================================
-- XTablas.sql
-- ============================================================


DROP TABLE IF EXISTS Desperdicios;
DROP TABLE IF EXISTS Ventas;
DROP TABLE IF EXISTS Detalles_compra;
DROP TABLE IF EXISTS Compras;
DROP TABLE IF EXISTS Movimientos_inventario;
DROP TABLE IF EXISTS Inventarios;
DROP TABLE IF EXISTS Platos;
DROP TABLE IF EXISTS Meseros;
DROP TABLE IF EXISTS Cocineros;
DROP TABLE IF EXISTS Recetas;
DROP TABLE IF EXISTS Ingredientes;
DROP TABLE IF EXISTS Causas_desperdicio;
DROP TABLE IF EXISTS Empleados;
DROP TABLE IF EXISTS Proveedores;


-- ============================================================
-- Tablas.sql
-- ============================================================
CREATE TABLE Proveedores (
    id_provedor   SERIAL,
    nombre        VARCHAR(100) NOT NULL,
    telefono      BIGINT,
    correo        VARCHAR(50)
);

CREATE TABLE Empleados (
    id_empleado   SERIAL,
    nombre        VARCHAR(100) NOT NULL,
    salario       DECIMAL(10,2) NOT NULL
);

CREATE TABLE Causas_desperdicio (
    id_causa      SERIAL,
    descripcion   VARCHAR(200) NOT NULL
);

CREATE TABLE Ingredientes (
    id_ingrediente     SERIAL,
    Fecha_vencimiento  DATE
);

CREATE TABLE Recetas (
    id_receta          SERIAL,
    Nombre             VARCHAR(100) NOT NULL,
    tiempo_preparacion INT,              -- minutos
    Descripcion        VARCHAR(255),
    ingredientes       VARCHAR(255)      -- texto libre según el diagrama
);

CREATE TABLE Cocineros (
    id_empleado   INT NOT NULL,
    Especialidad  VARCHAR(50)
);

CREATE TABLE Meseros (
    id_empleado   INT NOT NULL,
    turno         VARCHAR(20)
);

CREATE TABLE Inventarios (
    id_ingrediente      INT NOT NULL,
    cantidad            INT NOT NULL DEFAULT 0
);

CREATE TABLE Movimientos_inventario (
    id_movimiento   SERIAL,
    fecha           DATE NOT NULL,
    tipo_movimiento VARCHAR(20) NOT NULL,   -- p.ej. 'Entrada' / 'Salida'
    id_ingrediente  INT NOT NULL
);

CREATE TABLE Compras (
    id_compra        SERIAL,
    Fecha_compra     DATE NOT NULL,
    Fecha_recepcion  DATE,
    id_proveedor     INT NOT NULL
);

CREATE TABLE Detalles_compra (
    id_detalle      SERIAL,
    cantidad        INT NOT NULL,
    Total           DECIMAL(10,2) NOT NULL,
    id_compra       INT NOT NULL,
    id_ingrediente  INT NOT NULL
);

CREATE TABLE Platos (
    id_plato           SERIAL,
    nombre             VARCHAR(100) NOT NULL,
    tiempo_preparacion INT,           -- minutos
    id_receta          INT
);

CREATE TABLE Ventas (
    id_venta      SERIAL,
    fecha_venta   DATE NOT NULL,
    precio        DECIMAL(10,2) NOT NULL,
    id_plato      INT NOT NULL
);

CREATE TABLE Desperdicios (
    id_desperdicio              SERIAL,
    fecha                       DATE NOT NULL,
    ingredientes_desperdiciados VARCHAR(255),
    id_ingrediente              INT NOT NULL,
    id_empleado                 INT NOT NULL,
    id_causa                    INT NOT NULL
);



-- ============================================================
-- Atributos
-- Restricciones sobre un único atributo
-- ============================================================
ALTER TABLE Proveedores
ADD CONSTRAINT ck_proveedor_telefono CHECK (telefono > 0);

ALTER TABLE Proveedores
ADD CONSTRAINT ck_proveedor_correo CHECK (correo LIKE '%@%.%');

ALTER TABLE Empleados
ADD CONSTRAINT ck_empleado_salario CHECK (salario > 0);

ALTER TABLE Recetas
ADD CONSTRAINT ck_receta_tiempo CHECK (tiempo_preparacion > 0);

ALTER TABLE Meseros
ADD CONSTRAINT ck_mesero_turno CHECK (turno IN ('Mañana', 'Tarde', 'Noche'));

ALTER TABLE Inventarios
ADD CONSTRAINT ck_inventario_cantidad CHECK (cantidad >= 0);

ALTER TABLE Movimientos_inventario
ADD CONSTRAINT ck_movimiento_tipo CHECK (tipo_movimiento IN ('Entrada', 'Salida'));

ALTER TABLE Detalles_compra
ADD CONSTRAINT ck_detalle_cantidad CHECK (cantidad > 0);

ALTER TABLE Detalles_compra
ADD CONSTRAINT ck_detalle_total CHECK (Total > 0);

ALTER TABLE Platos
ADD CONSTRAINT ck_plato_tiempo CHECK (tiempo_preparacion > 0);

ALTER TABLE Ventas
ADD CONSTRAINT ck_venta_precio CHECK (precio > 0);


-- ============================================================
-- Primarias
-- ============================================================
ALTER TABLE Proveedores
ADD CONSTRAINT pk_proveedores PRIMARY KEY (id_provedor);

ALTER TABLE Empleados
ADD CONSTRAINT pk_empleados PRIMARY KEY (id_empleado);

ALTER TABLE Causas_desperdicio
ADD CONSTRAINT pk_causas_desperdicio PRIMARY KEY (id_causa);

ALTER TABLE Ingredientes
ADD CONSTRAINT pk_ingredientes PRIMARY KEY (id_ingrediente);

ALTER TABLE Recetas
ADD CONSTRAINT pk_recetas PRIMARY KEY (id_receta);

ALTER TABLE Cocineros
ADD CONSTRAINT pk_cocineros PRIMARY KEY (id_empleado);

ALTER TABLE Meseros
ADD CONSTRAINT pk_meseros PRIMARY KEY (id_empleado);

ALTER TABLE Inventarios
ADD CONSTRAINT pk_inventarios PRIMARY KEY (id_ingrediente);

ALTER TABLE Movimientos_inventario
ADD CONSTRAINT pk_movimientos_inventario PRIMARY KEY (id_movimiento);

ALTER TABLE Compras
ADD CONSTRAINT pk_compras PRIMARY KEY (id_compra);

ALTER TABLE Detalles_compra
ADD CONSTRAINT pk_detalles_compra PRIMARY KEY (id_detalle);

ALTER TABLE Platos
ADD CONSTRAINT pk_platos PRIMARY KEY (id_plato);

ALTER TABLE Ventas
ADD CONSTRAINT pk_ventas PRIMARY KEY (id_venta);

ALTER TABLE Desperdicios
ADD CONSTRAINT pk_desperdicios PRIMARY KEY (id_desperdicio);


-- ============================================================
-- Llaves_Foraneas.sql
-- ============================================================
-- Llaves foraneas
ALTER TABLE Cocineros
ADD CONSTRAINT fk_cocinero_empleado
FOREIGN KEY (id_empleado) REFERENCES Empleados(id_empleado)
ON DELETE CASCADE;

ALTER TABLE Meseros
ADD CONSTRAINT fk_mesero_empleado
FOREIGN KEY (id_empleado) REFERENCES Empleados(id_empleado)
ON DELETE CASCADE;

ALTER TABLE Inventarios
ADD CONSTRAINT fk_inventario_ingrediente
FOREIGN KEY (id_ingrediente) REFERENCES Ingredientes(id_ingrediente)
ON DELETE CASCADE;

ALTER TABLE Movimientos_inventario
ADD CONSTRAINT fk_movimiento_inventario
FOREIGN KEY (id_ingrediente) REFERENCES Inventarios(id_ingrediente);

ALTER TABLE Compras
ADD CONSTRAINT fk_compra_proveedor
FOREIGN KEY (id_proveedor) REFERENCES Proveedores(id_provedor);

ALTER TABLE Detalles_compra
ADD CONSTRAINT fk_detalle_compra
FOREIGN KEY (id_compra) REFERENCES Compras(id_compra);

ALTER TABLE Detalles_compra
ADD CONSTRAINT fk_detalle_ingrediente
FOREIGN KEY (id_ingrediente) REFERENCES Ingredientes(id_ingrediente);

ALTER TABLE Platos
ADD CONSTRAINT fk_plato_receta
FOREIGN KEY (id_receta) REFERENCES Recetas(id_receta);

ALTER TABLE Ventas
ADD CONSTRAINT fk_venta_plato
FOREIGN KEY (id_plato) REFERENCES Platos(id_plato);


ALTER TABLE Desperdicios
ADD CONSTRAINT fk_desperdicio_ingrediente
FOREIGN KEY (id_ingrediente) REFERENCES Ingredientes(id_ingrediente);

ALTER TABLE Desperdicios
ADD CONSTRAINT fk_desperdicio_empleado
FOREIGN KEY (id_empleado) REFERENCES Empleados(id_empleado);

ALTER TABLE Desperdicios
ADD CONSTRAINT fk_desperdicio_causa
FOREIGN KEY (id_causa) REFERENCES Causas_desperdicio(id_causa);


-- ============================================================
-- Unicas.sql
-- ============================================================
ALTER TABLE Proveedores
ADD CONSTRAINT uq_proveedor_correo UNIQUE (correo);

ALTER TABLE Platos
ADD CONSTRAINT uq_plato_nombre UNIQUE (nombre);

ALTER TABLE Recetas
ADD CONSTRAINT uq_receta_nombre UNIQUE (Nombre);


-- ============================================================
-- PoblarOK.sql
-- ============================================================
INSERT INTO Proveedores (nombre, telefono, correo) VALUES
('Distribuidora La Fresca', 3001234567, 'contacto@lafresca.com'),
('AgroSuministros SAS',     3007654321, 'ventas@agrosuministros.com'),
('Carnes Premium Ltda',     3009876543, 'info@carnespremium.com');

INSERT INTO Empleados (nombre, salario) VALUES
('Carlos Ramírez', 1800000.00),
('Laura Gómez',     1600000.00),
('Andrés Torres',   1700000.00),
('Mariana Ríos',    1550000.00);

INSERT INTO Causas_desperdicio (descripcion) VALUES
('Producto vencido'),
('Error de preparación'),
('Sobreproducción');

INSERT INTO Ingredientes (Fecha_vencimiento) VALUES
('2026-12-01'),
('2026-11-15'),
('2027-01-20'),
('2026-10-10'),
('2026-12-25');

INSERT INTO Recetas (Nombre, tiempo_preparacion, Descripcion, ingredientes) VALUES
('Bandeja Paisa',       45, 'Plato típico colombiano',        'carne, frijol, arroz, chicharrón, huevo, plátano'),
('Ajiaco Santafereño',  60, 'Sopa típica bogotana',           'pollo, papa criolla, mazorca, guascas'),
('Ensalada César',      20, 'Ensalada con pollo a la parrilla','lechuga, pollo, queso parmesano, crutones');

-- id_empleado debe existir en Empleados
INSERT INTO Cocineros (id_empleado, Especialidad) VALUES
(1, 'Cocina Colombiana'),
(3, 'Parrilla');

INSERT INTO Meseros (id_empleado, turno) VALUES
(2, 'Mañana'),
(4, 'Tarde');

-- id_ingrediente debe existir en Ingredientes
INSERT INTO Inventarios (id_ingrediente, cantidad) VALUES
(1, 50),
(2, 30),
(3, 80),
(4, 15),
(5, 60);

INSERT INTO Movimientos_inventario (fecha, tipo_movimiento, id_ingrediente) VALUES
('2026-09-20', 'Entrada', 1),
('2026-09-21', 'Salida',  2),
('2026-09-22', 'Entrada', 3);

INSERT INTO Compras (Fecha_compra, Fecha_recepcion, id_proveedor) VALUES
('2026-09-15', '2026-09-17', 1),
('2026-09-18', '2026-09-19', 2),
('2026-09-20', NULL,         3);

INSERT INTO Detalles_compra (cantidad, Total, id_compra, id_ingrediente) VALUES
(20, 150000.00, 1, 1),
(10, 80000.00,  2, 2),
(15, 200000.00, 3, 3);

-- id_receta debe existir en Recetas; nombre debe ser único (UNIQUE)
INSERT INTO Platos (nombre, tiempo_preparacion, id_receta) VALUES
('Bandeja Paisa',      45, 1),
('Ajiaco Santafereño', 60, 2),
('Ensalada César',     20, 3);

INSERT INTO Ventas (fecha_venta, precio, id_plato) VALUES
('2026-09-24', 25000.00, 1),
('2026-09-24', 18000.00, 2),
('2026-09-25', 15000.00, 3),
('2026-09-25', 25000.00, 1);

INSERT INTO Desperdicios (fecha, ingredientes_desperdiciados, id_ingrediente, id_empleado, id_causa) VALUES
('2026-09-23', 'Papa criolla en mal estado',      2, 1, 1),
('2026-09-24', 'Exceso de preparación de ajiaco', 4, 3, 3);


-- ============================================================
-- Consultas.sql
-- ============================================================
-- 1. Consultar compras realizadas
SELECT
    c.id_compra,
    c.Fecha_compra,
    c.Fecha_recepcion,
    p.nombre        AS proveedor,
    dc.id_ingrediente,
    dc.cantidad,
    dc.Total
FROM Compras c
JOIN Proveedores p        ON c.id_proveedor = p.id_provedor
JOIN Detalles_compra dc   ON dc.id_compra = c.id_compra
ORDER BY c.Fecha_compra DESC;

-- 2. Consultar proveedores
SELECT
    id_provedor,
    nombre,
    telefono,
    correo
FROM Proveedores;

-- 3. Consultar inventario
SELECT
    ing.id_ingrediente,
    ing.Fecha_vencimiento,
    inv.cantidad
FROM Ingredientes ing
JOIN Inventarios inv ON inv.id_ingrediente = ing.id_ingrediente;

-- 4. Consultar movimientos de inventario
SELECT
    m.id_movimiento,
    m.fecha,
    m.tipo_movimiento,
    m.id_ingrediente
FROM Movimientos_inventario m
ORDER BY m.fecha DESC;

-- 5. Consultar desperdicios (vista general del administrador)
SELECT
    d.id_desperdicio,
    d.fecha,
    d.ingredientes_desperdiciados,
    e.nombre        AS empleado,
    ca.descripcion  AS causa
FROM Desperdicios d
JOIN Empleados e          ON e.id_empleado = d.id_empleado
JOIN Causas_desperdicio ca ON ca.id_causa = d.id_causa
ORDER BY d.fecha DESC;

-- 6. Consultar ventas realizadas
SELECT
    v.id_venta,
    v.fecha_venta,
    v.precio,
    pl.nombre AS plato
FROM Ventas v
JOIN Platos pl ON pl.id_plato = v.id_plato
ORDER BY v.fecha_venta DESC;

-- 7. Consultar platos más vendidos
SELECT
    pl.id_plato,
    pl.nombre,
    COUNT(v.id_venta)   AS veces_vendido,
    SUM(v.precio)        AS ingresos_generados
FROM Ventas v
JOIN Platos pl ON pl.id_plato = v.id_plato
GROUP BY pl.id_plato, pl.nombre
ORDER BY veces_vendido DESC;

-- 8. Consultar ingredientes disponibles (cantidad > 0)
SELECT
    ing.id_ingrediente,
    ing.Fecha_vencimiento,
    inv.cantidad
FROM Ingredientes ing
JOIN Inventarios inv ON inv.id_ingrediente = ing.id_ingrediente
WHERE inv.cantidad > 0;

-- 9. Consultar desperdicios del día (fecha actual)
SELECT
    d.id_desperdicio,
    d.fecha,
    d.ingredientes_desperdiciados,
    e.nombre       AS empleado,
    ca.descripcion AS causa
FROM Desperdicios d
JOIN Empleados e           ON e.id_empleado = d.id_empleado
JOIN Causas_desperdicio ca ON ca.id_causa = d.id_causa
WHERE d.fecha = CURRENT_DATE;

-- 10. Consultar inventario disponible
SELECT
    id_ingrediente,
    cantidad
FROM Inventarios
WHERE cantidad > 0;

-- 11. Consultar platos
SELECT
    pl.id_plato,
    pl.nombre,
    pl.tiempo_preparacion
FROM Platos pl;

-- 12. Consultar recetas o platos
SELECT
    pl.id_plato,
    pl.nombre             AS plato,
    r.Nombre               AS receta,
    r.Descripcion,
    r.tiempo_preparacion,
    r.ingredientes
FROM Platos pl
JOIN Recetas r ON r.id_receta = pl.id_receta;

-- 13. Consultar platos con ingredientes disponibles en inventario
SELECT
    pl.id_plato,
    pl.nombre         AS plato,
    r.Nombre           AS receta,
    ing.id_ingrediente,
    inv.cantidad
FROM Platos pl
JOIN Recetas r          ON r.id_receta = pl.id_receta
CROSS JOIN Ingredientes ing
JOIN Inventarios inv    ON inv.id_ingrediente = ing.id_ingrediente
WHERE inv.cantidad > 0;


-- ============================================================
-- PoblarNOK.sql
-- Estos INSERT fallan a propósito (prueban las restricciones).
-- Están comentados para que el script corra completo; descoméntalos para probarlos.
-- ============================================================
-- -- 1) Viola UNIQUE (correo ya usado por 'Distribuidora La Fresca')
-- INSERT INTO Proveedores (nombre, telefono, correo)
-- VALUES ('Otro Proveedor', 3001111111, 'contacto@lafresca.com');
-- 
-- -- 2) Viola UNIQUE (ya existe un plato llamado 'Bandeja Paisa')
-- INSERT INTO Platos (nombre, tiempo_preparacion, id_receta)
-- VALUES ('Bandeja Paisa', 50, 1);
-- 
-- -- 3) Viola UNIQUE (ya existe una receta llamada 'Ajiaco Santafereño')
-- INSERT INTO Recetas (Nombre, tiempo_preparacion, Descripcion, ingredientes)
-- VALUES ('Ajiaco Santafereño', 55, 'Otra versión', 'pollo, papa');
-- 
-- -- 4) Viola llave foránea (id_proveedor 999 no existe en Proveedores)
-- INSERT INTO Compras (Fecha_compra, Fecha_recepcion, id_proveedor)
-- VALUES ('2026-09-26', NULL, 999);
-- 
-- -- 5) Viola llave foránea (id_plato 999 no existe en Platos)
-- INSERT INTO Ventas (fecha_venta, precio, id_plato)
-- VALUES ('2026-09-26', 20000.00, 999);
-- 
-- -- 6) Viola NOT NULL (nombre es obligatorio en Empleados)
-- INSERT INTO Empleados (nombre, salario)
-- VALUES (NULL, 1500000.00);
-- 
-- -- 7) Viola llave primaria (id_provedor 1 ya existe)
-- INSERT INTO Proveedores (id_provedor, nombre, telefono, correo)
-- VALUES (1, 'Duplicado', 3000000000, 'nuevo@correo.com');


-- ============================================================
-- Tuplas
-- Restricciones que implican más de un atributo de la misma fila
-- ============================================================
ALTER TABLE Proveedores
ADD CONSTRAINT ck_proveedor_contacto
CHECK (telefono IS NOT NULL OR correo IS NOT NULL);

ALTER TABLE Compras
ADD CONSTRAINT ck_compra_fechas
CHECK (Fecha_recepcion IS NULL OR Fecha_recepcion >= Fecha_compra);

ALTER TABLE Recetas
ADD CONSTRAINT ck_receta_contenido
CHECK (Descripcion IS NOT NULL OR ingredientes IS NOT NULL);


-- ============================================================
-- TuplasOK
-- Datos correctos con respecto a las restricciones de tupla
-- ============================================================
-- Proveedor solo con correo (sin teléfono)
INSERT INTO Proveedores (nombre, telefono, correo)
VALUES ('Lácteos del Valle', NULL, 'ventas@lacteosvalle.com');

-- Proveedor solo con teléfono (sin correo)
INSERT INTO Proveedores (nombre, telefono, correo)
VALUES ('Frutas El Campo', 3112223344, NULL);

-- Compra recibida después de la fecha de compra
INSERT INTO Compras (Fecha_compra, Fecha_recepcion, id_proveedor)
VALUES ('2026-10-01', '2026-10-03', 1);

-- Compra recibida el mismo día
INSERT INTO Compras (Fecha_compra, Fecha_recepcion, id_proveedor)
VALUES ('2026-10-05', '2026-10-05', 2);

-- Receta solo con descripción
INSERT INTO Recetas (Nombre, tiempo_preparacion, Descripcion, ingredientes)
VALUES ('Arepa de Choclo', 15, 'Arepa dulce de maíz tierno', NULL);

-- Receta solo con ingredientes
INSERT INTO Recetas (Nombre, tiempo_preparacion, Descripcion, ingredientes)
VALUES ('Changua', 20, NULL, 'leche, huevo, cebolla larga, cilantro, pan');


-- ============================================================
-- TuplasNoOK
-- Datos incorrectos con respecto a las restricciones de tupla.
-- Están comentados porque fallan a propósito; descoméntalos para probarlos.
-- ============================================================
-- -- 1) Viola ck_proveedor_contacto (sin teléfono ni correo)
-- INSERT INTO Proveedores (nombre, telefono, correo)
-- VALUES ('Proveedor Sin Contacto', NULL, NULL);
--
-- -- 2) Viola ck_compra_fechas (recepción antes de la compra)
-- INSERT INTO Compras (Fecha_compra, Fecha_recepcion, id_proveedor)
-- VALUES ('2026-10-10', '2026-10-01', 1);
--
-- -- 3) Viola ck_receta_contenido (sin descripción ni ingredientes)
-- INSERT INTO Recetas (Nombre, tiempo_preparacion, Descripcion, ingredientes)
-- VALUES ('Receta Vacía', 30, NULL, NULL);


-- ============================================================
-- PoblarX.sql
-- Elimina las tablas con todos sus datos. Comentado para no borrarlas al final.
-- CASCADE elimina también las llaves foráneas que apuntan a cada tabla.
-- ============================================================
-- DROP TABLE IF EXISTS Desperdicios CASCADE;
-- DROP TABLE IF EXISTS Ventas CASCADE;
-- DROP TABLE IF EXISTS Platos CASCADE;
-- DROP TABLE IF EXISTS Detalles_compra CASCADE;
-- DROP TABLE IF EXISTS Compras CASCADE;
-- DROP TABLE IF EXISTS Movimientos_inventario CASCADE;
-- DROP TABLE IF EXISTS Inventarios CASCADE;
-- DROP TABLE IF EXISTS Recetas CASCADE;
-- DROP TABLE IF EXISTS Cocineros CASCADE;
-- DROP TABLE IF EXISTS Meseros CASCADE;
-- DROP TABLE IF EXISTS Empleados CASCADE;
-- DROP TABLE IF EXISTS Causas_desperdicio CASCADE;
-- DROP TABLE IF EXISTS Ingredientes CASCADE;
-- DROP TABLE IF EXISTS Proveedores CASCADE;
