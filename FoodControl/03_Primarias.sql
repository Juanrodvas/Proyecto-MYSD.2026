-- Primarias
ALTER TABLE Proveedores
ADD CONSTRAINT pk_proveedores PRIMARY KEY (id_proveedor);

ALTER TABLE Empleados
ADD CONSTRAINT pk_empleados PRIMARY KEY (id_empleado);

ALTER TABLE Causas_desperdicio
ADD CONSTRAINT pk_causas_desperdicio PRIMARY KEY (id_causa);

ALTER TABLE Ingredientes
ADD CONSTRAINT pk_ingredientes PRIMARY KEY (id_ingrediente);

ALTER TABLE Recetas
ADD CONSTRAINT pk_recetas PRIMARY KEY (id_receta);

ALTER TABLE Cocineros
ADD CONSTRAINT pk_cocineros PRIMARY KEY (id_empleado);

ALTER TABLE Meseros
ADD CONSTRAINT pk_meseros PRIMARY KEY (id_empleado);

ALTER TABLE Inventarios
ADD CONSTRAINT pk_inventarios PRIMARY KEY (id_ingrediente);

ALTER TABLE Movimientos_inventario
ADD CONSTRAINT pk_movimientos_inventario PRIMARY KEY (id_movimiento);

ALTER TABLE Compras
ADD CONSTRAINT pk_compras PRIMARY KEY (id_compra);

ALTER TABLE Detalles_compra
ADD CONSTRAINT pk_detalles_compra PRIMARY KEY (id_detalle);

ALTER TABLE Platos
ADD CONSTRAINT pk_platos PRIMARY KEY (id_plato);

ALTER TABLE Ventas
ADD CONSTRAINT pk_ventas PRIMARY KEY (id_venta);

ALTER TABLE Detalles_venta
ADD CONSTRAINT pk_detalles_venta PRIMARY KEY (id_detalle_venta);

ALTER TABLE Desperdicios
ADD CONSTRAINT pk_desperdicios PRIMARY KEY (id_desperdicio);

ALTER TABLE Recetas_ingredientes
ADD CONSTRAINT pk_recetas_ingredientes PRIMARY KEY (id_receta, id_ingrediente);

ALTER TABLE Menus
ADD CONSTRAINT pk_menus PRIMARY KEY (id_menu);

ALTER TABLE Menus_platos
ADD CONSTRAINT pk_menus_platos PRIMARY KEY (id_menu, id_plato);
