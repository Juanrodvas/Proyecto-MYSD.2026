-- PoblarNoOK
-- INSERT INTO Proveedores (nombre, telefono, correo)
-- VALUES ('Otro Proveedor', 3001111111, 'contacto@lafresca.com');

-- INSERT INTO Platos (nombre, tiempo_preparacion, id_receta)
-- VALUES ('Bandeja Paisa', 50, 1);

-- INSERT INTO Platos (nombre, tiempo_preparacion, id_receta)
-- VALUES ('Plato sin receta', 30, NULL);

-- INSERT INTO Recetas (Nombre, tiempo_preparacion, Descripcion)
-- VALUES ('Ajiaco Santafereño', 55, 'Otra versión');

-- INSERT INTO Ingredientes (nombre, Fecha_vencimiento)
-- VALUES ('Arroz', '2027-03-01');

-- INSERT INTO Ingredientes (nombre, Fecha_vencimiento, unidad_medida, stock_minimo, costo_unitario)
-- VALUES ('Sal', '2027-01-01', 'kg', 1, -500.00);

-- INSERT INTO Compras (Fecha_compra, Fecha_recepcion, id_proveedor)
-- VALUES ('2026-09-26', NULL, 999);

-- INSERT INTO Detalles_venta (cantidad, precio_unitario, id_venta, id_plato)
-- VALUES (1, 20000.00, 1, 999);

-- INSERT INTO Ventas (fecha_venta, total, id_mesero)
-- VALUES ('2026-09-26', 0, 999);

-- INSERT INTO Ventas (fecha_venta, total, id_mesero)
-- VALUES ('2026-09-26', -5000.00, 2);

-- INSERT INTO Empleados (nombre, salario)
-- VALUES (NULL, 1500000.00);

-- INSERT INTO Proveedores (id_proveedor, nombre, telefono, correo)
-- VALUES (1, 'Duplicado', 3000000000, 'nuevo@correo.com');

-- INSERT INTO Empleados (nombre, salario)
-- VALUES ('Pedro Salas', 'mucho');

-- INSERT INTO Compras (Fecha_compra, Fecha_recepcion, id_proveedor)
-- VALUES ('no es fecha', NULL, 1);

-- INSERT INTO Causas_desperdicio (descripcion)
-- VALUES (REPEAT('x', 201));

-- INSERT INTO Empleados (nombre, salario)
-- VALUES ('Pedro Salas', -1500000.00);

-- INSERT INTO Proveedores (nombre, telefono, correo)
-- VALUES ('Proveedor Malo', 3005556677, 'correo-sin-arroba');

-- UPDATE Meseros SET turno = 'Madrugada' WHERE id_empleado = 2;

-- [ck_movimiento_tipo] tipo de movimiento que no existe
-- INSERT INTO Movimientos_inventario (fecha, tipo_movimiento, cantidad, id_ingrediente, origen)
-- VALUES ('2026-10-01', 'Traslado', 5, 1, 'Compra');

-- [ck_movimiento_cantidad] cantidad en cero
-- INSERT INTO Movimientos_inventario (fecha, tipo_movimiento, cantidad, id_ingrediente, origen)
-- VALUES ('2026-10-01', 'Entrada', 0, 1, 'Compra');

-- INSERT INTO Detalles_compra (cantidad, Total, id_compra, id_ingrediente)
-- VALUES (0, 50000.00, 1, 1);

-- INSERT INTO Detalles_venta (cantidad, precio_unitario, id_venta, id_plato)
-- VALUES (1, 0, 1, 1);

-- INSERT INTO Detalles_venta (cantidad, precio_unitario, id_venta, id_plato)
-- VALUES (0, 18000.00, 1, 1);

-- Movimiento registrado por un empleado que no existe
-- INSERT INTO Movimientos_inventario (fecha, tipo_movimiento, cantidad, id_ingrediente, origen, id_empleado)
-- VALUES ('2026-10-01', 'Entrada', 5, 1, 'Compra', 999);

