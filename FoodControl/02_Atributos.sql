-- Atributos
-- Teléfono de exactamente 10 dígitos
ALTER TABLE Proveedores
ADD CONSTRAINT ck_proveedor_telefono CHECK (telefono BETWEEN 1000000000 AND 9999999999);

-- Correo con texto antes de la @, y un punto con texto después (sin espacios)
ALTER TABLE Proveedores
ADD CONSTRAINT ck_proveedor_correo CHECK (correo LIKE '%_@_%._%');

ALTER TABLE Empleados
ADD CONSTRAINT ck_empleado_salario CHECK (salario > 0);

ALTER TABLE Recetas
ADD CONSTRAINT ck_receta_tiempo CHECK (tiempo_preparacion > 0);

ALTER TABLE Meseros
ADD CONSTRAINT ck_mesero_turno CHECK (turno IN ('Mañana', 'Tarde', 'Noche'));

ALTER TABLE Inventarios
ADD CONSTRAINT ck_inventario_cantidad CHECK (cantidad_disponible >= 0);

ALTER TABLE Movimientos_inventario
ADD CONSTRAINT ck_movimiento_tipo CHECK (tipo_movimiento IN ('Entrada', 'Salida'));

ALTER TABLE Movimientos_inventario
ADD CONSTRAINT ck_movimiento_cantidad CHECK (cantidad > 0);

ALTER TABLE Movimientos_inventario
ADD CONSTRAINT ck_movimiento_origen CHECK (origen IN ('Compra', 'Venta', 'Desperdicio'));

ALTER TABLE Ingredientes
ADD CONSTRAINT ck_ingrediente_unidad CHECK (unidad_medida IN ('kg', 'g', 'L', 'unidad'));

ALTER TABLE Ingredientes
ADD CONSTRAINT ck_ingrediente_stock_minimo CHECK (stock_minimo >= 0);

ALTER TABLE Ingredientes
ADD CONSTRAINT ck_ingrediente_costo CHECK (costo_unitario >= 0);

ALTER TABLE Recetas_ingredientes
ADD CONSTRAINT ck_receta_ingrediente_cantidad CHECK (cantidad > 0);

ALTER TABLE Desperdicios
ADD CONSTRAINT ck_desperdicio_cantidad CHECK (cantidad > 0);

ALTER TABLE Ventas
ADD CONSTRAINT ck_venta_total CHECK (total >= 0);

ALTER TABLE Detalles_venta
ADD CONSTRAINT ck_detalle_venta_cantidad CHECK (cantidad > 0);

ALTER TABLE Detalles_venta
ADD CONSTRAINT ck_detalle_venta_precio CHECK (precio_unitario > 0);

ALTER TABLE Menus_platos
ADD CONSTRAINT ck_menu_plato_precio CHECK (precio > 0);

ALTER TABLE Detalles_compra
ADD CONSTRAINT ck_detalle_cantidad CHECK (cantidad > 0);

ALTER TABLE Detalles_compra
ADD CONSTRAINT ck_detalle_total CHECK (Total > 0);

ALTER TABLE Platos
ADD CONSTRAINT ck_plato_tiempo CHECK (tiempo_preparacion > 0);
