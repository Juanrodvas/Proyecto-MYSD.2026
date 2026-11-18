-- PoblarOK
INSERT INTO Proveedores (nombre, telefono, correo) VALUES
('Distribuidora La Fresca', 3001234567, 'contacto@lafresca.com'),
('AgroSuministros SAS',     3007654321, 'ventas@agrosuministros.com'),
('Carnes Premium Ltda',     3009876543, 'info@carnespremium.com');

INSERT INTO Empleados (nombre, salario) VALUES
('Carlos Ramírez',  1800000.00),
('Laura Gómez',     1600000.00),
('Andrés Torres',   1700000.00),
('Mariana Ríos',    1550000.00);

INSERT INTO Causas_desperdicio (descripcion) VALUES
('Producto vencido'),
('Error de preparación'),
('Sobreproducción');

INSERT INTO Ingredientes (nombre, Fecha_vencimiento, unidad_medida, stock_minimo, costo_unitario) VALUES
('Arroz',        '2026-12-01', 'kg', 10, 4500.00),
('Papa criolla', '2026-11-15', 'kg', 10, 3500.00),
('Carne de res', '2027-01-20', 'kg', 15, 28000.00),
('Pollo',        '2026-10-10', 'kg', 10, 12000.00),
('Fríjol',       '2026-12-25', 'kg', 8,  7000.00);

INSERT INTO Recetas (Nombre, tiempo_preparacion, Descripcion) VALUES
('Bandeja Paisa',       45, 'Plato típico colombiano'),
('Ajiaco Santafereño',  60, 'Sopa típica bogotana'),
('Ensalada César',      20, 'Ensalada con pollo a la parrilla');

INSERT INTO Cocineros (id_empleado, Especialidad) VALUES
(1, 'Cocina Colombiana'),
(3, 'Parrilla');

INSERT INTO Meseros (id_empleado, turno) VALUES
(2, 'Mañana'),
(4, 'Tarde');

INSERT INTO Inventarios (id_ingrediente, cantidad_disponible) VALUES
(1, 50),
(2, 30),
(3, 80),
(4, 15),
(5, 60);

INSERT INTO Movimientos_inventario (fecha, tipo_movimiento, cantidad, id_ingrediente, origen, id_empleado) VALUES
('2026-09-20', 'Entrada', 20, 1, 'Compra', 1),
('2026-09-21', 'Salida',  5,  2, 'Venta',  2),
('2026-09-22', 'Entrada', 10, 3, 'Compra', 3);

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

-- Dos cuentas con varios platos cada una
INSERT INTO Ventas (fecha_venta, total, id_mesero) VALUES
('2026-09-24', 68000.00, 2),
('2026-09-25', 70000.00, 4);

INSERT INTO Detalles_venta (cantidad, precio_unitario, id_venta, id_plato) VALUES
(2, 25000.00, 1, 1),
(1, 18000.00, 1, 2),
(3, 15000.00, 2, 3),
(1, 25000.00, 2, 1);

INSERT INTO Desperdicios (fecha, cantidad, id_ingrediente, id_empleado, id_causa) VALUES
('2026-09-23', 2.5, 2, 1, 1),
('2026-09-24', 1.2, 4, 3, 3);

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

INSERT INTO Ingredientes (nombre, Fecha_vencimiento, unidad_medida, stock_minimo, costo_unitario)
SELECT
    (ARRAY['Plátano', 'Huevo', 'Queso costeño', 'Yuca', 'Cebolla larga',
        'Mazorca', 'Cilantro', 'Leche', 'Camarón', 'Lechuga'])[i],
    DATE '2026-11-01' + i * 7,
    (ARRAY['unidad', 'unidad', 'kg', 'kg', 'kg',
        'unidad', 'kg', 'L', 'kg', 'kg'])[i],
    (ARRAY[20, 30, 5, 8, 3, 15, 1, 10, 5, 4])[i],
    (ARRAY[800, 600, 18000, 2500, 4000, 1500, 15000, 3800, 35000, 3000])[i]
FROM generate_series(1, 10) AS i;

INSERT INTO Recetas (Nombre, tiempo_preparacion, Descripcion)
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
        'Arroz caldoso vallecaucano', 'Pescado cocido al vapor con plátano'])[i]
FROM generate_series(1, 12) AS i;

