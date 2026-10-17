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