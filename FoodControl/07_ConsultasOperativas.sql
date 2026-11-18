-- ConsultasOperativas

-- O1. Como administrador quiero consultar las compras realizadas en un mes
-- para poder hacer un balance de la comida desperdiciada.
-- Cambie las fechas del BETWEEN para consultar otro mes.
SELECT c.id_compra, c.fecha_compra, p.nombre AS proveedor, SUM(dc.Total) AS total_compra
FROM Compras c
JOIN Proveedores p ON p.id_proveedor = c.id_proveedor
JOIN Detalles_compra dc ON dc.id_compra = c.id_compra
WHERE c.fecha_compra BETWEEN '2026-09-01' AND '2026-09-30'
GROUP BY c.id_compra, c.fecha_compra, p.nombre
ORDER BY c.fecha_compra;

-- O2. Como administrador quiero consultar los proveedores
-- para saber quien es el proveedor que mas envia ingredientes.
SELECT p.nombre AS proveedor, p.telefono, p.correo,
       COUNT(DISTINCT c.id_compra) AS compras, SUM(dc.cantidad) AS cantidad_enviada
FROM Proveedores p
JOIN Compras c ON c.id_proveedor = p.id_proveedor
JOIN Detalles_compra dc ON dc.id_compra = c.id_compra
GROUP BY p.nombre, p.telefono, p.correo
ORDER BY cantidad_enviada DESC;

-- O3. Como administrador quiero consultar el inventario
-- para saber que ingredientes tengo disponibles y que tengo que pedir.
-- Un sobrante negativo significa que esta por debajo del stock minimo y hay que pedirlo.
SELECT i.nombre AS ingrediente, inv.cantidad_disponible, i.unidad_medida, i.stock_minimo,
       inv.cantidad_disponible - i.stock_minimo AS sobrante
FROM Inventarios inv
JOIN Ingredientes i ON i.id_ingrediente = inv.id_ingrediente
ORDER BY sobrante, i.nombre;

-- O4. Como administrador quiero consultar cada movimiento del inventario
-- para saber cual ingrediente tiene mas rotacion y cual se queda mucho tiempo sin salir.
SELECT i.nombre AS ingrediente, m.tipo_movimiento, COUNT(*) AS movimientos,
       SUM(m.cantidad) AS cantidad_total, MAX(m.fecha) AS ultimo_movimiento,
       CURRENT_DATE - MAX(m.fecha) AS dias_sin_movimiento
FROM Movimientos_inventario m
JOIN Ingredientes i ON i.id_ingrediente = m.id_ingrediente
GROUP BY i.nombre, m.tipo_movimiento
ORDER BY m.tipo_movimiento, cantidad_total DESC;

-- O5. Como administrador quiero consultar las ventas realizadas de cada mes
-- para tener un balance entre el desperdicio de comida y las ganancias de las ventas.
SELECT EXTRACT(YEAR FROM v.fecha_venta) AS anio, EXTRACT(MONTH FROM v.fecha_venta) AS mes,
       COUNT(*) AS cuentas, SUM(v.total) AS total_vendido
FROM Ventas v
GROUP BY EXTRACT(YEAR FROM v.fecha_venta), EXTRACT(MONTH FROM v.fecha_venta)
ORDER BY anio, mes;

-- O6. Como administrador quiero consultar los platos mas vendidos de cada mes
-- para comprar los ingredientes mas usados en esos platos y reducir los desperdicios.
SELECT EXTRACT(YEAR FROM v.fecha_venta) AS anio, EXTRACT(MONTH FROM v.fecha_venta) AS mes,
       p.nombre AS plato, SUM(dv.cantidad) AS unidades_vendidas
FROM Detalles_venta dv
JOIN Ventas v ON v.id_venta = dv.id_venta
JOIN Platos p ON p.id_plato = dv.id_plato
GROUP BY EXTRACT(YEAR FROM v.fecha_venta), EXTRACT(MONTH FROM v.fecha_venta), p.nombre
ORDER BY anio, mes, unidades_vendidas DESC;

-- O7. Como administrador quiero consultar la lista de compras con los ingredientes que estan por debajo del stock minimo
-- para saber que tengo que pedir a los proveedores antes de que se acaben.
SELECT i.nombre AS ingrediente, inv.cantidad_disponible, i.stock_minimo,
       i.stock_minimo - inv.cantidad_disponible AS faltante,
       (i.stock_minimo - inv.cantidad_disponible) * i.costo_unitario AS costo_estimado
FROM Inventarios inv
JOIN Ingredientes i ON i.id_ingrediente = inv.id_ingrediente
WHERE inv.cantidad_disponible < i.stock_minimo
ORDER BY faltante DESC;

-- O8. Como administrador quiero consultar los platos del menu que estan en riesgo por falta de algun ingrediente
-- para avisar a tiempo, reponer el ingrediente y no dejar de ofrecer esos platos.
-- Un plato esta en riesgo si algun ingrediente de su receta esta por debajo del stock minimo.
SELECT DISTINCT m.nombre AS menu, p.nombre AS plato, i.nombre AS ingrediente_en_riesgo,
                inv.cantidad_disponible, i.stock_minimo
FROM Menus m
JOIN Menus_platos mp ON mp.id_menu = m.id_menu
JOIN Platos p ON p.id_plato = mp.id_plato
JOIN Recetas_ingredientes ri ON ri.id_receta = p.id_receta
JOIN Ingredientes i ON i.id_ingrediente = ri.id_ingrediente
JOIN Inventarios inv ON inv.id_ingrediente = i.id_ingrediente
WHERE m.activo = TRUE AND inv.cantidad_disponible < i.stock_minimo
ORDER BY m.nombre, p.nombre;

