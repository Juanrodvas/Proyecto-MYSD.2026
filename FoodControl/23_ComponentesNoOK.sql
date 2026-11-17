-- ComponentesNoOK
-- [fk_compra_proveedor] compra a un proveedor que no existe
-- SELECT sv_entradas.adicionarCompra('2026-10-06', 999);

-- [uq_detalle_compra_ingrediente] el ingrediente 1 ya está en la compra 1
-- SELECT sv_entradas.adicionarDetalle(1, 1, 5, 30000.00);

-- [ck_detalle_cantidad] cantidad cero en el detalle
-- SELECT sv_entradas.adicionarDetalle(1, 2, 0, 30000.00);

-- [ck_compra_fechas] recepción antes de la fecha de compra
-- SELECT sv_entradas.modificarRecepcion(1, '2000-01-01');

-- [fk_movimiento_detalle_compra] la compra 3 ya se recibió y tiene movimientos de inventario
-- SELECT sv_entradas.eliminarCompra(3);

-- [fk_desperdicio_causa] desperdicio con una causa que no existe
-- SELECT sv_desperdicios.adicionarDesperdicio('2026-10-10', 1.0, 3, 1, 999);

-- [ck_desperdicio_cantidad] desperdicio de cantidad cero
-- SELECT sv_desperdicios.adicionarDesperdicio('2026-10-10', 0, 3, 1, 2);

-- [fk_desperdicio_causa] cambiar la causa por una que no existe
-- SELECT sv_desperdicios.modificarCausa(1, 999);

-- [disparador 3] desperdicio de 999 unidades: no alcanza el inventario
-- SELECT sv_desperdicios.adicionarDesperdicio('2026-10-10', 999, 5, 1, 2);

-- Poblar masivo (va al final, cuando ya existen los disparadores)
-- Agrega 940 filas: 150 ventas con 450 detalles, 60 compras con 180 detalles y 100 desperdicios.
-- Se apagan los disparadores solo mientras se insertan, para que no descuenten del inventario.
ALTER TABLE Ventas DISABLE TRIGGER USER;
ALTER TABLE Detalles_venta DISABLE TRIGGER USER;
ALTER TABLE Compras DISABLE TRIGGER USER;
ALTER TABLE Detalles_compra DISABLE TRIGGER USER;
ALTER TABLE Desperdicios DISABLE TRIGGER USER;

-- Último id de venta y de compra que hay antes de insertar
CREATE TEMP TABLE limites AS
SELECT (SELECT COALESCE(MAX(id_venta), 0) FROM Ventas) AS ultima_venta,
       (SELECT COALESCE(MAX(id_compra), 0) FROM Compras) AS ultima_compra;

-- 150 ventas, cada una atendida por un mesero distinto en rotación
INSERT INTO Ventas (fecha_venta, total, id_mesero)
SELECT
    DATE '2026-07-01' + (i * 7) % 96,
    0,
    (SELECT id_empleado FROM Meseros ORDER BY id_empleado OFFSET i % (SELECT COUNT(*) FROM Meseros) LIMIT 1)
FROM generate_series(1, 150) AS i;

-- 3 platos distintos por venta (450 detalles)
INSERT INTO Detalles_venta (cantidad, precio_unitario, id_venta, id_plato)
SELECT
    1 + (v.id_venta + k) % 3,
    15000.00 + ((v.id_venta + k) % 5) * 3000,
    v.id_venta,
    1 + (v.id_venta + k * 4) % 15
FROM Ventas v, generate_series(0, 2) AS k
WHERE v.id_venta > (SELECT ultima_venta FROM limites);

-- El total de cada venta nueva es la suma de sus detalles
UPDATE Ventas
SET total = (SELECT SUM(d.cantidad * d.precio_unitario)
             FROM Detalles_venta d
             WHERE d.id_venta = Ventas.id_venta)
WHERE id_venta > (SELECT ultima_venta FROM limites);

-- 60 compras, recibidas entre 1 y 5 días después
INSERT INTO Compras (Fecha_compra, Fecha_recepcion, id_proveedor)
SELECT
    DATE '2026-07-01' + (i * 5) % 96,
    DATE '2026-07-01' + (i * 5) % 96 + 1 + i % 5,
    (SELECT id_proveedor FROM Proveedores ORDER BY id_proveedor OFFSET i % (SELECT COUNT(*) FROM Proveedores) LIMIT 1)
FROM generate_series(1, 60) AS i;

-- 3 ingredientes distintos por compra (180 detalles)
INSERT INTO Detalles_compra (cantidad, Total, id_compra, id_ingrediente)
SELECT
    10 + (c.id_compra + k) % 11,
    (10 + (c.id_compra + k) % 11) * 7000.00,
    c.id_compra,
    1 + (c.id_compra + k * 4) % 15
FROM Compras c, generate_series(0, 2) AS k
WHERE c.id_compra > (SELECT ultima_compra FROM limites);

-- 100 desperdicios
INSERT INTO Desperdicios (fecha, cantidad, id_ingrediente, id_empleado, id_causa)
SELECT
    DATE '2026-07-01' + (i * 3) % 96,
    0.5 + (i % 6) * 0.5,
    1 + i % 15,
    1 + i % 30,
    1 + i % 15
FROM generate_series(1, 100) AS i;

DROP TABLE limites;

ALTER TABLE Ventas ENABLE TRIGGER USER;
ALTER TABLE Detalles_venta ENABLE TRIGGER USER;
ALTER TABLE Compras ENABLE TRIGGER USER;
ALTER TABLE Detalles_compra ENABLE TRIGGER USER;
ALTER TABLE Desperdicios ENABLE TRIGGER USER;
