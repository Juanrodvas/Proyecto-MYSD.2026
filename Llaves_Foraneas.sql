--llaves Foreaneas--
ALTER TABLE Cocineros
ADD CONSTRAINT fk_cocinero_empleado
FOREIGN KEY (id_empleado) REFERENCES Empleados(id_empleado)
ON DELETE CASCADE;

ALTER TABLE Meseros
ADD CONSTRAINT fk_mesero_empleado
FOREIGN KEY (id_empleado) REFERENCES Empleados(id_empleado)
ON DELETE CASCADE;

ALTER TABLE Inventarios
ADD CONSTRAINT fk_inventario_ingrediente
FOREIGN KEY (id_ingrediente) REFERENCES Ingredientes(id_ingrediente)
ON DELETE CASCADE;

ALTER TABLE Movimientos_inventario
ADD CONSTRAINT fk_movimiento_inventario
FOREIGN KEY (id_ingrediente) REFERENCES Inventarios(id_ingrediente);

ALTER TABLE Compras
ADD CONSTRAINT fk_compra_proveedor
FOREIGN KEY (id_proveedor) REFERENCES Proveedores(id_provedor);

ALTER TABLE Detalles_compra
ADD CONSTRAINT fk_detalle_compra
FOREIGN KEY (id_compra) REFERENCES Compras(id_compra);

ALTER TABLE Detalles_compra
ADD CONSTRAINT fk_detalle_ingrediente
FOREIGN KEY (id_ingrediente) REFERENCES Ingredientes(id_ingrediente);

ALTER TABLE Platos
ADD CONSTRAINT fk_plato_receta
FOREIGN KEY (id_receta) REFERENCES Recetas(id_receta);

ALTER TABLE Ventas
ADD CONSTRAINT fk_venta_plato
FOREIGN KEY (id_plato) REFERENCES Platos(id_plato);


ALTER TABLE Desperdicios
ADD CONSTRAINT fk_desperdicio_ingrediente
FOREIGN KEY (id_ingrediente) REFERENCES Ingredientes(id_ingrediente);

ALTER TABLE Desperdicios
ADD CONSTRAINT fk_desperdicio_empleado
FOREIGN KEY (id_empleado) REFERENCES Empleados(id_empleado);

ALTER TABLE Desperdicios
ADD CONSTRAINT fk_desperdicio_causa
FOREIGN KEY (id_causa) REFERENCES Causas_desperdicio