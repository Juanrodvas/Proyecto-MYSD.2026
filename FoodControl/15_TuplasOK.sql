-- TuplasOK
INSERT INTO Proveedores (nombre, telefono, correo)
VALUES ('Lácteos del Valle', NULL, 'ventas@lacteosvalle.com');

INSERT INTO Proveedores (nombre, telefono, correo)
VALUES ('Frutas El Campo', 3112223344, NULL);

INSERT INTO Compras (Fecha_compra, Fecha_recepcion, id_proveedor)
VALUES ('2026-10-01', '2026-10-03', 1);

INSERT INTO Compras (Fecha_compra, Fecha_recepcion, id_proveedor)
VALUES ('2026-10-05', '2026-10-05', 2);

INSERT INTO Menus (nombre, fecha_inicio, fecha_fin, activo)
VALUES ('Menú de temporada', '2027-01-01', NULL, FALSE);

INSERT INTO Menus (nombre, fecha_inicio, fecha_fin, activo)
VALUES ('Menú de un día', '2027-02-14', '2027-02-14', FALSE);

INSERT INTO Movimientos_inventario (fecha, tipo_movimiento, cantidad, id_ingrediente, origen, id_detalle_compra)
VALUES ('2026-10-06', 'Entrada', 5, 1, 'Compra', 1);