-- Ingredientes de cada receta, con la cantidad que lleva UNA porción
-- Ingredientes: 1 Arroz, 2 Papa criolla, 3 Carne de res, 4 Pollo, 5 Fríjol, 6 Plátano, 7 Huevo,
-- 8 Queso costeño, 9 Yuca, 10 Cebolla larga, 11 Mazorca, 12 Cilantro, 13 Leche, 14 Camarón, 15 Lechuga
INSERT INTO Recetas_ingredientes (id_receta, id_ingrediente, cantidad) VALUES
(1, 3, 0.25), (1, 5, 0.20), (1, 1, 0.15), (1, 6, 1),    (1, 7, 1),       -- Bandeja Paisa
(2, 4, 0.30), (2, 2, 0.40), (2, 11, 1),   (2, 12, 0.01),                  -- Ajiaco Santafereño
(3, 15, 0.15), (3, 4, 0.15), (3, 8, 0.05),                                -- Ensalada César
(4, 4, 0.40), (4, 2, 0.20), (4, 9, 0.20), (4, 11, 1), (4, 12, 0.01),      -- Sancocho de Gallina
(5, 1, 0.20), (5, 4, 0.25),                                               -- Arroz con Pollo
(6, 2, 0.20), (6, 9, 0.20), (6, 12, 0.01),                                -- Mondongo
(7, 1, 0.20), (7, 10, 0.05),                                              -- Lechona
(8, 7, 1),    (8, 4, 0.15),                                               -- Tamal Tolimense
(9, 14, 0.25), (9, 13, 0.10),                                             -- Cazuela de Mariscos
(10, 3, 0.30), (10, 10, 0.05),                                            -- Posta Negra
(11, 3, 0.30), (11, 2, 0.20),                                             -- Sobrebarriga
(12, 5, 0.25), (12, 6, 1),                                                -- Frijolada
(13, 8, 0.15), (13, 10, 0.03),                                            -- Mote de Queso
(14, 1, 0.20), (14, 4, 0.20), (14, 2, 0.15),                              -- Arroz Atollado
(15, 6, 1),    (15, 9, 0.20);                                             -- Viudo de Pescado

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

INSERT INTO Inventarios (id_ingrediente, cantidad_disponible)
SELECT
    i,
    20 + i * 5
FROM generate_series(6, 15) AS i;

INSERT INTO Movimientos_inventario (fecha, tipo_movimiento, cantidad, id_ingrediente, origen, id_empleado)
SELECT
    DATE '2026-09-22' + i,
    CASE WHEN i % 2 = 0 THEN 'Entrada' ELSE 'Salida' END,
    2 + i % 4,
    1 + i % 15,
    CASE WHEN i % 2 = 0 THEN 'Compra' ELSE 'Venta' END,
    1 + i % 4
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

-- 13 cuentas nuevas (id 3 a 15), cada una con un plato; el total es precio x cantidad
INSERT INTO Ventas (fecha_venta, total, id_mesero)
SELECT
    DATE '2026-09-26' + i % 10,
    (15000.00 + (i % 5) * 3000) * (1 + i % 3),
    18 + i % 13
FROM generate_series(1, 13) AS i;

INSERT INTO Detalles_venta (cantidad, precio_unitario, id_venta, id_plato)
SELECT
    1 + i % 3,
    15000.00 + (i % 5) * 3000,
    i + 2,
    1 + i % 15
FROM generate_series(1, 13) AS i;

INSERT INTO Desperdicios (fecha, cantidad, id_ingrediente, id_empleado, id_causa)
SELECT
    DATE '2026-09-25' + i,
    0.5 + (i % 4) * 0.5,
    1 + i % 15,
    4 + i,
    1 + i % 15
FROM generate_series(1, 13) AS i;

-- Desperdicios registrados por meseros (uno por turno y varios en la noche),
-- para que las consultas gerenciales por turno y por area tengan datos de Salon
INSERT INTO Desperdicios (fecha, cantidad, id_ingrediente, id_empleado, id_causa) VALUES
('2026-09-25', 0.8, 1, 2,  4),
('2026-09-26', 1.5, 3, 4,  2),
('2026-10-02', 1.0, 5, 20, 6),
('2026-10-04', 0.5, 6, 23, 7),
('2026-10-05', 1.2, 8, 26, 1);

-- Menús: lo que ofrece el restaurante
INSERT INTO Menus (nombre, fecha_inicio, fecha_fin, activo) VALUES
('Carta principal', '2026-09-01', NULL,         TRUE),
('Menú del día',    '2026-10-01', '2026-10-31', FALSE),
('Menú navideño',   '2026-12-01', '2026-12-31', FALSE);

-- La carta principal ofrece todos los platos
INSERT INTO Menus_platos (id_menu, id_plato, precio, disponible)
SELECT 1, id_plato, 15000.00 + (id_plato % 5) * 3000, TRUE
FROM Platos;

INSERT INTO Menus_platos (id_menu, id_plato, precio, disponible) VALUES
(2, 2, 14000.00, TRUE),
(2, 5, 13000.00, TRUE),
(2, 11, 15000.00, FALSE),
(3, 8, 22000.00, TRUE),
(3, 7, 28000.00, TRUE);
