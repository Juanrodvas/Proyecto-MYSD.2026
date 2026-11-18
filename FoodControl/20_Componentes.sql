-- Componentes
-- Servicios del diseño físico (diagrama Componentes del Astah).
-- Las reglas que ya protegen las restricciones y los disparadores no se repiten aquí.

-- SV_ENTRADAS: compras de ingredientes
CREATE SCHEMA sv_entradas;

-- Registrar una compra (todavía sin recibir)
CREATE FUNCTION sv_entradas.adicionarCompra(p_fecha DATE, p_id_proveedor INT)
RETURNS VOID AS $$
BEGIN
    INSERT INTO Compras (Fecha_compra, id_proveedor)
    VALUES (p_fecha, p_id_proveedor);
END;
$$ LANGUAGE plpgsql;

-- Agregar un ingrediente a la compra
CREATE FUNCTION sv_entradas.adicionarDetalle(p_id_compra INT, p_id_ingrediente INT, p_cantidad DECIMAL, p_total DECIMAL)
RETURNS VOID AS $$
BEGIN
    INSERT INTO Detalles_compra (cantidad, Total, id_compra, id_ingrediente)
    VALUES (p_cantidad, p_total, p_id_compra, p_id_ingrediente);
END;
$$ LANGUAGE plpgsql;

-- Registrar la recepción: el disparador 2 suma al inventario y registra las entradas
CREATE FUNCTION sv_entradas.modificarRecepcion(p_id_compra INT, p_fecha_recepcion DATE)
RETURNS VOID AS $$
BEGIN
    UPDATE Compras
    SET Fecha_recepcion = p_fecha_recepcion
    WHERE id_compra = p_id_compra;
END;
$$ LANGUAGE plpgsql;

-- Consultar una compra con su proveedor y sus ingredientes
CREATE FUNCTION sv_entradas.consultarCompra(p_id_compra INT)
RETURNS REFCURSOR AS $$
DECLARE
    v_cursor REFCURSOR := 'compra_cursor';
BEGIN
    OPEN v_cursor FOR
        SELECT c.id_compra, c.Fecha_compra, c.Fecha_recepcion, p.nombre AS proveedor, i.nombre AS ingrediente, d.cantidad, d.Total
        FROM Compras c
        JOIN Proveedores p ON p.id_proveedor = c.id_proveedor
        JOIN Detalles_compra d ON d.id_compra = c.id_compra
        JOIN Ingredientes i ON i.id_ingrediente = d.id_ingrediente
        WHERE c.id_compra = p_id_compra
        ORDER BY i.nombre;
    RETURN v_cursor;
END;
$$ LANGUAGE plpgsql;

-- Eliminar una compra con sus detalles; si ya se recibió, sus movimientos de inventario lo impiden
CREATE FUNCTION sv_entradas.eliminarCompra(p_id_compra INT)
RETURNS VOID AS $$
BEGIN
    DELETE FROM Detalles_compra WHERE id_compra = p_id_compra;
    DELETE FROM Compras WHERE id_compra = p_id_compra;
END;
$$ LANGUAGE plpgsql;

-- SV_DESPERDICIOS: desperdicios y movimientos de inventario
CREATE SCHEMA sv_desperdicios;

-- Registrar un desperdicio: el disparador 7 registra la salida y el 3 revisa que alcance el inventario
CREATE FUNCTION sv_desperdicios.adicionarDesperdicio(p_fecha DATE, p_cantidad DECIMAL, p_id_ingrediente INT, p_id_empleado INT, p_id_causa INT)
RETURNS VOID AS $$
BEGIN
    INSERT INTO Desperdicios (fecha, cantidad, id_ingrediente, id_empleado, id_causa)
    VALUES (p_fecha, p_cantidad, p_id_ingrediente, p_id_empleado, p_id_causa);
END;
$$ LANGUAGE plpgsql;

-- Cambiar la causa de un desperdicio
CREATE FUNCTION sv_desperdicios.modificarCausa(p_id_desperdicio INT, p_id_causa INT)
RETURNS VOID AS $$
BEGIN
    UPDATE Desperdicios
    SET id_causa = p_id_causa
    WHERE id_desperdicio = p_id_desperdicio;
END;
$$ LANGUAGE plpgsql;

-- Consultar un desperdicio con su ingrediente, causa y empleado
CREATE FUNCTION sv_desperdicios.consultarDesperdicio(p_id_desperdicio INT)
RETURNS REFCURSOR AS $$
DECLARE
    v_cursor REFCURSOR := 'desperdicio_cursor';
BEGIN
    OPEN v_cursor FOR
        SELECT d.id_desperdicio, d.fecha, d.cantidad, i.nombre AS ingrediente,
               c.descripcion AS causa, e.nombre AS empleado
        FROM Desperdicios d
        JOIN Ingredientes i ON i.id_ingrediente = d.id_ingrediente
        JOIN Causas_desperdicio c ON c.id_causa = d.id_causa
        JOIN Empleados e ON e.id_empleado = d.id_empleado
        WHERE d.id_desperdicio = p_id_desperdicio;
    RETURN v_cursor;
END;
$$ LANGUAGE plpgsql;

-- Consultar los movimientos de inventario de un ingrediente
CREATE FUNCTION sv_desperdicios.consultarMovimientos(p_id_ingrediente INT)
RETURNS REFCURSOR AS $$
DECLARE
    v_cursor REFCURSOR := 'movimientos_cursor';
BEGIN
    OPEN v_cursor FOR
        SELECT m.id_movimiento, m.fecha, m.tipo_movimiento, m.cantidad, m.origen
        FROM Movimientos_inventario m
        WHERE m.id_ingrediente = p_id_ingrediente
        ORDER BY m.id_movimiento;
    RETURN v_cursor;
END;
$$ LANGUAGE plpgsql;

-- Eliminar un desperdicio: devuelve al inventario lo que había salido y borra su movimiento
CREATE FUNCTION sv_desperdicios.eliminarDesperdicio(p_id_desperdicio INT)
RETURNS VOID AS $$
BEGIN
    UPDATE Inventarios
    SET cantidad_disponible = cantidad_disponible + COALESCE((SELECT SUM(m.cantidad)
                                                              FROM Movimientos_inventario m
                                                              WHERE m.id_desperdicio = p_id_desperdicio), 0)
    WHERE id_ingrediente = (SELECT id_ingrediente FROM Desperdicios WHERE id_desperdicio = p_id_desperdicio);

    DELETE FROM Movimientos_inventario WHERE id_desperdicio = p_id_desperdicio;
    DELETE FROM Desperdicios WHERE id_desperdicio = p_id_desperdicio;
END;
$$ LANGUAGE plpgsql;