-- O9. Como administrador quiero consultar el detalle de una venta: platos, cantidades, precio y mesero
-- para revisar lo que se vendio en cada cuenta y compararlo con los ingredientes que salieron.
-- Cambie el 1 para consultar otra venta.
SELECT v.id_venta, v.fecha_venta, e.nombre AS mesero, p.nombre AS plato, dv.cantidad,
       dv.precio_unitario, dv.cantidad * dv.precio_unitario AS subtotal
FROM Ventas v
JOIN Empleados e ON e.id_empleado = v.id_mesero
JOIN Detalles_venta dv ON dv.id_venta = v.id_venta
JOIN Platos p ON p.id_plato = dv.id_plato
WHERE v.id_venta = 1
ORDER BY p.nombre;

-- O10. Como administrador quiero consultar los desperdicios de cada mes
-- para observar en que meses hay mas desperdicios y como reducirlos al minimo.
SELECT EXTRACT(YEAR FROM d.fecha) AS anio, EXTRACT(MONTH FROM d.fecha) AS mes,
       COUNT(*) AS registros, SUM(d.cantidad) AS cantidad_desperdiciada
FROM Desperdicios d
GROUP BY EXTRACT(YEAR FROM d.fecha), EXTRACT(MONTH FROM d.fecha)
ORDER BY anio, mes;

-- O11. Como empleado quiero consultar los ingredientes del dia
-- para tener claro que platos podre preparar o cuales ofrecer al cliente.
-- Son los ingredientes con existencias y que no estan vencidos.
SELECT i.nombre AS ingrediente, inv.cantidad_disponible, i.unidad_medida, i.Fecha_vencimiento
FROM Ingredientes i
JOIN Inventarios inv ON inv.id_ingrediente = i.id_ingrediente
WHERE inv.cantidad_disponible > 0
  AND (i.Fecha_vencimiento IS NULL OR i.Fecha_vencimiento >= CURRENT_DATE)
ORDER BY i.nombre;

-- O12. Como empleado quiero consultar el inventario
-- para saber que tengo que pedir a los proveedores y seguir vendiendo los platos que me pidan.
SELECT i.nombre AS ingrediente, inv.cantidad_disponible, i.unidad_medida, i.stock_minimo
FROM Inventarios inv
JOIN Ingredientes i ON i.id_ingrediente = inv.id_ingrediente
WHERE inv.cantidad_disponible <= i.stock_minimo
ORDER BY inv.cantidad_disponible;

-- O13. Como empleado quiero consultar los platos devueltos
-- para entender sus devoluciones y reducir los desperdicios por devolucion de platos.
-- Es el desperdicio cuya causa es la devolucion del cliente.
SELECT d.fecha, i.nombre AS ingrediente, d.cantidad, e.nombre AS registrado_por
FROM Desperdicios d
JOIN Causas_desperdicio c ON c.id_causa = d.id_causa
JOIN Ingredientes i ON i.id_ingrediente = d.id_ingrediente
JOIN Empleados e ON e.id_empleado = d.id_empleado
WHERE c.descripcion = 'Devolución del cliente'
ORDER BY d.fecha;

-- O14. Como empleado quiero consultar los desperdicios del dia
-- para observar en que platos hay mayor desperdicio y reducirlo.
-- Cambie la fecha para consultar otro dia (CURRENT_DATE para hoy).
SELECT d.fecha, i.nombre AS ingrediente, c.descripcion AS causa, d.cantidad
FROM Desperdicios d
JOIN Ingredientes i ON i.id_ingrediente = d.id_ingrediente
JOIN Causas_desperdicio c ON c.id_causa = d.id_causa
WHERE d.fecha = '2026-10-03'
ORDER BY d.cantidad DESC;

-- O15. Como cliente quiero consultar los platos de comida
-- para ordenar mi comida de mi mayor agrado.
SELECT m.nombre AS menu, p.nombre AS plato, mp.precio, p.tiempo_preparacion
FROM Menus m
JOIN Menus_platos mp ON mp.id_menu = m.id_menu
JOIN Platos p ON p.id_plato = mp.id_plato
WHERE m.activo = TRUE AND mp.disponible = TRUE
ORDER BY p.nombre;

-- O16. Como cliente quiero consultar las recetas
-- para decidir que comer.
SELECT r.Nombre AS receta, r.Descripcion, r.tiempo_preparacion,
       i.nombre AS ingrediente, ri.cantidad, i.unidad_medida
FROM Recetas r
JOIN Recetas_ingredientes ri ON ri.id_receta = r.id_receta
JOIN Ingredientes i ON i.id_ingrediente = ri.id_ingrediente
ORDER BY r.Nombre, i.nombre;

-- O17. Como cliente quiero consultar la disponibilidad de platos e ingredientes
-- para ordenar mi comida con los ingredientes de mayor disponibilidad.
-- margen_minimo es lo que sobra del ingrediente mas justo para una porcion:
-- si es negativo el plato no esta disponible porque falta ese ingrediente.
SELECT p.nombre AS plato, COUNT(*) AS ingredientes,
       MIN(inv.cantidad_disponible - ri.cantidad) AS margen_minimo
FROM Platos p
JOIN Recetas_ingredientes ri ON ri.id_receta = p.id_receta
JOIN Inventarios inv ON inv.id_ingrediente = ri.id_ingrediente
GROUP BY p.nombre
ORDER BY margen_minimo, p.nombre;
