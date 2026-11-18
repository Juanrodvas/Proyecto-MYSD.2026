-- Disparadores
---Disparador 1: un cocinero no puede ser mesero
CREATE OR REPLACE FUNCTION f_cocinero_no_mesero() RETURNS TRIGGER AS $$
DECLARE
    v_cantidad INT;
BEGIN
    SELECT COUNT(*) INTO v_cantidad
    FROM Meseros
    WHERE id_empleado = NEW.id_empleado;

    IF v_cantidad > 0 THEN
        RAISE EXCEPTION 'El empleado % ya es mesero y no puede ser cocinero', NEW.id_empleado;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER t_cocinero_no_mesero
BEFORE INSERT OR UPDATE ON Cocineros
FOR EACH ROW EXECUTE FUNCTION f_cocinero_no_mesero();

---Disparador 2: al recibir una compra, sumar al inventario y registrar la entrada
CREATE OR REPLACE FUNCTION f_recibir_compra() RETURNS TRIGGER AS $$
BEGIN
    IF OLD.Fecha_recepcion IS NULL AND NEW.Fecha_recepcion IS NOT NULL THEN

        UPDATE Inventarios
        SET cantidad_disponible = cantidad_disponible + (SELECT SUM(d.cantidad)
                                                         FROM Detalles_compra d
                                                         WHERE d.id_compra = NEW.id_compra
                                                           AND d.id_ingrediente = Inventarios.id_ingrediente)
        WHERE id_ingrediente IN (SELECT id_ingrediente
                                 FROM Detalles_compra
                                 WHERE id_compra = NEW.id_compra);

-- un movimiento por cada detalle de la compra, enlazado a él
        INSERT INTO Movimientos_inventario (fecha, tipo_movimiento, cantidad, id_ingrediente, origen, id_detalle_compra)
        SELECT NEW.Fecha_recepcion, 'Entrada', cantidad, id_ingrediente, 'Compra', id_detalle
        FROM Detalles_compra
        WHERE id_compra = NEW.id_compra;

    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER t_recibir_compra
AFTER UPDATE ON Compras
FOR EACH ROW EXECUTE FUNCTION f_recibir_compra();

---Disparador 3: no sacar más de lo que hay en el inventario
CREATE OR REPLACE FUNCTION f_salida_con_inventario() RETURNS TRIGGER AS $$
DECLARE
    v_cantidad DECIMAL(10,2);
BEGIN
    IF NEW.tipo_movimiento = 'Salida' THEN
        SELECT cantidad_disponible INTO v_cantidad
        FROM Inventarios
        WHERE id_ingrediente = NEW.id_ingrediente;

        IF v_cantidad < NEW.cantidad THEN
            RAISE EXCEPTION 'El ingrediente % solo tiene % unidades y no alcanza para una salida de %',
                NEW.id_ingrediente, v_cantidad, NEW.cantidad;
        END IF;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER t_salida_con_inventario
BEFORE INSERT ON Movimientos_inventario
FOR EACH ROW EXECUTE FUNCTION f_salida_con_inventario();

---Disparador 4: un mesero no puede ser cocinero
CREATE OR REPLACE FUNCTION f_mesero_no_cocinero() RETURNS TRIGGER AS $$
DECLARE
    v_cantidad INT;
BEGIN
    SELECT COUNT(*) INTO v_cantidad
    FROM Cocineros
    WHERE id_empleado = NEW.id_empleado;

    IF v_cantidad > 0 THEN
        RAISE EXCEPTION 'El empleado % ya es cocinero y no puede ser mesero', NEW.id_empleado;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER t_mesero_no_cocinero
BEFORE INSERT OR UPDATE ON Meseros
FOR EACH ROW EXECUTE FUNCTION f_mesero_no_cocinero();

---Disparador 5: al registrar una salida, descontarla del inventario
CREATE OR REPLACE FUNCTION f_descontar_salida() RETURNS TRIGGER AS $$
BEGIN
    IF NEW.tipo_movimiento = 'Salida' THEN
        UPDATE Inventarios
        SET cantidad_disponible = cantidad_disponible - NEW.cantidad
        WHERE id_ingrediente = NEW.id_ingrediente;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER t_descontar_salida
AFTER INSERT ON Movimientos_inventario
FOR EACH ROW EXECUTE FUNCTION f_descontar_salida();

---Disparador 6: al vender un plato, registrar la salida de cada ingrediente de su receta
---(cantidad por porción x platos vendidos), a nombre del mesero y enlazada al detalle de venta.
---Los disparadores 3 y 5 validan y descuentan.
CREATE OR REPLACE FUNCTION f_venta_descontar_ingredientes() RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO Movimientos_inventario (fecha, tipo_movimiento, cantidad, id_ingrediente, origen, id_empleado, id_detalle_venta)
    SELECT v.fecha_venta, 'Salida', ri.cantidad * NEW.cantidad, ri.id_ingrediente, 'Venta', v.id_mesero, NEW.id_detalle_venta
    FROM Ventas v
    JOIN Platos p ON p.id_plato = NEW.id_plato
    JOIN Recetas_ingredientes ri ON ri.id_receta = p.id_receta
    WHERE v.id_venta = NEW.id_venta;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER t_venta_descontar_ingredientes
AFTER INSERT ON Detalles_venta
FOR EACH ROW EXECUTE FUNCTION f_venta_descontar_ingredientes();

---Disparador 7: al registrar un desperdicio, registrar su salida del inventario
CREATE OR REPLACE FUNCTION f_desperdicio_descontar() RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO Movimientos_inventario (fecha, tipo_movimiento, cantidad, id_ingrediente, origen, id_empleado, id_desperdicio)
    VALUES (NEW.fecha, 'Salida', NEW.cantidad, NEW.id_ingrediente, 'Desperdicio', NEW.id_empleado, NEW.id_desperdicio);

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER t_desperdicio_descontar
AFTER INSERT ON Desperdicios
FOR EACH ROW EXECUTE FUNCTION f_desperdicio_descontar();

---Disparador 8: al agregar un plato a una venta, sumar cantidad x precio al total de la venta
CREATE OR REPLACE FUNCTION f_detalle_venta_total() RETURNS TRIGGER AS $$
BEGIN
    UPDATE Ventas
    SET total = total + NEW.cantidad * NEW.precio_unitario
    WHERE id_venta = NEW.id_venta;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER t_detalle_venta_total
AFTER INSERT ON Detalles_venta
FOR EACH ROW EXECUTE FUNCTION f_detalle_venta_total();
