-- ConsultasGerenciales

-- G1. Como administrador quiero consultar el desperdicio de comida por turno
-- para identificar en que turnos se desperdicia mas y reforzar el control ahi.
-- El turno solo existe en Meseros: cuenta los desperdicios registrados por meseros.
SELECT m.turno, COUNT(*) AS registros, SUM(d.cantidad) AS cantidad_desperdiciada
FROM Desperdicios d
JOIN Meseros m ON m.id_empleado = d.id_empleado
GROUP BY m.turno
ORDER BY cantidad_desperdiciada DESC;

-- G2. Como administrador quiero consultar la lista de ingredientes mas desperdiciados
-- para decidir que ingredientes comprar en menor cantidad o cuidar mejor.
SELECT i.nombre AS ingrediente, i.unidad_medida, SUM(d.cantidad) AS cantidad_desperdiciada
FROM Desperdicios d
JOIN Ingredientes i ON i.id_ingrediente = d.id_ingrediente
GROUP BY i.nombre, i.unidad_medida
ORDER BY cantidad_desperdiciada DESC;

-- G3. Como administrador quiero consultar el desperdicio de ingredientes segun el proveedor que los entrego
-- para evaluar que proveedores entregan ingredientes que se desperdician mas.
-- Si un ingrediente lo han entregado varios proveedores, se cuenta para cada uno.
SELECT p.nombre AS proveedor, SUM(d.cantidad) AS cantidad_desperdiciada
FROM Desperdicios d
JOIN Detalles_compra dc ON dc.id_ingrediente = d.id_ingrediente
JOIN Compras c ON c.id_compra = dc.id_compra
JOIN Proveedores p ON p.id_proveedor = c.id_proveedor
GROUP BY p.nombre
ORDER BY cantidad_desperdiciada DESC;

-- G4. Como gerente quiero consultar el desperdicio de comida en un rango de fechas
-- para comparar periodos y ver si las medidas para reducir el desperdicio funcionan.
-- Cambie las fechas del BETWEEN para comparar otro periodo.
SELECT d.fecha AS dia, SUM(d.cantidad) AS cantidad_desperdiciada
FROM Desperdicios d
WHERE d.fecha BETWEEN '2026-09-23' AND '2026-10-08'
GROUP BY d.fecha
ORDER BY d.fecha;

-- G5. Como gerente quiero consultar el desperdicio por causa y por area de trabajo
-- para saber en que area y por que causa se desperdicia mas y asignar responsables.
-- El area es Cocina (el empleado es cocinero) o Salon (el empleado es mesero).
SELECT 'Cocina' AS area, c.descripcion AS causa, SUM(d.cantidad) AS cantidad_desperdiciada
FROM Desperdicios d
JOIN Cocineros co ON co.id_empleado = d.id_empleado
JOIN Causas_desperdicio c ON c.id_causa = d.id_causa
GROUP BY c.descripcion
UNION ALL
SELECT 'Salon', c.descripcion, SUM(d.cantidad)
FROM Desperdicios d
JOIN Meseros me ON me.id_empleado = d.id_empleado
JOIN Causas_desperdicio c ON c.id_causa = d.id_causa
GROUP BY c.descripcion
ORDER BY 1, 3 DESC;

-- G6. Como gerente quiero consultar el gasto mensual de cada ingrediente, sumando ventas y desperdicio
-- para saber cuanto consume el restaurante de cada ingrediente y planear las compras.
-- Ventas: cantidad por porcion de la receta x platos vendidos. Desperdicio: cantidad desperdiciada.
SELECT g.anio, g.mes, i.nombre AS ingrediente, i.unidad_medida, SUM(g.cantidad) AS gasto_total
FROM (
    SELECT EXTRACT(YEAR FROM v.fecha_venta) AS anio, EXTRACT(MONTH FROM v.fecha_venta) AS mes,
           ri.id_ingrediente, ri.cantidad * dv.cantidad AS cantidad
    FROM Detalles_venta dv
    JOIN Ventas v ON v.id_venta = dv.id_venta
    JOIN Platos p ON p.id_plato = dv.id_plato
    JOIN Recetas_ingredientes ri ON ri.id_receta = p.id_receta
    UNION ALL
    SELECT EXTRACT(YEAR FROM d.fecha), EXTRACT(MONTH FROM d.fecha), d.id_ingrediente, d.cantidad
    FROM Desperdicios d
) g
JOIN Ingredientes i ON i.id_ingrediente = g.id_ingrediente
GROUP BY g.anio, g.mes, i.nombre, i.unidad_medida
ORDER BY g.anio, g.mes, gasto_total DESC;

