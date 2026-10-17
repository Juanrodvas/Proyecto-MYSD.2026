-- 1) Viola UNIQUE (correo ya usado por 'Distribuidora La Fresca')
INSERT INTO Proveedores (nombre, telefono, correo)
VALUES ('Otro Proveedor', 3001111111, 'contacto@lafresca.com');

-- 2) Viola UNIQUE (ya existe un plato llamado 'Bandeja Paisa')
INSERT INTO Platos (nombre, tiempo_preparacion, id_receta)
VALUES ('Bandeja Paisa', 50, 1);

-- 3) Viola UNIQUE (ya existe una receta llamada 'Ajiaco Santafereño')
INSERT INTO Recetas (Nombre, tiempo_preparacion, Descripcion, ingredientes)
VALUES ('Ajiaco Santafereño', 55, 'Otra versión', 'pollo, papa');

-- 4) Viola llave foránea (id_proveedor 999 no existe en Proveedores)
INSERT INTO Compras (Fecha_compra, Fecha_recepcion, id_proveedor)
VALUES ('2026-09-26', NULL, 999);

-- 5) Viola llave foránea (id_plato 999 no existe en Platos)
INSERT INTO Ventas (fecha_venta, precio, id_plato)
VALUES ('2026-09-26', 20000.00, 999);

-- 6) Viola NOT NULL (nombre es obligatorio en Empleados)
INSERT INTO Empleados (nombre, salario)
VALUES (NULL, 1500000.00);

-- 7) Viola llave primaria (id_provedor 1 ya existe)
INSERT INTO Proveedores (id_provedor, nombre, telefono, correo)
VALUES (1, 'Duplicado', 3000000000, 'nuevo@correo.com');