-- INSERT INTO Recetas_ingredientes (id_receta, id_ingrediente, cantidad)
-- VALUES (1, 3, 0.10);

-- INSERT INTO Recetas_ingredientes (id_receta, id_ingrediente, cantidad)
-- VALUES (1, 2, 0);

-- INSERT INTO Ingredientes (nombre, Fecha_vencimiento, unidad_medida, stock_minimo)
-- VALUES ('Sal', '2027-01-01', 'libras', 1);

-- INSERT INTO Movimientos_inventario (fecha, tipo_movimiento, cantidad, id_ingrediente, origen)
-- VALUES ('2026-10-01', 'Entrada', 5, 1, 'Regalo');

-- INSERT INTO Menus_platos (id_menu, id_plato, precio, disponible)
-- VALUES (1, 1, 20000.00, TRUE);

-- PoblarNoOK: llaves primarias repetidas (cada una usa un id que ya existe)
-- [pk_empleados]
-- INSERT INTO Empleados (id_empleado, nombre, salario)
-- VALUES (1, 'Empleado repetido', 1500000.00);

-- [pk_causas_desperdicio]
-- INSERT INTO Causas_desperdicio (id_causa, descripcion)
-- VALUES (1, 'Causa repetida');

-- [pk_ingredientes]
-- INSERT INTO Ingredientes (id_ingrediente, nombre, Fecha_vencimiento, unidad_medida, stock_minimo, costo_unitario)
-- VALUES (1, 'Ingrediente nuevo', '2027-01-01', 'kg', 1, 100.00);

-- [pk_recetas]
-- INSERT INTO Recetas (id_receta, Nombre, tiempo_preparacion, Descripcion)
-- VALUES (1, 'Receta nueva', 30, 'Con id repetido');

-- [pk_cocineros]
-- INSERT INTO Cocineros (id_empleado, Especialidad)
-- VALUES (1, 'Cocinero repetido');

-- [pk_meseros]
-- INSERT INTO Meseros (id_empleado, turno)
-- VALUES (2, 'Noche');

-- [pk_inventarios]
-- INSERT INTO Inventarios (id_ingrediente, cantidad_disponible)
-- VALUES (1, 10);

-- [pk_movimientos_inventario]
-- INSERT INTO Movimientos_inventario (id_movimiento, fecha, tipo_movimiento, cantidad, id_ingrediente, origen)
-- VALUES (1, '2026-10-01', 'Entrada', 5, 1, 'Compra');

-- [pk_compras]
-- INSERT INTO Compras (id_compra, Fecha_compra, Fecha_recepcion, id_proveedor)
-- VALUES (1, '2026-10-01', NULL, 1);

-- [pk_detalles_compra]
-- INSERT INTO Detalles_compra (id_detalle, cantidad, Total, id_compra, id_ingrediente)
-- VALUES (1, 5, 40000.00, 1, 2);

-- [pk_platos]
-- INSERT INTO Platos (id_plato, nombre, tiempo_preparacion, id_receta)
-- VALUES (1, 'Plato nuevo', 30, 1);

-- [pk_ventas]
-- INSERT INTO Ventas (id_venta, fecha_venta, total, id_mesero)
-- VALUES (1, '2026-10-01', 0, 2);

-- [pk_detalles_venta]
-- INSERT INTO Detalles_venta (id_detalle_venta, cantidad, precio_unitario, id_venta, id_plato)
-- VALUES (1, 1, 18000.00, 1, 3);

-- [pk_desperdicios]
-- INSERT INTO Desperdicios (id_desperdicio, fecha, cantidad, id_ingrediente, id_empleado, id_causa)
-- VALUES (1, '2026-10-01', 1, 1, 1, 1);

-- [pk_menus]
-- INSERT INTO Menus (id_menu, nombre, fecha_inicio, fecha_fin, activo)
-- VALUES (1, 'Menu repetido', '2027-01-01', NULL, FALSE);

