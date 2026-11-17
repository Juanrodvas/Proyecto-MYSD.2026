-- Unicas
ALTER TABLE Proveedores
ADD CONSTRAINT uq_proveedor_correo UNIQUE (correo);

ALTER TABLE Platos
ADD CONSTRAINT uq_plato_nombre UNIQUE (nombre);

ALTER TABLE Recetas
ADD CONSTRAINT uq_receta_nombre UNIQUE (Nombre);

ALTER TABLE Ingredientes
ADD CONSTRAINT uq_ingrediente_nombre UNIQUE (nombre);

ALTER TABLE Menus
ADD CONSTRAINT uq_menu_nombre UNIQUE (nombre);

ALTER TABLE Proveedores
ADD CONSTRAINT uq_proveedor_telefono UNIQUE (telefono);

-- Una sola línea por ingrediente en cada compra, y por plato en cada venta
ALTER TABLE Detalles_compra
ADD CONSTRAINT uq_detalle_compra_ingrediente UNIQUE (id_compra, id_ingrediente);

ALTER TABLE Detalles_venta
ADD CONSTRAINT uq_detalle_venta_plato UNIQUE (id_venta, id_plato);
