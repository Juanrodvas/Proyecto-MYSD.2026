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

INSERT INTO Movimientos_inventario (fecha, tipo_movimiento, cantidad, id_ingrediente, origen)
VALUES ('2026-10-01', 'Salida', 8, 1, 'Venta');

SELECT * FROM Movimientos_inventario WHERE id_ingrediente = 1;

SELECT * FROM Inventarios WHERE id_ingrediente = 1;

INSERT INTO Empleados (nombre, salario)
VALUES ('Ricardo Pineda', 1550000.00);

INSERT INTO Meseros (id_empleado, turno)
VALUES ((SELECT id_empleado FROM Empleados WHERE nombre = 'Ricardo Pineda'), 'Noche');

SELECT * FROM Meseros;

-- Disparador 6: se venden 2 Ajiacos (receta: 0.30 kg pollo, 0.40 kg papa, 1 mazorca, 0.01 kg cilantro)
-- y el inventario de esos 4 ingredientes baja solo
SELECT * FROM Inventarios WHERE id_ingrediente IN (2, 4, 11, 12) ORDER BY id_ingrediente;

INSERT INTO Ventas (fecha_venta, id_mesero)
VALUES ('2026-10-02', 2);

INSERT INTO Detalles_venta (cantidad, precio_unitario, id_venta, id_plato)
VALUES (2, 18000.00, (SELECT MAX(id_venta) FROM Ventas), 2);

SELECT * FROM Movimientos_inventario WHERE id_detalle_venta = (SELECT MAX(id_detalle_venta) FROM Detalles_venta);

-- Disparador 8: el total de la venta quedó en 2 x 18000 = 36000
SELECT * FROM Ventas WHERE id_venta = (SELECT MAX(id_venta) FROM Ventas);

SELECT * FROM Inventarios WHERE id_ingrediente IN (2, 4, 11, 12) ORDER BY id_ingrediente;

-- Disparador 7: se botan 1.5 kg de papa criolla y el inventario baja solo
INSERT INTO Desperdicios (fecha, cantidad, id_ingrediente, id_empleado, id_causa)
VALUES ('2026-10-03', 1.5, 2, 1, 1);

SELECT * FROM Movimientos_inventario WHERE id_desperdicio = (SELECT MAX(id_desperdicio) FROM Desperdicios);

SELECT * FROM Inventarios WHERE id_ingrediente = 2;
