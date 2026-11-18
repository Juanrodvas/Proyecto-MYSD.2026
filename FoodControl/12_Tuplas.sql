-- Tuplas
ALTER TABLE Proveedores
ADD CONSTRAINT ck_proveedor_contacto
CHECK (telefono IS NOT NULL OR correo IS NOT NULL);

ALTER TABLE Compras
ADD CONSTRAINT ck_compra_fechas
CHECK (Fecha_recepcion IS NULL OR Fecha_recepcion >= Fecha_compra);

ALTER TABLE Menus
ADD CONSTRAINT ck_menu_fechas
CHECK (fecha_fin IS NULL OR fecha_fin >= fecha_inicio);

-- Un movimiento viene como mucho de una cosa (compra, venta o desperdicio) y debe coincidir con su origen
ALTER TABLE Movimientos_inventario
ADD CONSTRAINT ck_movimiento_trazabilidad
CHECK (
    (id_detalle_compra IS NULL OR (id_detalle_venta IS NULL AND id_desperdicio IS NULL AND origen = 'Compra'))
    AND (id_detalle_venta IS NULL OR (id_desperdicio IS NULL AND origen = 'Venta'))
    AND (id_desperdicio IS NULL OR origen = 'Desperdicio')
);

-- Una entrada solo puede venir de una compra; una salida, de una venta o de un desperdicio
ALTER TABLE Movimientos_inventario
ADD CONSTRAINT ck_movimiento_tipo_origen
CHECK (
    (tipo_movimiento = 'Entrada' AND origen = 'Compra')
    OR (tipo_movimiento = 'Salida' AND origen IN ('Venta', 'Desperdicio'))
);
