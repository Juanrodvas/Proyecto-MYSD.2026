-- ComponentesOK
-- Caso 1: registrar una compra al proveedor 1
SELECT sv_entradas.adicionarCompra('2026-10-06', 1);

SELECT * FROM Compras WHERE id_compra = (SELECT MAX(id_compra) FROM Compras);

-- Caso 2: agregar dos ingredientes a esa compra
SELECT sv_entradas.adicionarDetalle((SELECT MAX(id_compra) FROM Compras), 3, 20, 140000.00);

SELECT sv_entradas.adicionarDetalle((SELECT MAX(id_compra) FROM Compras), 5, 10, 80000.00);

SELECT * FROM Detalles_compra WHERE id_compra = (SELECT MAX(id_compra) FROM Compras);

-- Caso 3: recibir la compra; el inventario de los ingredientes 3 y 5 sube solo
SELECT * FROM Inventarios WHERE id_ingrediente IN (3, 5) ORDER BY id_ingrediente;

SELECT sv_entradas.modificarRecepcion((SELECT MAX(id_compra) FROM Compras), '2026-10-08');

SELECT * FROM Inventarios WHERE id_ingrediente IN (3, 5) ORDER BY id_ingrediente;

SELECT * FROM Movimientos_inventario WHERE id_detalle_compra IN (SELECT id_detalle FROM Detalles_compra WHERE id_compra = (SELECT MAX(id_compra) FROM Compras));

-- Caso 4: consultar la compra
BEGIN;
SELECT sv_entradas.consultarCompra((SELECT MAX(id_compra) FROM Compras));
FETCH ALL FROM compra_cursor;
COMMIT;

-- Caso 5: eliminar una compra que todavía no se ha recibido
SELECT sv_entradas.adicionarCompra('2026-10-09', 2);

SELECT sv_entradas.adicionarDetalle((SELECT MAX(id_compra) FROM Compras), 4, 5, 40000.00);

SELECT sv_entradas.eliminarCompra((SELECT MAX(id_compra) FROM Compras));

SELECT * FROM Compras ORDER BY id_compra DESC LIMIT 2;

-- Caso 6: registrar un desperdicio de 1 kg del ingrediente 3; el inventario baja solo
SELECT * FROM Inventarios WHERE id_ingrediente = 3;

SELECT sv_desperdicios.adicionarDesperdicio('2026-10-10', 1.0, 3, 1, 2);

SELECT * FROM Desperdicios WHERE id_desperdicio = (SELECT MAX(id_desperdicio) FROM Desperdicios);

SELECT * FROM Inventarios WHERE id_ingrediente = 3;

-- Caso 7: cambiar la causa de ese desperdicio
SELECT sv_desperdicios.modificarCausa((SELECT MAX(id_desperdicio) FROM Desperdicios), 3);

BEGIN;
SELECT sv_desperdicios.consultarDesperdicio((SELECT MAX(id_desperdicio) FROM Desperdicios));
FETCH ALL FROM desperdicio_cursor;
COMMIT;

-- Caso 8: consultar los movimientos del ingrediente 3
BEGIN;
SELECT sv_desperdicios.consultarMovimientos(3);
FETCH ALL FROM movimientos_cursor;
COMMIT;

-- Caso 9: eliminar el desperdicio; el inventario vuelve a su valor y se borra su movimiento
SELECT sv_desperdicios.eliminarDesperdicio((SELECT MAX(id_desperdicio) FROM Desperdicios));

SELECT * FROM Inventarios WHERE id_ingrediente = 3;
