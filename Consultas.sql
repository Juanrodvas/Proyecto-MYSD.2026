-- 1. Consultar compras realizadas
SELECT
    c.id_compra,
    c.Fecha_compra,
    c.Fecha_recepcion,
    p.nombre        AS proveedor,
    dc.id_ingrediente,
    dc.cantidad,
    dc.Total
FROM Compras c
JOIN Proveedores p        ON c.id_proveedor = p.id_provedor
JOIN Detalles_compra dc   ON dc.id_compra = c.id_compra
ORDER BY c.Fecha_compra DESC;

-- 2. Consultar proveedores
SELECT
    id_provedor,
    nombre,
    telefono,
    correo
FROM Proveedores;

-- 3. Consultar inventario
SELECT
    ing.id_ingrediente,
    ing.Fecha_vencimiento,
    inv.cantidad
FROM Ingredientes ing
JOIN Inventarios inv ON inv.id_ingrediente = ing.id_ingrediente;

-- 4. Consultar movimientos de inventario
SELECT
    m.id_movimiento,
    m.fecha,
    m.tipo_movimiento,
    m.id_ingrediente
FROM Movimientos_inventario m
ORDER BY m.fecha DESC;

-- 5. Consultar desperdicios (vista general del administrador)
SELECT
    d.id_desperdicio,
    d.fecha,
    d.ingredientes_desperdiciados,
    e.nombre        AS empleado,
    ca.descripcion  AS causa
FROM Desperdicios d
JOIN Empleados e          ON e.id_empleado = d.id_empleado
JOIN Causas_desperdicio ca ON ca.id_causa = d.id_causa
ORDER BY d.fecha DESC;

-- 6. Consultar ventas realizadas
SELECT
    v.id_venta,
    v.fecha_venta,
    v.precio,
    pl.nombre AS plato
FROM Ventas v
JOIN Platos pl ON pl.id_plato = v.id_plato
ORDER BY v.fecha_venta DESC;

-- 7. Consultar platos más vendidos
SELECT
    pl.id_plato,
    pl.nombre,
    COUNT(v.id_venta)   AS veces_vendido,
    SUM(v.precio)        AS ingresos_generados
FROM Ventas v
JOIN Platos pl ON pl.id_plato = v.id_plato
GROUP BY pl.id_plato, pl.nombre
ORDER BY veces_vendido DESC;

-- 8. Consultar ingredientes disponibles (cantidad > 0)
SELECT
    ing.id_ingrediente,
    ing.Fecha_vencimiento,
    inv.cantidad
FROM Ingredientes ing
JOIN Inventarios inv ON inv.id_ingrediente = ing.id_ingrediente
WHERE inv.cantidad > 0;

-- 9. Consultar desperdicios del día (fecha actual)
SELECT
    d.id_desperdicio,
    d.fecha,
    d.ingredientes_desperdiciados,
    e.nombre       AS empleado,
    ca.descripcion AS causa
FROM Desperdicios d
JOIN Empleados e           ON e.id_empleado = d.id_empleado
JOIN Causas_desperdicio ca ON ca.id_causa = d.id_causa
WHERE d.fecha = CURDATE();

-- 10. Consultar inventario disponible
SELECT
    id_ingrediente,
    cantidad
FROM Inventarios
WHERE cantidad > 0;

SELECT
    pl.id_plato,
    pl.nombre,
    pl.tiempo_preparacion
FROM Platos pl;

-- 13. Consultar recetas o platos
SELECT
    pl.id_plato,
    pl.nombre             AS plato,
    r.Nombre               AS receta,
    r.Descripcion,
    r.tiempo_preparacion,
    r.ingredientes
FROM Platos pl
JOIN Recetas r ON r.id_receta = pl.id_receta;

SELECT
    pl.id_plato,
    pl.nombre         AS plato,
    r.Nombre           AS receta,
    ing.id_ingrediente,
    inv.cantidad
FROM Platos pl
JOIN Recetas r          ON r.id_receta = pl.id_receta
CROSS JOIN Ingredientes ing
JOIN Inventarios inv    ON inv.id_ingrediente = ing.id_ingrediente
WHERE inv.cantidad > 0;