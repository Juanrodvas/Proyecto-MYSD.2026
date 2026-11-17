-- TuplasNoOK
-- INSERT INTO Proveedores (nombre, telefono, correo)
-- VALUES ('Proveedor Sin Contacto', NULL, NULL);

-- INSERT INTO Compras (Fecha_compra, Fecha_recepcion, id_proveedor)
-- VALUES ('2026-10-10', '2026-10-01', 1);

-- INSERT INTO Menus (nombre, fecha_inicio, fecha_fin, activo)
-- VALUES ('Menú al revés', '2027-03-10', '2027-03-01', TRUE);

-- Movimiento de venta pero apuntando a un detalle de compra
-- INSERT INTO Movimientos_inventario (fecha, tipo_movimiento, cantidad, id_ingrediente, origen, id_detalle_compra)
-- VALUES ('2026-10-06', 'Salida', 1, 1, 'Venta', 1);

-- Movimiento que apunta a la vez a un detalle de compra y a un desperdicio
-- INSERT INTO Movimientos_inventario (fecha, tipo_movimiento, cantidad, id_ingrediente, origen, id_detalle_compra, id_desperdicio)
-- VALUES ('2026-10-06', 'Entrada', 1, 1, 'Compra', 1, 1);

-- [ck_movimiento_tipo_origen] una entrada que viene de una venta
-- INSERT INTO Movimientos_inventario (fecha, tipo_movimiento, cantidad, id_ingrediente, origen)
-- VALUES ('2026-10-06', 'Entrada', 1, 1, 'Venta');

-- [ck_movimiento_tipo_origen] una salida que viene de una compra
-- INSERT INTO Movimientos_inventario (fecha, tipo_movimiento, cantidad, id_ingrediente, origen)
-- VALUES ('2026-10-06', 'Salida', 1, 1, 'Compra');

-- [ck_movimiento_tipo_origen] una entrada que viene de un desperdicio
-- INSERT INTO Movimientos_inventario (fecha, tipo_movimiento, cantidad, id_ingrediente, origen)
-- VALUES ('2026-10-06', 'Entrada', 1, 1, 'Desperdicio');
