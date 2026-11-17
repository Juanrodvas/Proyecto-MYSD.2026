-- DisparadoresNoOK
-- INSERT INTO Cocineros (id_empleado, Especialidad)
-- VALUES (2, 'Postres');

-- UPDATE Cocineros SET id_empleado = 4 WHERE id_empleado = 1;

-- UPDATE Inventarios SET cantidad_disponible = 0 WHERE id_ingrediente = 4;
-- INSERT INTO Movimientos_inventario (fecha, tipo_movimiento, cantidad, id_ingrediente, origen)
-- VALUES ('2026-10-01', 'Salida', 1, 4, 'Venta');

-- INSERT INTO Movimientos_inventario (fecha, tipo_movimiento, cantidad, id_ingrediente, origen)
-- VALUES ('2026-10-01', 'Salida', 999, 5, 'Venta');

-- Venta de 100 Ajiacos: necesita 30 kg de pollo y no hay suficiente (disparadores 6 y 3)
-- INSERT INTO Ventas (fecha_venta, id_mesero)
-- VALUES ('2026-10-04', 2);
-- INSERT INTO Detalles_venta (cantidad, precio_unitario, id_venta, id_plato)
-- VALUES (100, 18000.00, (SELECT MAX(id_venta) FROM Ventas), 2);

-- Desperdicio mayor que lo que hay en inventario (disparadores 7 y 3)
-- INSERT INTO Desperdicios (fecha, cantidad, id_ingrediente, id_empleado, id_causa)
-- VALUES ('2026-10-04', 500, 3, 1, 1);

-- INSERT INTO Meseros (id_empleado, turno)
-- VALUES (1, 'Noche');

-- UPDATE Meseros SET id_empleado = 3 WHERE id_empleado = 2;