-- G7. Como gerente quiero consultar cuantos dias alcanza cada ingrediente segun su gasto promedio de los ultimos 3 meses
-- para pedir a tiempo y evitar quedarme sin ingredientes.
-- Dias que alcanza = cantidad disponible / (gasto de los ultimos 3 meses / 90 dias).
-- Los 3 meses terminan en la ultima venta registrada
SELECT i.nombre AS ingrediente, inv.cantidad_disponible,ROUND(SUM(g.cantidad) / 90, 2) AS gasto_promedio_diario,
ROUND(inv.cantidad_disponible / (SUM(g.cantidad) / 90), 1) AS dias_que_alcanza
FROM (
    SELECT v.fecha_venta AS fecha, ri.id_ingrediente, ri.cantidad * dv.cantidad AS cantidad
    FROM Detalles_venta dv
    JOIN Ventas v ON v.id_venta = dv.id_venta
    JOIN Platos p ON p.id_plato = dv.id_plato
    JOIN Recetas_ingredientes ri ON ri.id_receta = p.id_receta
    UNION ALL
    SELECT d.fecha, d.id_ingrediente, d.cantidad
    FROM Desperdicios d
) g
JOIN Ingredientes i ON i.id_ingrediente = g.id_ingrediente
JOIN Inventarios inv ON inv.id_ingrediente = i.id_ingrediente
WHERE g.fecha >= (SELECT MAX(fecha_venta) FROM Ventas) - INTERVAL '3 months'
GROUP BY i.nombre, inv.cantidad_disponible
ORDER BY dias_que_alcanza;

-- G8. Como gerente quiero consultar el total vendido por cada mesero en un periodo
-- para evaluar el desempeno del personal de salon y su aporte a las ventas.
-- Cambie las fechas del BETWEEN para consultar otro periodo.
SELECT e.nombre AS mesero, me.turno, COUNT(*) AS cuentas, SUM(v.total) AS total_vendido
FROM Ventas v
JOIN Meseros me ON me.id_empleado = v.id_mesero
JOIN Empleados e ON e.id_empleado = me.id_empleado
WHERE v.fecha_venta BETWEEN '2026-09-01' AND '2026-10-31'
GROUP BY e.nombre, me.turno
ORDER BY total_vendido DESC;

-- G9. Como gerente quiero consultar las perdidas economicas por el desperdicio de comida
-- para saber cuanto dinero se pierde y tomar decisiones para reducirlo.
-- Perdida = cantidad desperdiciada * costo unitario del ingrediente.
SELECT i.nombre AS ingrediente, SUM(d.cantidad) AS cantidad_desperdiciada,
       i.costo_unitario, SUM(d.cantidad * i.costo_unitario) AS perdida_economica
FROM Desperdicios d
JOIN Ingredientes i ON i.id_ingrediente = d.id_ingrediente
GROUP BY i.nombre, i.costo_unitario
ORDER BY perdida_economica DESC;

-- G10. Como administrador quiero consultar el desperdicio de comida por cada causa
-- para saber que causas generan mas desperdicio y poder corregirlas.
SELECT c.descripcion AS causa, COUNT(*) AS registros, SUM(d.cantidad) AS cantidad_desperdiciada
FROM Desperdicios d
JOIN Causas_desperdicio c ON c.id_causa = d.id_causa
GROUP BY c.descripcion
ORDER BY cantidad_desperdiciada DESC;
