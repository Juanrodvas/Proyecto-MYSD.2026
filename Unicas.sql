ALTER TABLE Proveedores
ADD CONSTRAINT uq_proveedor_correo UNIQUE (correo);

ALTER TABLE Platos
ADD CONSTRAINT uq_plato_nombre UNIQUE (nombre);

ALTER TABLE Recetas
ADD CONSTRAINT uq_receta_nombre UNIQUE (Nombre);