-- PoblarNoOK: llaves foráneas que apuntan a algo que no existe (el 999 no existe en ninguna tabla)
-- [fk_cocinero_empleado]
-- INSERT INTO Cocineros (id_empleado, Especialidad)
-- VALUES (999, 'Cocinero fantasma');

-- [fk_mesero_empleado]
-- INSERT INTO Meseros (id_empleado, turno)
-- VALUES (999, 'Noche');

-- [fk_inventario_ingrediente]
-- INSERT INTO Inventarios (id_ingrediente, cantidad_disponible)
-- VALUES (999, 10);

-- [fk_plato_receta]
-- INSERT INTO Platos (nombre, tiempo_preparacion, id_receta)
-- VALUES ('Plato con receta inexistente', 30, 999);

-- [fk_receta_ingrediente_receta]
-- INSERT INTO Recetas_ingredientes (id_receta, id_ingrediente, cantidad)
-- VALUES (999, 1, 0.10);

-- [fk_receta_ingrediente_ingrediente]
-- INSERT INTO Recetas_ingredientes (id_receta, id_ingrediente, cantidad)
-- VALUES (1, 999, 0.10);

-- [fk_menu_plato_menu]
-- INSERT INTO Menus_platos (id_menu, id_plato, precio, disponible)
-- VALUES (999, 1, 20000.00, TRUE);

-- [fk_menu_plato_plato]
-- INSERT INTO Menus_platos (id_menu, id_plato, precio, disponible)
-- VALUES (1, 999, 20000.00, TRUE);

-- [fk_detalle_compra]
-- INSERT INTO Detalles_compra (cantidad, Total, id_compra, id_ingrediente)
-- VALUES (5, 40000.00, 999, 1);

-- [fk_detalle_ingrediente]
-- INSERT INTO Detalles_compra (cantidad, Total, id_compra, id_ingrediente)
-- VALUES (5, 40000.00, 1, 999);

-- [fk_detalle_venta_venta]
-- INSERT INTO Detalles_venta (cantidad, precio_unitario, id_venta, id_plato)
-- VALUES (1, 18000.00, 999, 1);

-- [fk_desperdicio_ingrediente]
-- INSERT INTO Desperdicios (fecha, cantidad, id_ingrediente, id_empleado, id_causa)
-- VALUES ('2026-10-04', 1, 999, 1, 1);

-- [fk_desperdicio_empleado]
-- INSERT INTO Desperdicios (fecha, cantidad, id_ingrediente, id_empleado, id_causa)
-- VALUES ('2026-10-04', 1, 1, 999, 1);

-- [fk_desperdicio_causa]
-- INSERT INTO Desperdicios (fecha, cantidad, id_ingrediente, id_empleado, id_causa)
-- VALUES ('2026-10-04', 1, 1, 1, 999);

-- [fk_movimiento_inventario]
-- INSERT INTO Movimientos_inventario (fecha, tipo_movimiento, cantidad, id_ingrediente, origen)
-- VALUES ('2026-10-06', 'Entrada', 1, 999, 'Compra');

-- [fk_movimiento_detalle_compra]
-- INSERT INTO Movimientos_inventario (fecha, tipo_movimiento, cantidad, id_ingrediente, origen, id_detalle_compra)
-- VALUES ('2026-10-06', 'Entrada', 1, 1, 'Compra', 999);

-- [fk_movimiento_detalle_venta]
-- INSERT INTO Movimientos_inventario (fecha, tipo_movimiento, cantidad, id_ingrediente, origen, id_detalle_venta)
-- VALUES ('2026-10-06', 'Salida', 1, 1, 'Venta', 999);

-- [fk_movimiento_desperdicio]
-- INSERT INTO Movimientos_inventario (fecha, tipo_movimiento, cantidad, id_ingrediente, origen, id_desperdicio)
-- VALUES ('2026-10-06', 'Salida', 1, 1, 'Desperdicio', 999);

