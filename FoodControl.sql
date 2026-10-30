-- ============================================================
-- Proyecto MYSD 2026 - Base de datos completa (PostgreSQL)
-- Une: XTablas, Tablas, Atributos, Primarias, Llaves_Foraneas,
--      Unicas, PoblarOK, Consultas, PoblarNOK, Tuplas, TuplasOK,
--      TuplasNoOK y PoblarX
-- ============================================================

-- XTablas
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

-- Tablas
CREATE TABLE Proveedores (
    id_proveedor  SERIAL,
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
    nombre             VARCHAR(100) NOT NULL,
    Fecha_vencimiento  DATE
);

CREATE TABLE Recetas (
    id_receta          SERIAL,
    Nombre             VARCHAR(100) NOT NULL,
    tiempo_preparacion INT,
    Descripcion        VARCHAR(255),
    ingredientes       VARCHAR(255)
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
    tipo_movimiento VARCHAR(20) NOT NULL,
    cantidad        INT NOT NULL,
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
    tiempo_preparacion INT,
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

-- Atributos
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

ALTER TABLE Movimientos_inventario
ADD CONSTRAINT ck_movimiento_cantidad CHECK (cantidad > 0);

ALTER TABLE Detalles_compra
ADD CONSTRAINT ck_detalle_cantidad CHECK (cantidad > 0);

ALTER TABLE Detalles_compra
ADD CONSTRAINT ck_detalle_total CHECK (Total > 0);

ALTER TABLE Platos
ADD CONSTRAINT ck_plato_tiempo CHECK (tiempo_preparacion > 0);

ALTER TABLE Ventas
ADD CONSTRAINT ck_venta_precio CHECK (precio > 0);

-- Primarias
ALTER TABLE Proveedores
ADD CONSTRAINT pk_proveedores PRIMARY KEY (id_proveedor);

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

-- Foraneas
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
FOREIGN KEY (id_proveedor) REFERENCES Proveedores(id_proveedor);

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

-- Unicas
ALTER TABLE Proveedores
ADD CONSTRAINT uq_proveedor_correo UNIQUE (correo);

ALTER TABLE Platos
ADD CONSTRAINT uq_plato_nombre UNIQUE (nombre);

ALTER TABLE Recetas
ADD CONSTRAINT uq_receta_nombre UNIQUE (Nombre);

ALTER TABLE Ingredientes
ADD CONSTRAINT uq_ingrediente_nombre UNIQUE (nombre);

-- PoblarOK
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

INSERT INTO Ingredientes (nombre, Fecha_vencimiento) VALUES
('Arroz',        '2026-12-01'),
('Papa criolla', '2026-11-15'),
('Carne de res', '2027-01-20'),
('Pollo',        '2026-10-10'),
('Fríjol',       '2026-12-25');

INSERT INTO Recetas (Nombre, tiempo_preparacion, Descripcion, ingredientes) VALUES
('Bandeja Paisa',       45, 'Plato típico colombiano',        'carne, frijol, arroz, chicharrón, huevo, plátano'),
('Ajiaco Santafereño',  60, 'Sopa típica bogotana',           'pollo, papa criolla, mazorca, guascas'),
('Ensalada César',      20, 'Ensalada con pollo a la parrilla','lechuga, pollo, queso parmesano, crutones');

INSERT INTO Cocineros (id_empleado, Especialidad) VALUES
(1, 'Cocina Colombiana'),
(3, 'Parrilla');

INSERT INTO Meseros (id_empleado, turno) VALUES
(2, 'Mañana'),
(4, 'Tarde');

INSERT INTO Inventarios (id_ingrediente, cantidad) VALUES
(1, 50),
(2, 30),
(3, 80),
(4, 15),
(5, 60);

INSERT INTO Movimientos_inventario (fecha, tipo_movimiento, cantidad, id_ingrediente) VALUES
('2026-09-20', 'Entrada', 20, 1),
('2026-09-21', 'Salida',  5,  2),
('2026-09-22', 'Entrada', 10, 3);

INSERT INTO Compras (Fecha_compra, Fecha_recepcion, id_proveedor) VALUES
('2026-09-15', '2026-09-17', 1),
('2026-09-18', '2026-09-19', 2),
('2026-09-20', NULL,         3);

INSERT INTO Detalles_compra (cantidad, Total, id_compra, id_ingrediente) VALUES
(20, 150000.00, 1, 1),
(10, 80000.00,  2, 2),
(15, 200000.00, 3, 3);

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

-- PoblarOK automático: completa cada tabla hasta al menos 15 filas
INSERT INTO Proveedores (nombre, telefono, correo)
SELECT
    (ARRAY['Frigorífico El Llano', 'Hortalizas de la Sabana', 'Granos y Cereales SAS',
        'Pescados del Pacífico', 'Avícola San Martín', 'Especias del Oriente',
        'Panadería Industrial Trigal', 'Bebidas La Montaña', 'Aceites y Grasas Ltda',
        'Quesos Ubaté', 'Tubérculos Boyacá', 'Empaques Gourmet'])[i],
    3100000000 + i * 1111,
    'ventas@' || (ARRAY['frigollano', 'hortasabana', 'granoscereales', 'pescapacifico',
        'avicolasm', 'especiasoriente', 'trigal', 'bebidasmontana',
        'aceitesgrasas', 'quesosubate', 'tuberculosboy', 'empaquesgourmet'])[i] || '.com'
FROM generate_series(1, 12) AS i;

-- 26 empleados nuevos (id 5 a 30): 13 serán cocineros y 13 meseros
INSERT INTO Empleados (nombre, salario)
SELECT
    (ARRAY['Sofía Herrera', 'Julián Castro', 'Valentina Mora', 'Felipe Duarte', 'Daniela Pardo',
        'Santiago Vargas', 'Isabella Cruz', 'Mateo Rincón', 'Gabriela Peña', 'Nicolás Suárez',
        'Paula Medina', 'Sebastián Ortiz', 'Natalia León', 'Diego Cárdenas', 'Lucía Molina',
        'Tomás Salazar', 'Manuela Ruiz', 'Samuel Acosta', 'Sara Jiménez', 'David Rojas',
        'Antonia Vega', 'Martín Guzmán', 'Juliana Prieto', 'Emilio Navarro', 'Catalina Ávila',
        'Simón Beltrán'])[i],
    1500000.00 + i * 25000
FROM generate_series(1, 26) AS i;

INSERT INTO Causas_desperdicio (descripcion)
SELECT
    (ARRAY['Contaminación cruzada', 'Mal almacenamiento', 'Cadena de frío interrumpida',
        'Producto quemado', 'Devolución del cliente', 'Caída o derrame',
        'Empaque dañado', 'Plaga detectada', 'Porción mal servida',
        'Pedido cancelado', 'Falla de equipo', 'Recibido en mal estado'])[i]
FROM generate_series(1, 12) AS i;

INSERT INTO Ingredientes (nombre, Fecha_vencimiento)
SELECT
    (ARRAY['Plátano', 'Huevo', 'Queso costeño', 'Yuca', 'Cebolla larga',
        'Mazorca', 'Cilantro', 'Leche', 'Camarón', 'Lechuga'])[i],
    DATE '2026-11-01' + i * 7
FROM generate_series(1, 10) AS i;

INSERT INTO Recetas (Nombre, tiempo_preparacion, Descripcion, ingredientes)
SELECT
    (ARRAY['Sancocho de Gallina', 'Arroz con Pollo', 'Mondongo', 'Lechona',
        'Tamal Tolimense', 'Cazuela de Mariscos', 'Posta Negra', 'Sobrebarriga',
        'Frijolada', 'Mote de Queso', 'Arroz Atollado', 'Viudo de Pescado'])[i],
    (ARRAY[90, 50, 120, 240, 180, 40, 150, 100, 80, 45, 60, 70])[i],
    (ARRAY['Sopa de gallina criolla con tubérculos', 'Arroz amarillo con pollo desmechado',
        'Sopa de callo con verduras', 'Cerdo relleno de arroz y arveja',
        'Masa de maíz rellena envuelta en hoja', 'Mariscos en salsa cremosa',
        'Carne en salsa de panela, receta cartagenera', 'Falda de res en salsa criolla',
        'Frijoles con garra y hogao', 'Sopa costeña de ñame y queso',
        'Arroz caldoso vallecaucano', 'Pescado cocido al vapor con plátano'])[i],
    (ARRAY['gallina, papa, yuca, mazorca, cilantro', 'arroz, pollo, zanahoria, arveja, pimentón',
        'callo, papa, yuca, garbanzo, cilantro', 'cerdo, arroz, arveja, cebolla, comino',
        'maíz, cerdo, pollo, huevo, zanahoria', 'camarón, calamar, pescado, crema de leche, coco',
        'muchacho de res, panela, cebolla, vino tinto', 'sobrebarriga, tomate, cebolla, papa',
        'frijol, garra de cerdo, plátano, hogao', 'ñame, queso costeño, cebolla, ajo',
        'arroz, pollo, costilla, papa, chorizo', 'bagre, plátano, yuca, cebolla, tomate'])[i]
FROM generate_series(1, 12) AS i;

INSERT INTO Cocineros (id_empleado, Especialidad)
SELECT
    e,
    (ARRAY['Cocina Colombiana', 'Parrilla', 'Mariscos', 'Repostería', 'Panadería',
        'Sopas', 'Cocina Internacional', 'Salsas', 'Ensaladas', 'Carnes',
        'Cocina Costeña', 'Postres', 'Asados'])[e - 4]
FROM generate_series(5, 17) AS e;

INSERT INTO Meseros (id_empleado, turno)
SELECT
    e,
    (ARRAY['Mañana', 'Tarde', 'Noche'])[1 + e % 3]
FROM generate_series(18, 30) AS e;

INSERT INTO Inventarios (id_ingrediente, cantidad)
SELECT
    i,
    20 + i * 5
FROM generate_series(6, 15) AS i;

INSERT INTO Movimientos_inventario (fecha, tipo_movimiento, cantidad, id_ingrediente)
SELECT
    DATE '2026-09-22' + i,
    CASE WHEN i % 2 = 0 THEN 'Entrada' ELSE 'Salida' END,
    2 + i % 4,
    1 + i % 15
FROM generate_series(1, 12) AS i;

INSERT INTO Compras (Fecha_compra, Fecha_recepcion, id_proveedor)
SELECT
    DATE '2026-09-01' + i,
    DATE '2026-09-01' + i + 1 + i % 2,
    1 + i % 15
FROM generate_series(1, 12) AS i;

-- un detalle por cada compra nueva (id 4 a 15)
INSERT INTO Detalles_compra (cantidad, Total, id_compra, id_ingrediente)
SELECT
    5 + c,
    (5 + c) * 8000.00,
    c,
    c
FROM generate_series(4, 15) AS c;

-- un plato por cada receta nueva, con el mismo nombre y tiempo
INSERT INTO Platos (nombre, tiempo_preparacion, id_receta)
SELECT
    Nombre,
    tiempo_preparacion,
    id_receta
FROM Recetas
WHERE id_receta > 3;

INSERT INTO Ventas (fecha_venta, precio, id_plato)
SELECT
    DATE '2026-09-26' + i % 10,
    15000.00 + (i % 5) * 3000,
    1 + i % 15
FROM generate_series(1, 11) AS i;

INSERT INTO Desperdicios (fecha, ingredientes_desperdiciados, id_ingrediente, id_empleado, id_causa)
SELECT
    DATE '2026-09-25' + i,
    'Merma de ' || (SELECT nombre FROM Ingredientes WHERE id_ingrediente = 1 + i % 15),
    1 + i % 15,
    4 + i,
    1 + i % 15
FROM generate_series(1, 13) AS i;

-- Consultas
SELECT
    c.id_compra,
    c.Fecha_compra,
    c.Fecha_recepcion,
    p.nombre        AS proveedor,
    dc.id_ingrediente,
    ing.nombre      AS ingrediente,
    dc.cantidad,
    dc.Total
FROM Compras c
JOIN Proveedores p        ON c.id_proveedor = p.id_proveedor
JOIN Detalles_compra dc   ON dc.id_compra = c.id_compra
JOIN Ingredientes ing     ON ing.id_ingrediente = dc.id_ingrediente
ORDER BY c.Fecha_compra DESC;

SELECT
    id_proveedor,
    nombre,
    telefono,
    correo
FROM Proveedores;

SELECT
    ing.id_ingrediente,
    ing.nombre,
    ing.Fecha_vencimiento,
    inv.cantidad
FROM Ingredientes ing
JOIN Inventarios inv ON inv.id_ingrediente = ing.id_ingrediente;

SELECT
    m.id_movimiento,
    m.fecha,
    m.tipo_movimiento,
    m.cantidad,
    m.id_ingrediente
FROM Movimientos_inventario m
ORDER BY m.fecha DESC;

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

SELECT
    v.id_venta,
    v.fecha_venta,
    v.precio,
    pl.nombre AS plato
FROM Ventas v
JOIN Platos pl ON pl.id_plato = v.id_plato
ORDER BY v.fecha_venta DESC;

SELECT
    pl.id_plato,
    pl.nombre,
    COUNT(v.id_venta)   AS veces_vendido,
    SUM(v.precio)        AS ingresos_generados
FROM Ventas v
JOIN Platos pl ON pl.id_plato = v.id_plato
GROUP BY pl.id_plato, pl.nombre
ORDER BY veces_vendido DESC;

SELECT
    ing.id_ingrediente,
    ing.nombre,
    ing.Fecha_vencimiento,
    inv.cantidad
FROM Ingredientes ing
JOIN Inventarios inv ON inv.id_ingrediente = ing.id_ingrediente
WHERE inv.cantidad > 0;

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

SELECT
    id_ingrediente,
    cantidad
FROM Inventarios
WHERE cantidad > 0;

SELECT
    pl.id_plato,
    pl.nombre,
    pl.tiempo_preparacion
FROM Platos pl;

SELECT
    pl.id_plato,
    pl.nombre             AS plato,
    r.Nombre               AS receta,
    r.Descripcion,
    r.tiempo_preparacion,
    r.ingredientes
FROM Platos pl
JOIN Recetas r ON r.id_receta = pl.id_receta;

SELECT
    pl.id_plato,
    pl.nombre         AS plato,
    r.Nombre           AS receta,
    ing.id_ingrediente,
    ing.nombre        AS ingrediente,
    inv.cantidad
FROM Platos pl
JOIN Recetas r          ON r.id_receta = pl.id_receta
CROSS JOIN Ingredientes ing
JOIN Inventarios inv    ON inv.id_ingrediente = ing.id_ingrediente
WHERE inv.cantidad > 0;

-- PoblarNoOK
-- INSERT INTO Proveedores (nombre, telefono, correo)
-- VALUES ('Otro Proveedor', 3001111111, 'contacto@lafresca.com');

-- INSERT INTO Platos (nombre, tiempo_preparacion, id_receta)
-- VALUES ('Bandeja Paisa', 50, 1);

-- INSERT INTO Recetas (Nombre, tiempo_preparacion, Descripcion, ingredientes)
-- VALUES ('Ajiaco Santafereño', 55, 'Otra versión', 'pollo, papa');

-- INSERT INTO Ingredientes (nombre, Fecha_vencimiento)
-- VALUES ('Arroz', '2027-03-01');

-- INSERT INTO Compras (Fecha_compra, Fecha_recepcion, id_proveedor)
-- VALUES ('2026-09-26', NULL, 999);

-- INSERT INTO Ventas (fecha_venta, precio, id_plato)
-- VALUES ('2026-09-26', 20000.00, 999);

-- INSERT INTO Empleados (nombre, salario)
-- VALUES (NULL, 1500000.00);

-- INSERT INTO Proveedores (id_proveedor, nombre, telefono, correo)
-- VALUES (1, 'Duplicado', 3000000000, 'nuevo@correo.com');

-- INSERT INTO Empleados (nombre, salario)
-- VALUES ('Pedro Salas', 'mucho');

-- INSERT INTO Compras (Fecha_compra, Fecha_recepcion, id_proveedor)
-- VALUES ('no es fecha', NULL, 1);

-- INSERT INTO Causas_desperdicio (descripcion)
-- VALUES (REPEAT('x', 201));

-- INSERT INTO Empleados (nombre, salario)
-- VALUES ('Pedro Salas', -1500000.00);

-- INSERT INTO Proveedores (nombre, telefono, correo)
-- VALUES ('Proveedor Malo', 3005556677, 'correo-sin-arroba');

-- UPDATE Meseros SET turno = 'Madrugada' WHERE id_empleado = 2;

-- INSERT INTO Movimientos_inventario (fecha, tipo_movimiento, cantidad, id_ingrediente)
-- VALUES ('2026-10-01', 'Traslado', 5, 1);

-- INSERT INTO Movimientos_inventario (fecha, tipo_movimiento, cantidad, id_ingrediente)
-- VALUES ('2026-10-01', 'Entrada', 0, 1);

-- INSERT INTO Detalles_compra (cantidad, Total, id_compra, id_ingrediente)
-- VALUES (0, 50000.00, 1, 1);

-- INSERT INTO Ventas (fecha_venta, precio, id_plato)
-- VALUES ('2026-10-01', 0, 1);

-- Tuplas
ALTER TABLE Proveedores
ADD CONSTRAINT ck_proveedor_contacto
CHECK (telefono IS NOT NULL OR correo IS NOT NULL);

ALTER TABLE Compras
ADD CONSTRAINT ck_compra_fechas
CHECK (Fecha_recepcion IS NULL OR Fecha_recepcion >= Fecha_compra);

ALTER TABLE Recetas
ADD CONSTRAINT ck_receta_contenido
CHECK (Descripcion IS NOT NULL OR ingredientes IS NOT NULL);

-- TuplasOK
INSERT INTO Proveedores (nombre, telefono, correo)
VALUES ('Lácteos del Valle', NULL, 'ventas@lacteosvalle.com');

INSERT INTO Proveedores (nombre, telefono, correo)
VALUES ('Frutas El Campo', 3112223344, NULL);

INSERT INTO Compras (Fecha_compra, Fecha_recepcion, id_proveedor)
VALUES ('2026-10-01', '2026-10-03', 1);

INSERT INTO Compras (Fecha_compra, Fecha_recepcion, id_proveedor)
VALUES ('2026-10-05', '2026-10-05', 2);

INSERT INTO Recetas (Nombre, tiempo_preparacion, Descripcion, ingredientes)
VALUES ('Arepa de Choclo', 15, 'Arepa dulce de maíz tierno', NULL);

INSERT INTO Recetas (Nombre, tiempo_preparacion, Descripcion, ingredientes)
VALUES ('Changua', 20, NULL, 'leche, huevo, cebolla larga, cilantro, pan');

-- TuplasNoOK
-- INSERT INTO Proveedores (nombre, telefono, correo)
-- VALUES ('Proveedor Sin Contacto', NULL, NULL);

-- INSERT INTO Compras (Fecha_compra, Fecha_recepcion, id_proveedor)
-- VALUES ('2026-10-10', '2026-10-01', 1);

-- INSERT INTO Recetas (Nombre, tiempo_preparacion, Descripcion, ingredientes)
-- VALUES ('Receta Vacía', 30, NULL, NULL);

-- XPoblar
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

-----------------
--AccionesOK--
--1--
INSERT INTO Empleados(id_empleado, nombre, salario)
VALUES(99, 'jhojan', 2000);

INSERT INTO Cocineros(id_empleado, Especialidad)
VALUES(99, 'reposteria');

SELECT * FROM Cocineros WHERE id_empleado=99;

DELETE FROM Empleados WHERE id_empleado=99;

SELECT * FROM Cocineros WHERE id_empleado=99;

--2--
INSERT INTO Empleados(id_empleado, nombre, salario)
VALUES(109, 'JUAN', 4000);

INSERT INTO Meseros(id_empleado, turno)
VALUES(109, 'Noche');

SELECT * FROM Meseros WHERE id_empleado=109;

DELETE FROM Empleados WHERE id_empleado=109;

SELECT * FROM Meseros WHERE id_empleado=109;

--3--
INSERT INTO Ingredientes(id_ingrediente, nombre, Fecha_vencimiento)
VALUES(00099, 'Azúcar', '2030-07-17');

INSERT INTO Inventarios(id_ingrediente, cantidad)
VALUES(00099, 150);

SELECT * FROM Inventarios WHERE id_ingrediente=00099;

DELETE FROM Ingredientes WHERE id_ingrediente=00099;

SELECT * FROM Inventarios WHERE id_ingrediente=00099;

-- Disparadores
---Disparador 1: un cocinero no puede ser mesero
CREATE OR REPLACE FUNCTION f_cocinero_no_mesero() RETURNS TRIGGER AS $$
DECLARE
    v_cantidad INT;
BEGIN
    SELECT COUNT(*) INTO v_cantidad
    FROM Meseros
    WHERE id_empleado = NEW.id_empleado;

    IF v_cantidad > 0 THEN
        RAISE EXCEPTION 'El empleado % ya es mesero y no puede ser cocinero', NEW.id_empleado;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER t_cocinero_no_mesero
BEFORE INSERT OR UPDATE ON Cocineros
FOR EACH ROW EXECUTE FUNCTION f_cocinero_no_mesero();

---Disparador 2: al recibir una compra, sumar al inventario y registrar la entrada
CREATE OR REPLACE FUNCTION f_recibir_compra() RETURNS TRIGGER AS $$
BEGIN
    IF OLD.Fecha_recepcion IS NULL AND NEW.Fecha_recepcion IS NOT NULL THEN

        UPDATE Inventarios
        SET cantidad = cantidad + (SELECT SUM(d.cantidad)
FROM Detalles_compra d
WHERE d.id_compra = NEW.id_compra
AND d.id_ingrediente = Inventarios.id_ingrediente)
        WHERE id_ingrediente IN (SELECT id_ingrediente
FROM Detalles_compra
WHERE id_compra = NEW.id_compra);

INSERT INTO Movimientos_inventario (fecha, tipo_movimiento, cantidad, id_ingrediente)
        SELECT NEW.Fecha_recepcion, 'Entrada', SUM(cantidad), id_ingrediente
        FROM Detalles_compra
        WHERE id_compra = NEW.id_compra
        GROUP BY id_ingrediente;

    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER t_recibir_compra
AFTER UPDATE ON Compras
FOR EACH ROW EXECUTE FUNCTION f_recibir_compra();

---Disparador 3: no sacar más de lo que hay en el inventario
CREATE OR REPLACE FUNCTION f_salida_con_inventario() RETURNS TRIGGER AS $$
DECLARE
    v_cantidad INT;
BEGIN
    IF NEW.tipo_movimiento = 'Salida' THEN
        SELECT cantidad INTO v_cantidad
        FROM Inventarios
        WHERE id_ingrediente = NEW.id_ingrediente;

        IF v_cantidad < NEW.cantidad THEN
            RAISE EXCEPTION 'El ingrediente % solo tiene % unidades y no alcanza para una salida de %',
                NEW.id_ingrediente, v_cantidad, NEW.cantidad;
        END IF;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER t_salida_con_inventario
BEFORE INSERT ON Movimientos_inventario
FOR EACH ROW EXECUTE FUNCTION f_salida_con_inventario();

---Disparador 4: un mesero no puede ser cocinero
CREATE OR REPLACE FUNCTION f_mesero_no_cocinero() RETURNS TRIGGER AS $$
DECLARE
    v_cantidad INT;
BEGIN
    SELECT COUNT(*) INTO v_cantidad
    FROM Cocineros
    WHERE id_empleado = NEW.id_empleado;

    IF v_cantidad > 0 THEN
        RAISE EXCEPTION 'El empleado % ya es cocinero y no puede ser mesero', NEW.id_empleado;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER t_mesero_no_cocinero
BEFORE INSERT OR UPDATE ON Meseros
FOR EACH ROW EXECUTE FUNCTION f_mesero_no_cocinero();

---Disparador 5: al registrar una salida, descontarla del inventario
CREATE OR REPLACE FUNCTION f_descontar_salida() RETURNS TRIGGER AS $$
BEGIN
    IF NEW.tipo_movimiento = 'Salida' THEN
        UPDATE Inventarios
        SET cantidad = cantidad - NEW.cantidad
        WHERE id_ingrediente = NEW.id_ingrediente;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER t_descontar_salida
AFTER INSERT ON Movimientos_inventario
FOR EACH ROW EXECUTE FUNCTION f_descontar_salida();

-- DisparadoresOK
INSERT INTO Empleados (nombre, salario)
VALUES ('Camila Rojas', 1700000.00);

INSERT INTO Cocineros (id_empleado, Especialidad)
VALUES ((SELECT id_empleado FROM Empleados WHERE nombre = 'Camila Rojas'), 'Pastelería');

SELECT * FROM Cocineros;

SELECT * FROM Inventarios WHERE id_ingrediente = 3;

UPDATE Compras SET Fecha_recepcion = '2026-09-22' WHERE id_compra = 3;

SELECT * FROM Inventarios WHERE id_ingrediente = 3;

SELECT * FROM Movimientos_inventario WHERE id_ingrediente = 3;

SELECT * FROM Inventarios WHERE id_ingrediente = 1;

INSERT INTO Movimientos_inventario (fecha, tipo_movimiento, cantidad, id_ingrediente)
VALUES ('2026-10-01', 'Salida', 8, 1);

SELECT * FROM Movimientos_inventario WHERE id_ingrediente = 1;

SELECT * FROM Inventarios WHERE id_ingrediente = 1;

INSERT INTO Empleados (nombre, salario)
VALUES ('Ricardo Pineda', 1550000.00);

INSERT INTO Meseros (id_empleado, turno)
VALUES ((SELECT id_empleado FROM Empleados WHERE nombre = 'Ricardo Pineda'), 'Noche');

SELECT * FROM Meseros;

-- DisparadoresNoOK
-- INSERT INTO Cocineros (id_empleado, Especialidad)
-- VALUES (2, 'Postres');

-- UPDATE Cocineros SET id_empleado = 4 WHERE id_empleado = 1;

-- UPDATE Inventarios SET cantidad = 0 WHERE id_ingrediente = 4;
-- INSERT INTO Movimientos_inventario (fecha, tipo_movimiento, cantidad, id_ingrediente)
-- VALUES ('2026-10-01', 'Salida', 1, 4);

-- INSERT INTO Movimientos_inventario (fecha, tipo_movimiento, cantidad, id_ingrediente)
-- VALUES ('2026-10-01', 'Salida', 999, 5);

-- INSERT INTO Meseros (id_empleado, turno)
-- VALUES (1, 'Noche');

-- UPDATE Meseros SET id_empleado = 3 WHERE id_empleado = 2;

-- XDisparadores
-- DROP TRIGGER IF EXISTS t_cocinero_no_mesero ON Cocineros;
-- DROP TRIGGER IF EXISTS t_recibir_compra ON Compras;
-- DROP TRIGGER IF EXISTS t_salida_con_inventario ON Movimientos_inventario;
-- DROP TRIGGER IF EXISTS t_mesero_no_cocinero ON Meseros;
-- DROP TRIGGER IF EXISTS t_descontar_salida ON Movimientos_inventario;
-- DROP FUNCTION IF EXISTS f_cocinero_no_mesero();
-- DROP FUNCTION IF EXISTS f_recibir_compra();
-- DROP FUNCTION IF EXISTS f_salida_con_inventario();
-- DROP FUNCTION IF EXISTS f_mesero_no_cocinero();
-- DROP FUNCTION IF EXISTS f_descontar_salida();