-- PoblarNoOK: única repetida
-- [uq_menu_nombre]
-- INSERT INTO Menus (nombre, fecha_inicio, fecha_fin, activo)
-- VALUES ('Carta principal', '2027-05-01', NULL, FALSE);

-- PoblarNoOK: valores fuera de rango (CHECK de atributo)
-- [ck_proveedor_telefono]
-- INSERT INTO Proveedores (nombre, telefono, correo)
-- VALUES ('Proveedor Telefono', -3001234567, 'tel@negativo.com');

-- [ck_proveedor_telefono] teléfono de un solo dígito
-- INSERT INTO Proveedores (nombre, telefono, correo)
-- VALUES ('Proveedor Telefono Corto', 5, 'corto@telefono.com');

-- [ck_proveedor_correo] correo sin nada antes de la @ ni después del punto
-- INSERT INTO Proveedores (nombre, telefono, correo)
-- VALUES ('Proveedor Correo Vacio', 3005551234, '@.');

-- NOT NULL: el turno del mesero es obligatorio
-- INSERT INTO Empleados (id_empleado, nombre, salario)
-- VALUES (900, 'Mesero sin turno', 1500000.00);
-- INSERT INTO Meseros (id_empleado, turno)
-- VALUES (900, NULL);

-- NOT NULL: la especialidad del cocinero es obligatoria
-- INSERT INTO Empleados (id_empleado, nombre, salario)
-- VALUES (901, 'Cocinero sin especialidad', 1500000.00);
-- INSERT INTO Cocineros (id_empleado, Especialidad)
-- VALUES (901, NULL);

-- [ck_receta_tiempo]
-- INSERT INTO Recetas (Nombre, tiempo_preparacion, Descripcion)
-- VALUES ('Receta rapida', 0, 'El tiempo debe ser mayor a cero');

-- [ck_plato_tiempo]
-- INSERT INTO Platos (nombre, tiempo_preparacion, id_receta)
-- VALUES ('Plato instantaneo', 0, 1);

-- [ck_ingrediente_stock_minimo]
-- INSERT INTO Ingredientes (nombre, Fecha_vencimiento, unidad_medida, stock_minimo, costo_unitario)
-- VALUES ('Pimienta', '2027-01-01', 'kg', -1, 100.00);

-- [ck_inventario_cantidad]
-- UPDATE Inventarios SET cantidad_disponible = -5 WHERE id_ingrediente = 1;

-- [ck_detalle_total]
-- INSERT INTO Detalles_compra (cantidad, Total, id_compra, id_ingrediente)
-- VALUES (5, 0, 1, 1);

-- [ck_menu_plato_precio]
-- INSERT INTO Menus_platos (id_menu, id_plato, precio, disponible)
-- VALUES (2, 3, 0, TRUE);

-- [ck_desperdicio_cantidad]
-- INSERT INTO Desperdicios (fecha, cantidad, id_ingrediente, id_empleado, id_causa)
-- VALUES ('2026-10-04', 0, 1, 1, 1);

-- PoblarNoOK: repetidos que no tienen sentido
-- [uq_proveedor_telefono]
-- INSERT INTO Proveedores (nombre, telefono, correo)
-- VALUES ('Proveedor Gemelo', 3001234567, 'gemelo@proveedor.com');

-- [uq_detalle_compra_ingrediente] el ingrediente 1 ya está en la compra 1
-- INSERT INTO Detalles_compra (cantidad, Total, id_compra, id_ingrediente)
-- VALUES (5, 40000.00, 1, 1);

-- [uq_detalle_venta_plato] el plato 1 ya está en la venta 1
-- INSERT INTO Detalles_venta (cantidad, precio_unitario, id_venta, id_plato)
-- VALUES (1, 18000.00, 1, 1);
