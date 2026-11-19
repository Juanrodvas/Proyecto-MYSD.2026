-- ============================================================
-- Proyecto MYSD 2026 - Base de datos completa (PostgreSQL)
-- Orden: Tablas, Atributos, Primarias, Unicas, Foraneas, XTablas,
--        ConsultasOperativas, ConsultasGerenciales, PoblarOK,
--        PoblarNoOK, XPoblar, Tuplas, Disparadores, XDisparadores,
--        TuplasOK, TuplasNoOK, AccionesOK, DisparadoresOK,
--        DisparadoresNoOK, Componentes, XComponentes,
--        ComponentesOK y ComponentesNoOK
-- ============================================================

-- Tablas
CREATE TABLE Proveedores (
    id_proveedor  SERIAL,
    nombre        VARCHAR(100) NOT NULL,
    telefono      BIGINT,
    correo        VARCHAR(50)
);

CREATE TABLE Empleados (
    id_empleado   SERIAL,
    nombre        VARCHAR(100) NOT NULL,
    salario       DECIMAL(10,2) NOT NULL
);

CREATE TABLE Causas_desperdicio (
    id_causa      SERIAL,
    descripcion   VARCHAR(200) NOT NULL
);

CREATE TABLE Ingredientes (
    id_ingrediente     SERIAL,
    nombre             VARCHAR(100) NOT NULL,
    Fecha_vencimiento  DATE,
    unidad_medida      VARCHAR(10) NOT NULL DEFAULT 'kg',
    stock_minimo       DECIMAL(10,2) NOT NULL DEFAULT 0,
    costo_unitario     DECIMAL(10,2) NOT NULL DEFAULT 0
);

CREATE TABLE Recetas (
    id_receta          SERIAL,
    Nombre             VARCHAR(100) NOT NULL,
    tiempo_preparacion INT,
    Descripcion        VARCHAR(255)
);

CREATE TABLE Recetas_ingredientes (
    id_receta       INT NOT NULL,
    id_ingrediente  INT NOT NULL,
    cantidad        DECIMAL(10,2) NOT NULL
);

CREATE TABLE Cocineros (
    id_empleado   INT NOT NULL,
    Especialidad  VARCHAR(50) NOT NULL
);

CREATE TABLE Meseros (
    id_empleado   INT NOT NULL,
    turno         VARCHAR(20) NOT NULL
);

CREATE TABLE Inventarios (
    id_ingrediente       INT NOT NULL,
    cantidad_disponible  DECIMAL(10,2) NOT NULL DEFAULT 0
);

CREATE TABLE Movimientos_inventario (
    id_movimiento      SERIAL,
    fecha              DATE NOT NULL,
    tipo_movimiento    VARCHAR(20) NOT NULL,
    cantidad           DECIMAL(10,2) NOT NULL,
    id_ingrediente     INT NOT NULL,
    origen             VARCHAR(20) NOT NULL,
    id_empleado        INT,
    id_detalle_compra  INT,
    id_detalle_venta   INT,
    id_desperdicio     INT
);

CREATE TABLE Compras (
    id_compra        SERIAL,
    Fecha_compra     DATE NOT NULL,
    Fecha_recepcion  DATE,
    id_proveedor     INT NOT NULL
);

CREATE TABLE Detalles_compra (
    id_detalle      SERIAL,
    cantidad        DECIMAL(10,2) NOT NULL,
    Total           DECIMAL(10,2) NOT NULL,
    id_compra       INT NOT NULL,
    id_ingrediente  INT NOT NULL
);

CREATE TABLE Platos (
    id_plato           SERIAL,
    nombre             VARCHAR(100) NOT NULL,
    tiempo_preparacion INT,
    id_receta          INT NOT NULL
);

CREATE TABLE Ventas (
    id_venta      SERIAL,
    fecha_venta   DATE NOT NULL,
    total         DECIMAL(10,2) NOT NULL DEFAULT 0,
    id_mesero     INT NOT NULL
);

CREATE TABLE Detalles_venta (
    id_detalle_venta  SERIAL,
    cantidad          INT NOT NULL DEFAULT 1,
    precio_unitario   DECIMAL(10,2) NOT NULL,
    id_venta          INT NOT NULL,
    id_plato          INT NOT NULL
);

CREATE TABLE Desperdicios (
    id_desperdicio  SERIAL,
    fecha           DATE NOT NULL,
    cantidad        DECIMAL(10,2) NOT NULL,
    id_ingrediente  INT NOT NULL,
    id_empleado     INT NOT NULL,
    id_causa        INT NOT NULL
);

CREATE TABLE Menus (
    id_menu       SERIAL,
    nombre        VARCHAR(100) NOT NULL,
    fecha_inicio  DATE NOT NULL,
    fecha_fin     DATE,
    activo        BOOLEAN NOT NULL DEFAULT TRUE
);

CREATE TABLE Menus_platos (
    id_menu     INT NOT NULL,
    id_plato    INT NOT NULL,
    precio      DECIMAL(10,2) NOT NULL,
    disponible  BOOLEAN NOT NULL DEFAULT TRUE
);

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

-- Foraneas
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

ALTER TABLE Movimientos_inventario
ADD CONSTRAINT fk_movimiento_empleado
FOREIGN KEY (id_empleado) REFERENCES Empleados(id_empleado);

ALTER TABLE Movimientos_inventario
ADD CONSTRAINT fk_movimiento_detalle_compra
FOREIGN KEY (id_detalle_compra) REFERENCES Detalles_compra(id_detalle);

ALTER TABLE Movimientos_inventario
ADD CONSTRAINT fk_movimiento_detalle_venta
FOREIGN KEY (id_detalle_venta) REFERENCES Detalles_venta(id_detalle_venta);

ALTER TABLE Movimientos_inventario
ADD CONSTRAINT fk_movimiento_desperdicio
FOREIGN KEY (id_desperdicio) REFERENCES Desperdicios(id_desperdicio);

ALTER TABLE Compras
ADD CONSTRAINT fk_compra_proveedor
FOREIGN KEY (id_proveedor) REFERENCES Proveedores(id_proveedor);

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
ADD CONSTRAINT fk_venta_mesero
FOREIGN KEY (id_mesero) REFERENCES Meseros(id_empleado);

ALTER TABLE Detalles_venta
ADD CONSTRAINT fk_detalle_venta_venta
FOREIGN KEY (id_venta) REFERENCES Ventas(id_venta);

ALTER TABLE Detalles_venta
ADD CONSTRAINT fk_detalle_venta_plato
FOREIGN KEY (id_plato) REFERENCES Platos(id_plato);

ALTER TABLE Desperdicios
ADD CONSTRAINT fk_desperdicio_ingrediente
FOREIGN KEY (id_ingrediente) REFERENCES Ingredientes(id_ingrediente);

ALTER TABLE Desperdicios
ADD CONSTRAINT fk_desperdicio_empleado
FOREIGN KEY (id_empleado) REFERENCES Empleados(id_empleado);

ALTER TABLE Desperdicios
ADD CONSTRAINT fk_desperdicio_causa
FOREIGN KEY (id_causa) REFERENCES Causas_desperdicio(id_causa);

ALTER TABLE Recetas_ingredientes
ADD CONSTRAINT fk_receta_ingrediente_receta
FOREIGN KEY (id_receta) REFERENCES Recetas(id_receta)
ON DELETE CASCADE;

ALTER TABLE Recetas_ingredientes
ADD CONSTRAINT fk_receta_ingrediente_ingrediente
FOREIGN KEY (id_ingrediente) REFERENCES Ingredientes(id_ingrediente);

ALTER TABLE Menus_platos
ADD CONSTRAINT fk_menu_plato_menu
FOREIGN KEY (id_menu) REFERENCES Menus(id_menu)
ON DELETE CASCADE;

ALTER TABLE Menus_platos
ADD CONSTRAINT fk_menu_plato_plato
FOREIGN KEY (id_plato) REFERENCES Platos(id_plato);

-- XTablas
DROP TABLE IF EXISTS Menus_platos;
DROP TABLE IF EXISTS Menus;
DROP TABLE IF EXISTS Recetas_ingredientes;
DROP TABLE IF EXISTS Movimientos_inventario;
DROP TABLE IF EXISTS Desperdicios;
DROP TABLE IF EXISTS Detalles_venta;
DROP TABLE IF EXISTS Ventas;
DROP TABLE IF EXISTS Detalles_compra;
DROP TABLE IF EXISTS Compras;
DROP TABLE IF EXISTS Inventarios;
DROP TABLE IF EXISTS Platos;
DROP TABLE IF EXISTS Meseros;
DROP TABLE IF EXISTS Cocineros;
DROP TABLE IF EXISTS Recetas;
DROP TABLE IF EXISTS Ingredientes;
DROP TABLE IF EXISTS Causas_desperdicio;
DROP TABLE IF EXISTS Empleados;
DROP TABLE IF EXISTS Proveedores;

-- ConsultasOperativas

-- O1. Como administrador quiero consultar las compras realizadas en un mes
-- para poder hacer un balance de la comida desperdiciada.
-- Cambie las fechas del BETWEEN para consultar otro mes.
SELECT c.id_compra, c.fecha_compra, p.nombre AS proveedor, SUM(dc.Total) AS total_compra
FROM Compras c
JOIN Proveedores p ON p.id_proveedor = c.id_proveedor
JOIN Detalles_compra dc ON dc.id_compra = c.id_compra
WHERE c.fecha_compra BETWEEN '2026-09-01' AND '2026-09-30'
GROUP BY c.id_compra, c.fecha_compra, p.nombre
ORDER BY c.fecha_compra;

-- O2. Como administrador quiero consultar los proveedores
-- para saber quien es el proveedor que mas envia ingredientes.
SELECT p.nombre AS proveedor, p.telefono, p.correo,
COUNT(DISTINCT c.id_compra) AS compras, SUM(dc.cantidad) AS cantidad_enviada
FROM Proveedores p
JOIN Compras c ON c.id_proveedor = p.id_proveedor
JOIN Detalles_compra dc ON dc.id_compra = c.id_compra
GROUP BY p.nombre, p.telefono, p.correo
ORDER BY cantidad_enviada DESC;

-- O3. Como administrador quiero consultar el inventario
-- para saber que ingredientes tengo disponibles y que tengo que pedir.
-- Un sobrante negativo significa que esta por debajo del stock minimo y hay que pedirlo.
SELECT i.nombre AS ingrediente, inv.cantidad_disponible, i.unidad_medida, i.stock_minimo,
inv.cantidad_disponible - i.stock_minimo AS sobrante
FROM Inventarios inv
JOIN Ingredientes i ON i.id_ingrediente = inv.id_ingrediente
ORDER BY sobrante, i.nombre;

-- O4. Como administrador quiero consultar cada movimiento del inventario
-- para saber cual ingrediente tiene mas rotacion y cual se queda mucho tiempo sin salir.
SELECT i.nombre AS ingrediente, m.tipo_movimiento, COUNT(*) AS movimientos,
SUM(m.cantidad) AS cantidad_total, MAX(m.fecha) AS ultimo_movimiento,
CURRENT_DATE - MAX(m.fecha) AS dias_sin_movimiento
FROM Movimientos_inventario m
JOIN Ingredientes i ON i.id_ingrediente = m.id_ingrediente
GROUP BY i.nombre, m.tipo_movimiento
ORDER BY m.tipo_movimiento, cantidad_total DESC;

-- O5. Como administrador quiero consultar las ventas realizadas de cada mes
-- para tener un balance entre el desperdicio de comida y las ganancias de las ventas.
SELECT EXTRACT(YEAR FROM v.fecha_venta) AS anio, EXTRACT(MONTH FROM v.fecha_venta) AS mes,COUNT(*) AS cuentas, SUM(v.total) AS total_vendido
FROM Ventas v
GROUP BY EXTRACT(YEAR FROM v.fecha_venta), EXTRACT(MONTH FROM v.fecha_venta)
ORDER BY anio, mes;

-- O6. Como administrador quiero consultar los platos mas vendidos de cada mes
-- para comprar los ingredientes mas usados en esos platos y reducir los desperdicios.
SELECT EXTRACT(YEAR FROM v.fecha_venta) AS anio, EXTRACT(MONTH FROM v.fecha_venta) AS mes,
       p.nombre AS plato, SUM(dv.cantidad) AS unidades_vendidas
FROM Detalles_venta dv
JOIN Ventas v ON v.id_venta = dv.id_venta
JOIN Platos p ON p.id_plato = dv.id_plato
GROUP BY EXTRACT(YEAR FROM v.fecha_venta), EXTRACT(MONTH FROM v.fecha_venta), p.nombre
ORDER BY anio, mes, unidades_vendidas DESC;

-- O7. Como administrador quiero consultar la lista de compras con los ingredientes que estan por debajo del stock minimo
-- para saber que tengo que pedir a los proveedores antes de que se acaben.
SELECT i.nombre AS ingrediente, inv.cantidad_disponible, i.stock_minimo,
i.stock_minimo - inv.cantidad_disponible AS faltante,
       (i.stock_minimo - inv.cantidad_disponible) * i.costo_unitario AS costo_estimado
FROM Inventarios inv
JOIN Ingredientes i ON i.id_ingrediente = inv.id_ingrediente
WHERE inv.cantidad_disponible < i.stock_minimo
ORDER BY faltante DESC;

-- O8. Como administrador quiero consultar los platos del menu que estan en riesgo por falta de algun ingrediente
-- para avisar a tiempo, reponer el ingrediente y no dejar de ofrecer esos platos.
-- Un plato esta en riesgo si algun ingrediente de su receta esta por debajo del stock minimo.
SELECT DISTINCT m.nombre AS menu, p.nombre AS plato, i.nombre AS ingrediente_en_riesgo,
                inv.cantidad_disponible, i.stock_minimo
FROM Menus m
JOIN Menus_platos mp ON mp.id_menu = m.id_menu
JOIN Platos p ON p.id_plato = mp.id_plato
JOIN Recetas_ingredientes ri ON ri.id_receta = p.id_receta
JOIN Ingredientes i ON i.id_ingrediente = ri.id_ingrediente
JOIN Inventarios inv ON inv.id_ingrediente = i.id_ingrediente
WHERE m.activo = TRUE AND inv.cantidad_disponible < i.stock_minimo
ORDER BY m.nombre, p.nombre;

-- O9. Como administrador quiero consultar el detalle de una venta: platos, cantidades, precio y mesero
-- para revisar lo que se vendio en cada cuenta y compararlo con los ingredientes que salieron.
-- Cambie el 1 para consultar otra venta.
SELECT v.id_venta, v.fecha_venta, e.nombre AS mesero, p.nombre AS plato, dv.cantidad,
       dv.precio_unitario, dv.cantidad * dv.precio_unitario AS subtotal
FROM Ventas v
JOIN Empleados e ON e.id_empleado = v.id_mesero
JOIN Detalles_venta dv ON dv.id_venta = v.id_venta
JOIN Platos p ON p.id_plato = dv.id_plato
WHERE v.id_venta = 1
ORDER BY p.nombre;

-- O10. Como administrador quiero consultar los desperdicios de cada mes
-- para observar en que meses hay mas desperdicios y como reducirlos al minimo.
SELECT EXTRACT(YEAR FROM d.fecha) AS anio, EXTRACT(MONTH FROM d.fecha) AS mes,
COUNT(*) AS registros, SUM(d.cantidad) AS cantidad_desperdiciada
FROM Desperdicios d
GROUP BY EXTRACT(YEAR FROM d.fecha), EXTRACT(MONTH FROM d.fecha)
ORDER BY anio, mes;

-- O11. Como empleado quiero consultar los ingredientes del dia
-- para tener claro que platos podre preparar o cuales ofrecer al cliente.
-- Son los ingredientes con existencias y que no estan vencidos.
SELECT i.nombre AS ingrediente, inv.cantidad_disponible, i.unidad_medida, i.Fecha_vencimiento
FROM Ingredientes i
JOIN Inventarios inv ON inv.id_ingrediente = i.id_ingrediente
WHERE inv.cantidad_disponible > 0
  AND (i.Fecha_vencimiento IS NULL OR i.Fecha_vencimiento >= CURRENT_DATE)
ORDER BY i.nombre;

-- O12. Como empleado quiero consultar el inventario
-- para saber que tengo que pedir a los proveedores y seguir vendiendo los platos que me pidan.
SELECT i.nombre AS ingrediente, inv.cantidad_disponible, i.unidad_medida, i.stock_minimo
FROM Inventarios inv
JOIN Ingredientes i ON i.id_ingrediente = inv.id_ingrediente
WHERE inv.cantidad_disponible <= i.stock_minimo
ORDER BY inv.cantidad_disponible;

-- O13. Como empleado quiero consultar los platos devueltos
-- para entender sus devoluciones y reducir los desperdicios por devolucion de platos.
-- Es el desperdicio cuya causa es la devolucion del cliente.
SELECT d.fecha, i.nombre AS ingrediente, d.cantidad, e.nombre AS registrado_por
FROM Desperdicios d
JOIN Causas_desperdicio c ON c.id_causa = d.id_causa
JOIN Ingredientes i ON i.id_ingrediente = d.id_ingrediente
JOIN Empleados e ON e.id_empleado = d.id_empleado
WHERE c.descripcion = 'Devolución del cliente'
ORDER BY d.fecha;

-- O14. Como empleado quiero consultar los desperdicios del dia
-- para observar en que platos hay mayor desperdicio y reducirlo.
-- Cambie la fecha para consultar otro dia (CURRENT_DATE para hoy).
SELECT d.fecha, i.nombre AS ingrediente, c.descripcion AS causa, d.cantidad
FROM Desperdicios d
JOIN Ingredientes i ON i.id_ingrediente = d.id_ingrediente
JOIN Causas_desperdicio c ON c.id_causa = d.id_causa
WHERE d.fecha = '2026-10-03'
ORDER BY d.cantidad DESC;

-- O15. Como cliente quiero consultar los platos de comida
-- para ordenar mi comida de mi mayor agrado.
SELECT m.nombre AS menu, p.nombre AS plato, mp.precio, p.tiempo_preparacion
FROM Menus m
JOIN Menus_platos mp ON mp.id_menu = m.id_menu
JOIN Platos p ON p.id_plato = mp.id_plato
WHERE m.activo = TRUE AND mp.disponible = TRUE
ORDER BY p.nombre;

-- O16. Como cliente quiero consultar las recetas
-- para decidir que comer.
SELECT r.Nombre AS receta, r.Descripcion, r.tiempo_preparacion,
i.nombre AS ingrediente, ri.cantidad, i.unidad_medida
FROM Recetas r
JOIN Recetas_ingredientes ri ON ri.id_receta = r.id_receta
JOIN Ingredientes i ON i.id_ingrediente = ri.id_ingrediente
ORDER BY r.Nombre, i.nombre;

-- O17. Como cliente quiero consultar la disponibilidad de platos e ingredientes
-- para ordenar mi comida con los ingredientes de mayor disponibilidad.
-- margen_minimo es lo que sobra del ingrediente mas justo para una porcion:
-- si es negativo el plato no esta disponible porque falta ese ingrediente.
SELECT p.nombre AS plato, COUNT(*) AS ingredientes,
MIN(inv.cantidad_disponible - ri.cantidad) AS margen_minimo
FROM Platos p
JOIN Recetas_ingredientes ri ON ri.id_receta = p.id_receta
JOIN Inventarios inv ON inv.id_ingrediente = ri.id_ingrediente
GROUP BY p.nombre
ORDER BY margen_minimo, p.nombre;

-- ConsultasGerenciales

-- G1. Como administrador quiero consultar el desperdicio de comida por turno
-- para identificar en que turnos se desperdicia mas y reforzar el control ahi.
-- El turno solo existe en Meseros: cuenta los desperdicios registrados por meseros.
SELECT m.turno, COUNT(*) AS registros, SUM(d.cantidad) AS cantidad_desperdiciada
FROM Desperdicios d
JOIN Meseros m ON m.id_empleado = d.id_empleado
GROUP BY m.turno
ORDER BY cantidad_desperdiciada DESC;

-- G2. Como administrador quiero consultar la lista de ingredientes mas desperdiciados
-- para decidir que ingredientes comprar en menor cantidad o cuidar mejor.
SELECT i.nombre AS ingrediente, i.unidad_medida, SUM(d.cantidad) AS cantidad_desperdiciada
FROM Desperdicios d
JOIN Ingredientes i ON i.id_ingrediente = d.id_ingrediente
GROUP BY i.nombre, i.unidad_medida
ORDER BY cantidad_desperdiciada DESC;

-- G3. Como administrador quiero consultar el desperdicio de ingredientes segun el proveedor que los entrego
-- para evaluar que proveedores entregan ingredientes que se desperdician mas.
-- Si un ingrediente lo han entregado varios proveedores, se cuenta para cada uno.
SELECT p.nombre AS proveedor, SUM(d.cantidad) AS cantidad_desperdiciada
FROM Desperdicios d
JOIN Detalles_compra dc ON dc.id_ingrediente = d.id_ingrediente
JOIN Compras c ON c.id_compra = dc.id_compra
JOIN Proveedores p ON p.id_proveedor = c.id_proveedor
GROUP BY p.nombre
ORDER BY cantidad_desperdiciada DESC;

-- G4. Como gerente quiero consultar el desperdicio de comida en un rango de fechas
-- para comparar periodos y ver si las medidas para reducir el desperdicio funcionan.
-- Cambie las fechas del BETWEEN para comparar otro periodo.
SELECT d.fecha AS dia, SUM(d.cantidad) AS cantidad_desperdiciada
FROM Desperdicios d
WHERE d.fecha BETWEEN '2026-09-23' AND '2026-10-08'
GROUP BY d.fecha
ORDER BY d.fecha;

-- G5. Como gerente quiero consultar el desperdicio por causa y por area de trabajo
-- para saber en que area y por que causa se desperdicia mas y asignar responsables.
-- El area es Cocina (el empleado es cocinero) o Salon (el empleado es mesero).
SELECT 'Cocina' AS area, c.descripcion AS causa, SUM(d.cantidad) AS cantidad_desperdiciada
FROM Desperdicios d
JOIN Cocineros co ON co.id_empleado = d.id_empleado
JOIN Causas_desperdicio c ON c.id_causa = d.id_causa
GROUP BY c.descripcion
UNION ALL
SELECT 'Salon', c.descripcion, SUM(d.cantidad)
FROM Desperdicios d
JOIN Meseros me ON me.id_empleado = d.id_empleado
JOIN Causas_desperdicio c ON c.id_causa = d.id_causa
GROUP BY c.descripcion
ORDER BY 1, 3 DESC;

-- G6. Como gerente quiero consultar el gasto mensual de cada ingrediente, sumando ventas y desperdicio
-- para saber cuanto consume el restaurante de cada ingrediente y planear las compras.
-- Ventas: cantidad por porcion de la receta x platos vendidos. Desperdicio: cantidad desperdiciada.
SELECT g.anio, g.mes, i.nombre AS ingrediente, i.unidad_medida, SUM(g.cantidad) AS gasto_total
FROM (
    SELECT EXTRACT(YEAR FROM v.fecha_venta) AS anio, EXTRACT(MONTH FROM v.fecha_venta) AS mes,
           ri.id_ingrediente, ri.cantidad * dv.cantidad AS cantidad
    FROM Detalles_venta dv
    JOIN Ventas v ON v.id_venta = dv.id_venta
    JOIN Platos p ON p.id_plato = dv.id_plato
    JOIN Recetas_ingredientes ri ON ri.id_receta = p.id_receta
    UNION ALL
    SELECT EXTRACT(YEAR FROM d.fecha), EXTRACT(MONTH FROM d.fecha), d.id_ingrediente, d.cantidad
    FROM Desperdicios d
) g
JOIN Ingredientes i ON i.id_ingrediente = g.id_ingrediente
GROUP BY g.anio, g.mes, i.nombre, i.unidad_medida
ORDER BY g.anio, g.mes, gasto_total DESC;

-- G7. Como gerente quiero consultar cuantos dias alcanza cada ingrediente segun su gasto promedio de los ultimos 3 meses
-- para pedir a tiempo y evitar quedarme sin ingredientes.
-- Dias que alcanza = cantidad disponible / (gasto de los ultimos 3 meses / 90 dias).
-- Los 3 meses terminan en la ultima venta registrada
SELECT i.nombre AS ingrediente, inv.cantidad_disponible, ROUND(SUM(g.cantidad) / 90, 2) AS gasto_promedio_diario,
ROUND(inv.cantidad_disponible / (SUM(g.cantidad) / 90), 1) AS dias_que_alcanza
FROM (
    SELECT v.fecha_venta AS fecha, ri.id_ingrediente, ri.cantidad * dv.cantidad AS cantidad
    FROM Detalles_venta dv
    JOIN Ventas v ON v.id_venta = dv.id_venta
    JOIN Platos p ON p.id_plato = dv.id_plato
    JOIN Recetas_ingredientes ri ON ri.id_receta = p.id_receta
    UNION ALL
    SELECT d.fecha, d.id_ingrediente, d.cantidad
    FROM Desperdicios d
) g
JOIN Ingredientes i ON i.id_ingrediente = g.id_ingrediente
JOIN Inventarios inv ON inv.id_ingrediente = i.id_ingrediente
WHERE g.fecha >= (SELECT MAX(fecha_venta) FROM Ventas) - INTERVAL '3 months'
GROUP BY i.nombre, inv.cantidad_disponible
ORDER BY dias_que_alcanza;

-- G8. Como gerente quiero consultar el total vendido por cada mesero en un periodo
-- para evaluar el desempeno del personal de salon y su aporte a las ventas.
-- Cambie las fechas del BETWEEN para consultar otro periodo.
SELECT e.nombre AS mesero, me.turno, COUNT(*) AS cuentas, SUM(v.total) AS total_vendido
FROM Ventas v
JOIN Meseros me ON me.id_empleado = v.id_mesero
JOIN Empleados e ON e.id_empleado = me.id_empleado
WHERE v.fecha_venta BETWEEN '2026-09-01' AND '2026-10-31'
GROUP BY e.nombre, me.turno
ORDER BY total_vendido DESC;

-- G9. Como gerente quiero consultar las perdidas economicas por el desperdicio de comida
-- para saber cuanto dinero se pierde y tomar decisiones para reducirlo.
-- Perdida = cantidad desperdiciada * costo unitario del ingrediente.
SELECT i.nombre AS ingrediente, SUM(d.cantidad) AS cantidad_desperdiciada,
       i.costo_unitario, SUM(d.cantidad * i.costo_unitario) AS perdida_economica
FROM Desperdicios d
JOIN Ingredientes i ON i.id_ingrediente = d.id_ingrediente
GROUP BY i.nombre, i.costo_unitario
ORDER BY perdida_economica DESC;

-- G10. Como administrador quiero consultar el desperdicio de comida por cada causa
-- para saber que causas generan mas desperdicio y poder corregirlas.
SELECT c.descripcion AS causa, COUNT(*) AS registros, SUM(d.cantidad) AS cantidad_desperdiciada
FROM Desperdicios d
JOIN Causas_desperdicio c ON c.id_causa = d.id_causa
GROUP BY c.descripcion
ORDER BY cantidad_desperdiciada DESC;

-- PoblarOK
INSERT INTO Proveedores (nombre, telefono, correo) VALUES
('Distribuidora La Fresca', 3001234567, 'contacto@lafresca.com'),
('AgroSuministros SAS',     3007654321, 'ventas@agrosuministros.com'),
('Carnes Premium Ltda',     3009876543, 'info@carnespremium.com');

INSERT INTO Empleados (nombre, salario) VALUES
('Carlos Ramírez',  1800000.00),
('Laura Gómez',     1600000.00),
('Andrés Torres',   1700000.00),
('Mariana Ríos',    1550000.00);

INSERT INTO Causas_desperdicio (descripcion) VALUES
('Producto vencido'),
('Error de preparación'),
('Sobreproducción');

INSERT INTO Ingredientes (nombre, Fecha_vencimiento, unidad_medida, stock_minimo, costo_unitario) VALUES
('Arroz',        '2026-12-01', 'kg', 10, 4500.00),
('Papa criolla', '2026-11-15', 'kg', 10, 3500.00),
('Carne de res', '2027-01-20', 'kg', 15, 28000.00),
('Pollo',        '2026-10-10', 'kg', 10, 12000.00),
('Fríjol',       '2026-12-25', 'kg', 8,  7000.00);

INSERT INTO Recetas (Nombre, tiempo_preparacion, Descripcion) VALUES
('Bandeja Paisa',       45, 'Plato típico colombiano'),
('Ajiaco Santafereño',  60, 'Sopa típica bogotana'),
('Ensalada César',      20, 'Ensalada con pollo a la parrilla');

INSERT INTO Cocineros (id_empleado, Especialidad) VALUES
(1, 'Cocina Colombiana'),
(3, 'Parrilla');

INSERT INTO Meseros (id_empleado, turno) VALUES
(2, 'Mañana'),
(4, 'Tarde');

INSERT INTO Inventarios (id_ingrediente, cantidad_disponible) VALUES
(1, 50),
(2, 30),
(3, 80),
(4, 15),
(5, 60);

INSERT INTO Movimientos_inventario (fecha, tipo_movimiento, cantidad, id_ingrediente, origen, id_empleado) VALUES
('2026-09-20', 'Entrada', 20, 1, 'Compra', 1),
('2026-09-21', 'Salida',  5,  2, 'Venta',  2),
('2026-09-22', 'Entrada', 10, 3, 'Compra', 3);

INSERT INTO Compras (Fecha_compra, Fecha_recepcion, id_proveedor) VALUES
('2026-09-15', '2026-09-17', 1),
('2026-09-18', '2026-09-19', 2),
('2026-09-20', NULL,         3);

INSERT INTO Detalles_compra (cantidad, Total, id_compra, id_ingrediente) VALUES
(20, 150000.00, 1, 1),
(10, 80000.00,  2, 2),
(15, 200000.00, 3, 3);

INSERT INTO Platos (nombre, tiempo_preparacion, id_receta) VALUES
('Bandeja Paisa',      45, 1),
('Ajiaco Santafereño', 60, 2),
('Ensalada César',     20, 3);

-- Dos cuentas con varios platos cada una
INSERT INTO Ventas (fecha_venta, total, id_mesero) VALUES
('2026-09-24', 68000.00, 2),
('2026-09-25', 70000.00, 4);

INSERT INTO Detalles_venta (cantidad, precio_unitario, id_venta, id_plato) VALUES
(2, 25000.00, 1, 1),
(1, 18000.00, 1, 2),
(3, 15000.00, 2, 3),
(1, 25000.00, 2, 1);

INSERT INTO Desperdicios (fecha, cantidad, id_ingrediente, id_empleado, id_causa) VALUES
('2026-09-23', 2.5, 2, 1, 1),
('2026-09-24', 1.2, 4, 3, 3);

-- PoblarOK automático: completa cada tabla hasta al menos 15 filas
INSERT INTO Proveedores (nombre, telefono, correo)
SELECT
    (ARRAY['Frigorífico El Llano', 'Hortalizas de la Sabana', 'Granos y Cereales SAS',
        'Pescados del Pacífico', 'Avícola San Martín', 'Especias del Oriente',
        'Panadería Industrial Trigal', 'Bebidas La Montaña', 'Aceites y Grasas Ltda',
        'Quesos Ubaté', 'Tubérculos Boyacá', 'Empaques Gourmet'])[i],
    3100000000 + i * 1111,
    'ventas@' || (ARRAY['frigollano', 'hortasabana', 'granoscereales', 'pescapacifico',
        'avicolasm', 'especiasoriente', 'trigal', 'bebidasmontana',
        'aceitesgrasas', 'quesosubate', 'tuberculosboy', 'empaquesgourmet'])[i] || '.com'
FROM generate_series(1, 12) AS i;

-- 26 empleados nuevos (id 5 a 30): 13 serán cocineros y 13 meseros
INSERT INTO Empleados (nombre, salario)
SELECT
    (ARRAY['Sofía Herrera', 'Julián Castro', 'Valentina Mora', 'Felipe Duarte', 'Daniela Pardo',
        'Santiago Vargas', 'Isabella Cruz', 'Mateo Rincón', 'Gabriela Peña', 'Nicolás Suárez',
        'Paula Medina', 'Sebastián Ortiz', 'Natalia León', 'Diego Cárdenas', 'Lucía Molina',
        'Tomás Salazar', 'Manuela Ruiz', 'Samuel Acosta', 'Sara Jiménez', 'David Rojas',
        'Antonia Vega', 'Martín Guzmán', 'Juliana Prieto', 'Emilio Navarro', 'Catalina Ávila',
        'Simón Beltrán'])[i],
    1500000.00 + i * 25000
FROM generate_series(1, 26) AS i;

INSERT INTO Causas_desperdicio (descripcion)
SELECT
    (ARRAY['Contaminación cruzada', 'Mal almacenamiento', 'Cadena de frío interrumpida',
        'Producto quemado', 'Devolución del cliente', 'Caída o derrame',
        'Empaque dañado', 'Plaga detectada', 'Porción mal servida',
        'Pedido cancelado', 'Falla de equipo', 'Recibido en mal estado'])[i]
FROM generate_series(1, 12) AS i;

INSERT INTO Ingredientes (nombre, Fecha_vencimiento, unidad_medida, stock_minimo, costo_unitario)
SELECT
    (ARRAY['Plátano', 'Huevo', 'Queso costeño', 'Yuca', 'Cebolla larga',
        'Mazorca', 'Cilantro', 'Leche', 'Camarón', 'Lechuga'])[i],
    DATE '2026-11-01' + i * 7,
    (ARRAY['unidad', 'unidad', 'kg', 'kg', 'kg',
        'unidad', 'kg', 'L', 'kg', 'kg'])[i],
    (ARRAY[20, 30, 5, 8, 3, 15, 1, 10, 5, 4])[i],
    (ARRAY[800, 600, 18000, 2500, 4000, 1500, 15000, 3800, 35000, 3000])[i]
FROM generate_series(1, 10) AS i;

INSERT INTO Recetas (Nombre, tiempo_preparacion, Descripcion)
SELECT
    (ARRAY['Sancocho de Gallina', 'Arroz con Pollo', 'Mondongo', 'Lechona',
        'Tamal Tolimense', 'Cazuela de Mariscos', 'Posta Negra', 'Sobrebarriga',
        'Frijolada', 'Mote de Queso', 'Arroz Atollado', 'Viudo de Pescado'])[i],
    (ARRAY[90, 50, 120, 240, 180, 40, 150, 100, 80, 45, 60, 70])[i],
    (ARRAY['Sopa de gallina criolla con tubérculos', 'Arroz amarillo con pollo desmechado',
        'Sopa de callo con verduras', 'Cerdo relleno de arroz y arveja',
        'Masa de maíz rellena envuelta en hoja', 'Mariscos en salsa cremosa',
        'Carne en salsa de panela, receta cartagenera', 'Falda de res en salsa criolla',
        'Frijoles con garra y hogao', 'Sopa costeña de ñame y queso',
        'Arroz caldoso vallecaucano', 'Pescado cocido al vapor con plátano'])[i]
FROM generate_series(1, 12) AS i;

-- Ingredientes de cada receta, con la cantidad que lleva UNA porción
-- Ingredientes: 1 Arroz, 2 Papa criolla, 3 Carne de res, 4 Pollo, 5 Fríjol, 6 Plátano, 7 Huevo,
-- 8 Queso costeño, 9 Yuca, 10 Cebolla larga, 11 Mazorca, 12 Cilantro, 13 Leche, 14 Camarón, 15 Lechuga
INSERT INTO Recetas_ingredientes (id_receta, id_ingrediente, cantidad) VALUES
(1, 3, 0.25), (1, 5, 0.20), (1, 1, 0.15), (1, 6, 1),    (1, 7, 1),       -- Bandeja Paisa
(2, 4, 0.30), (2, 2, 0.40), (2, 11, 1),   (2, 12, 0.01),                  -- Ajiaco Santafereño
(3, 15, 0.15), (3, 4, 0.15), (3, 8, 0.05),                                -- Ensalada César
(4, 4, 0.40), (4, 2, 0.20), (4, 9, 0.20), (4, 11, 1), (4, 12, 0.01),      -- Sancocho de Gallina
(5, 1, 0.20), (5, 4, 0.25),                                               -- Arroz con Pollo
(6, 2, 0.20), (6, 9, 0.20), (6, 12, 0.01),                                -- Mondongo
(7, 1, 0.20), (7, 10, 0.05),                                              -- Lechona
(8, 7, 1),    (8, 4, 0.15),                                               -- Tamal Tolimense
(9, 14, 0.25), (9, 13, 0.10),                                             -- Cazuela de Mariscos
(10, 3, 0.30), (10, 10, 0.05),                                            -- Posta Negra
(11, 3, 0.30), (11, 2, 0.20),                                             -- Sobrebarriga
(12, 5, 0.25), (12, 6, 1),                                                -- Frijolada
(13, 8, 0.15), (13, 10, 0.03),                                            -- Mote de Queso
(14, 1, 0.20), (14, 4, 0.20), (14, 2, 0.15),                              -- Arroz Atollado
(15, 6, 1),    (15, 9, 0.20);                                             -- Viudo de Pescado

INSERT INTO Cocineros (id_empleado, Especialidad)
SELECT
    e,
    (ARRAY['Cocina Colombiana', 'Parrilla', 'Mariscos', 'Repostería', 'Panadería',
        'Sopas', 'Cocina Internacional', 'Salsas', 'Ensaladas', 'Carnes',
        'Cocina Costeña', 'Postres', 'Asados'])[e - 4]
FROM generate_series(5, 17) AS e;

INSERT INTO Meseros (id_empleado, turno)
SELECT
    e,
    (ARRAY['Mañana', 'Tarde', 'Noche'])[1 + e % 3]
FROM generate_series(18, 30) AS e;

INSERT INTO Inventarios (id_ingrediente, cantidad_disponible)
SELECT
    i,
    20 + i * 5
FROM generate_series(6, 15) AS i;

INSERT INTO Movimientos_inventario (fecha, tipo_movimiento, cantidad, id_ingrediente, origen, id_empleado)
SELECT
    DATE '2026-09-22' + i,
    CASE WHEN i % 2 = 0 THEN 'Entrada' ELSE 'Salida' END,
    2 + i % 4,
    1 + i % 15,
    CASE WHEN i % 2 = 0 THEN 'Compra' ELSE 'Venta' END,
    1 + i % 4
FROM generate_series(1, 12) AS i;

INSERT INTO Compras (Fecha_compra, Fecha_recepcion, id_proveedor)
SELECT
    DATE '2026-09-01' + i,
    DATE '2026-09-01' + i + 1 + i % 2,
    1 + i % 15
FROM generate_series(1, 12) AS i;

-- un detalle por cada compra nueva (id 4 a 15)
INSERT INTO Detalles_compra (cantidad, Total, id_compra, id_ingrediente)
SELECT
    5 + c,
    (5 + c) * 8000.00,
    c,
    c
FROM generate_series(4, 15) AS c;

-- un plato por cada receta nueva, con el mismo nombre y tiempo
INSERT INTO Platos (nombre, tiempo_preparacion, id_receta)
SELECT
    Nombre,
    tiempo_preparacion,
    id_receta
FROM Recetas
WHERE id_receta > 3;

-- 13 cuentas nuevas (id 3 a 15), cada una con un plato; el total es precio x cantidad
INSERT INTO Ventas (fecha_venta, total, id_mesero)
SELECT
    DATE '2026-09-26' + i % 10,
    (15000.00 + (i % 5) * 3000) * (1 + i % 3),
    18 + i % 13
FROM generate_series(1, 13) AS i;

INSERT INTO Detalles_venta (cantidad, precio_unitario, id_venta, id_plato)
SELECT
    1 + i % 3,
    15000.00 + (i % 5) * 3000,
    i + 2,
    1 + i % 15
FROM generate_series(1, 13) AS i;

INSERT INTO Desperdicios (fecha, cantidad, id_ingrediente, id_empleado, id_causa)
SELECT
    DATE '2026-09-25' + i,
    0.5 + (i % 4) * 0.5,
    1 + i % 15,
    4 + i,
    1 + i % 15
FROM generate_series(1, 13) AS i;

-- Desperdicios registrados por meseros (uno por turno y varios en la noche),
-- para que las consultas gerenciales por turno y por area tengan datos de Salon
INSERT INTO Desperdicios (fecha, cantidad, id_ingrediente, id_empleado, id_causa) VALUES
('2026-09-25', 0.8, 1, 2,  4),
('2026-09-26', 1.5, 3, 4,  2),
('2026-10-02', 1.0, 5, 20, 6),
('2026-10-04', 0.5, 6, 23, 7),
('2026-10-05', 1.2, 8, 26, 1);

-- Menús: lo que ofrece el restaurante
INSERT INTO Menus (nombre, fecha_inicio, fecha_fin, activo) VALUES
('Carta principal', '2026-09-01', NULL,         TRUE),
('Menú del día',    '2026-10-01', '2026-10-31', FALSE),
('Menú navideño',   '2026-12-01', '2026-12-31', FALSE);

-- La carta principal ofrece todos los platos
INSERT INTO Menus_platos (id_menu, id_plato, precio, disponible)
SELECT 1, id_plato, 15000.00 + (id_plato % 5) * 3000, TRUE
FROM Platos;

INSERT INTO Menus_platos (id_menu, id_plato, precio, disponible) VALUES
(2, 2, 14000.00, TRUE),
(2, 5, 13000.00, TRUE),
(2, 11, 15000.00, FALSE),
(3, 8, 22000.00, TRUE),
(3, 7, 28000.00, TRUE);

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

-- XPoblar
-- DROP TABLE IF EXISTS Menus_platos CASCADE;
-- DROP TABLE IF EXISTS Menus CASCADE;
-- DROP TABLE IF EXISTS Recetas_ingredientes CASCADE;
-- DROP TABLE IF EXISTS Desperdicios CASCADE;
-- DROP TABLE IF EXISTS Detalles_venta CASCADE;
-- DROP TABLE IF EXISTS Ventas CASCADE;
-- DROP TABLE IF EXISTS Platos CASCADE;
-- DROP TABLE IF EXISTS Detalles_compra CASCADE;
-- DROP TABLE IF EXISTS Compras CASCADE;
-- DROP TABLE IF EXISTS Movimientos_inventario CASCADE;
-- DROP TABLE IF EXISTS Inventarios CASCADE;
-- DROP TABLE IF EXISTS Recetas CASCADE;
-- DROP TABLE IF EXISTS Cocineros CASCADE;
-- DROP TABLE IF EXISTS Meseros CASCADE;
-- DROP TABLE IF EXISTS Empleados CASCADE;
-- DROP TABLE IF EXISTS Causas_desperdicio CASCADE;
-- DROP TABLE IF EXISTS Ingredientes CASCADE;
-- DROP TABLE IF EXISTS Proveedores CASCADE;

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

-- XDisparadores
-- DROP TRIGGER IF EXISTS t_cocinero_no_mesero ON Cocineros;
-- DROP TRIGGER IF EXISTS t_recibir_compra ON Compras;
-- DROP TRIGGER IF EXISTS t_salida_con_inventario ON Movimientos_inventario;
-- DROP TRIGGER IF EXISTS t_mesero_no_cocinero ON Meseros;
-- DROP TRIGGER IF EXISTS t_descontar_salida ON Movimientos_inventario;
-- DROP TRIGGER IF EXISTS t_venta_descontar_ingredientes ON Detalles_venta;
-- DROP TRIGGER IF EXISTS t_detalle_venta_total ON Detalles_venta;
-- DROP TRIGGER IF EXISTS t_desperdicio_descontar ON Desperdicios;
-- DROP FUNCTION IF EXISTS f_cocinero_no_mesero();
-- DROP FUNCTION IF EXISTS f_recibir_compra();
-- DROP FUNCTION IF EXISTS f_salida_con_inventario();
-- DROP FUNCTION IF EXISTS f_mesero_no_cocinero();
-- DROP FUNCTION IF EXISTS f_descontar_salida();
-- DROP FUNCTION IF EXISTS f_venta_descontar_ingredientes();
-- DROP FUNCTION IF EXISTS f_desperdicio_descontar();
-- DROP FUNCTION IF EXISTS f_detalle_venta_total();

-- TuplasOK
INSERT INTO Proveedores (nombre, telefono, correo)
VALUES ('Lácteos del Valle', NULL, 'ventas@lacteosvalle.com');

INSERT INTO Proveedores (nombre, telefono, correo)
VALUES ('Frutas El Campo', 3112223344, NULL);

INSERT INTO Compras (Fecha_compra, Fecha_recepcion, id_proveedor)
VALUES ('2026-10-01', '2026-10-03', 1);

INSERT INTO Compras (Fecha_compra, Fecha_recepcion, id_proveedor)
VALUES ('2026-10-05', '2026-10-05', 2);

INSERT INTO Menus (nombre, fecha_inicio, fecha_fin, activo)
VALUES ('Menú de temporada', '2027-01-01', NULL, FALSE);

INSERT INTO Menus (nombre, fecha_inicio, fecha_fin, activo)
VALUES ('Menú de un día', '2027-02-14', '2027-02-14', FALSE);

INSERT INTO Movimientos_inventario (fecha, tipo_movimiento, cantidad, id_ingrediente, origen, id_detalle_compra)
VALUES ('2026-10-06', 'Entrada', 5, 1, 'Compra', 1);

-- TuplasNoOK
-- INSERT INTO Proveedores (nombre, telefono, correo)
-- VALUES ('Proveedor Sin Contacto', NULL, NULL);

-- INSERT INTO Compras (Fecha_compra, Fecha_recepcion, id_proveedor)
-- VALUES ('2026-10-10', '2026-10-01', 1);

-- INSERT INTO Menus (nombre, fecha_inicio, fecha_fin, activo)
-- VALUES ('Menú al revés', '2027-03-10', '2027-03-01', TRUE);

-- Movimiento de venta pero apuntando a un detalle de compra
-- INSERT INTO Movimientos_inventario (fecha, tipo_movimiento, cantidad, id_ingrediente, origen, id_detalle_compra)
-- VALUES ('2026-10-06', 'Salida', 1, 1, 'Venta', 1);

-- Movimiento que apunta a la vez a un detalle de compra y a un desperdicio
-- INSERT INTO Movimientos_inventario (fecha, tipo_movimiento, cantidad, id_ingrediente, origen, id_detalle_compra, id_desperdicio)
-- VALUES ('2026-10-06', 'Entrada', 1, 1, 'Compra', 1, 1);

-- [ck_movimiento_tipo_origen] una entrada que viene de una venta
-- INSERT INTO Movimientos_inventario (fecha, tipo_movimiento, cantidad, id_ingrediente, origen)
-- VALUES ('2026-10-06', 'Entrada', 1, 1, 'Venta');

-- [ck_movimiento_tipo_origen] una salida que viene de una compra
-- INSERT INTO Movimientos_inventario (fecha, tipo_movimiento, cantidad, id_ingrediente, origen)
-- VALUES ('2026-10-06', 'Salida', 1, 1, 'Compra');

-- [ck_movimiento_tipo_origen] una entrada que viene de un desperdicio
-- INSERT INTO Movimientos_inventario (fecha, tipo_movimiento, cantidad, id_ingrediente, origen)
-- VALUES ('2026-10-06', 'Entrada', 1, 1, 'Desperdicio');

-----------------
--AccionesOK--
--1--
INSERT INTO Empleados(id_empleado, nombre, salario)
VALUES(99, 'jhojan', 2000);

INSERT INTO Cocineros(id_empleado, Especialidad)
VALUES(99, 'reposteria');

SELECT * FROM Cocineros WHERE id_empleado=99;

DELETE FROM Empleados WHERE id_empleado=99;

SELECT * FROM Cocineros WHERE id_empleado=99;

--2--
INSERT INTO Empleados(id_empleado, nombre, salario)
VALUES(109, 'JUAN', 4000);

INSERT INTO Meseros(id_empleado, turno)
VALUES(109, 'Noche');

SELECT * FROM Meseros WHERE id_empleado=109;

DELETE FROM Empleados WHERE id_empleado=109;

SELECT * FROM Meseros WHERE id_empleado=109;

--3--
INSERT INTO Ingredientes(id_ingrediente, nombre, Fecha_vencimiento)
VALUES(00099, 'Azúcar', '2030-07-17');

INSERT INTO Inventarios(id_ingrediente, cantidad_disponible)
VALUES(00099, 150);

SELECT * FROM Inventarios WHERE id_ingrediente=00099;

DELETE FROM Ingredientes WHERE id_ingrediente=00099;

SELECT * FROM Inventarios WHERE id_ingrediente=00099;

-- DisparadoresOK
INSERT INTO Empleados (nombre, salario)
VALUES ('Camila Rojas', 1700000.00);

INSERT INTO Cocineros (id_empleado, Especialidad)
VALUES ((SELECT id_empleado FROM Empleados WHERE nombre = 'Camila Rojas'), 'Pastelería');

SELECT * FROM Cocineros;

SELECT * FROM Inventarios WHERE id_ingrediente = 3;

UPDATE Compras SET Fecha_recepcion = '2026-09-22' WHERE id_compra = 3;

SELECT * FROM Inventarios WHERE id_ingrediente = 3;

SELECT * FROM Movimientos_inventario WHERE id_ingrediente = 3;

SELECT * FROM Inventarios WHERE id_ingrediente = 1;

INSERT INTO Movimientos_inventario (fecha, tipo_movimiento, cantidad, id_ingrediente, origen)
VALUES ('2026-10-01', 'Salida', 8, 1, 'Venta');

SELECT * FROM Movimientos_inventario WHERE id_ingrediente = 1;

SELECT * FROM Inventarios WHERE id_ingrediente = 1;

INSERT INTO Empleados (nombre, salario)
VALUES ('Ricardo Pineda', 1550000.00);

INSERT INTO Meseros (id_empleado, turno)
VALUES ((SELECT id_empleado FROM Empleados WHERE nombre = 'Ricardo Pineda'), 'Noche');

SELECT * FROM Meseros;

-- Disparador 6: se venden 2 Ajiacos (receta: 0.30 kg pollo, 0.40 kg papa, 1 mazorca, 0.01 kg cilantro)
-- y el inventario de esos 4 ingredientes baja solo
SELECT * FROM Inventarios WHERE id_ingrediente IN (2, 4, 11, 12) ORDER BY id_ingrediente;

INSERT INTO Ventas (fecha_venta, id_mesero)
VALUES ('2026-10-02', 2);

INSERT INTO Detalles_venta (cantidad, precio_unitario, id_venta, id_plato)
VALUES (2, 18000.00, (SELECT MAX(id_venta) FROM Ventas), 2);

SELECT * FROM Movimientos_inventario WHERE id_detalle_venta = (SELECT MAX(id_detalle_venta) FROM Detalles_venta);

-- Disparador 8: el total de la venta quedó en 2 x 18000 = 36000
SELECT * FROM Ventas WHERE id_venta = (SELECT MAX(id_venta) FROM Ventas);

SELECT * FROM Inventarios WHERE id_ingrediente IN (2, 4, 11, 12) ORDER BY id_ingrediente;

-- Disparador 7: se botan 1.5 kg de papa criolla y el inventario baja solo
INSERT INTO Desperdicios (fecha, cantidad, id_ingrediente, id_empleado, id_causa)
VALUES ('2026-10-03', 1.5, 2, 1, 1);

SELECT * FROM Movimientos_inventario WHERE id_desperdicio = (SELECT MAX(id_desperdicio) FROM Desperdicios);

SELECT * FROM Inventarios WHERE id_ingrediente = 2;

-- DisparadoresNoOK
-- INSERT INTO Cocineros (id_empleado, Especialidad)
-- VALUES (2, 'Postres');

-- UPDATE Cocineros SET id_empleado = 4 WHERE id_empleado = 1;

-- UPDATE Inventarios SET cantidad_disponible = 0 WHERE id_ingrediente = 4;
-- INSERT INTO Movimientos_inventario (fecha, tipo_movimiento, cantidad, id_ingrediente, origen)
-- VALUES ('2026-10-01', 'Salida', 1, 4, 'Venta');

-- INSERT INTO Movimientos_inventario (fecha, tipo_movimiento, cantidad, id_ingrediente, origen)
-- VALUES ('2026-10-01', 'Salida', 999, 5, 'Venta');

-- Venta de 100 Ajiacos: necesita 30 kg de pollo y no hay suficiente (disparadores 6 y 3)
-- INSERT INTO Ventas (fecha_venta, id_mesero)
-- VALUES ('2026-10-04', 2);
-- INSERT INTO Detalles_venta (cantidad, precio_unitario, id_venta, id_plato)
-- VALUES (100, 18000.00, (SELECT MAX(id_venta) FROM Ventas), 2);

-- Desperdicio mayor que lo que hay en inventario (disparadores 7 y 3)
-- INSERT INTO Desperdicios (fecha, cantidad, id_ingrediente, id_empleado, id_causa)
-- VALUES ('2026-10-04', 500, 3, 1, 1);

-- INSERT INTO Meseros (id_empleado, turno)
-- VALUES (1, 'Noche');

-- UPDATE Meseros SET id_empleado = 3 WHERE id_empleado = 2;

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

-- XComponentes
-- DROP SCHEMA IF EXISTS sv_entradas CASCADE;
-- DROP SCHEMA IF EXISTS sv_desperdicios CASCADE;

-- ComponentesOK
-- Caso 1: registrar una compra al proveedor 1
SELECT sv_entradas.adicionarCompra('2026-10-06', 1);

SELECT * FROM Compras WHERE id_compra = (SELECT MAX(id_compra) FROM Compras);

-- Caso 2: agregar dos ingredientes a esa compra
SELECT sv_entradas.adicionarDetalle((SELECT MAX(id_compra) FROM Compras), 3, 20, 140000.00);

SELECT sv_entradas.adicionarDetalle((SELECT MAX(id_compra) FROM Compras), 5, 10, 80000.00);

SELECT * FROM Detalles_compra WHERE id_compra = (SELECT MAX(id_compra) FROM Compras);

-- Caso 3: recibir la compra; el inventario de los ingredientes 3 y 5 sube solo
SELECT * FROM Inventarios WHERE id_ingrediente IN (3, 5) ORDER BY id_ingrediente;

SELECT sv_entradas.modificarRecepcion((SELECT MAX(id_compra) FROM Compras), '2026-10-08');

SELECT * FROM Inventarios WHERE id_ingrediente IN (3, 5) ORDER BY id_ingrediente;

SELECT * FROM Movimientos_inventario WHERE id_detalle_compra IN (SELECT id_detalle FROM Detalles_compra WHERE id_compra = (SELECT MAX(id_compra) FROM Compras));

-- Caso 4: consultar la compra
BEGIN;
SELECT sv_entradas.consultarCompra((SELECT MAX(id_compra) FROM Compras));
FETCH ALL FROM compra_cursor;
COMMIT;

-- Caso 5: eliminar una compra que todavía no se ha recibido
SELECT sv_entradas.adicionarCompra('2026-10-09', 2);

SELECT sv_entradas.adicionarDetalle((SELECT MAX(id_compra) FROM Compras), 4, 5, 40000.00);

SELECT sv_entradas.eliminarCompra((SELECT MAX(id_compra) FROM Compras));

SELECT * FROM Compras ORDER BY id_compra DESC LIMIT 2;

-- Caso 6: registrar un desperdicio de 1 kg del ingrediente 3; el inventario baja solo
SELECT * FROM Inventarios WHERE id_ingrediente = 3;

SELECT sv_desperdicios.adicionarDesperdicio('2026-10-10', 1.0, 3, 1, 2);

SELECT * FROM Desperdicios WHERE id_desperdicio = (SELECT MAX(id_desperdicio) FROM Desperdicios);

SELECT * FROM Inventarios WHERE id_ingrediente = 3;

-- Caso 7: cambiar la causa de ese desperdicio
SELECT sv_desperdicios.modificarCausa((SELECT MAX(id_desperdicio) FROM Desperdicios), 3);

BEGIN;
SELECT sv_desperdicios.consultarDesperdicio((SELECT MAX(id_desperdicio) FROM Desperdicios));
FETCH ALL FROM desperdicio_cursor;
COMMIT;

-- Caso 8: consultar los movimientos del ingrediente 3
BEGIN;
SELECT sv_desperdicios.consultarMovimientos(3);
FETCH ALL FROM movimientos_cursor;
COMMIT;

-- Caso 9: eliminar el desperdicio; el inventario vuelve a su valor y se borra su movimiento
SELECT sv_desperdicios.eliminarDesperdicio((SELECT MAX(id_desperdicio) FROM Desperdicios));

SELECT * FROM Inventarios WHERE id_ingrediente = 3;

-- ComponentesNoOK
-- [fk_compra_proveedor] compra a un proveedor que no existe
-- SELECT sv_entradas.adicionarCompra('2026-10-06', 999);

-- [uq_detalle_compra_ingrediente] el ingrediente 1 ya está en la compra 1
-- SELECT sv_entradas.adicionarDetalle(1, 1, 5, 30000.00);

-- [ck_detalle_cantidad] cantidad cero en el detalle
-- SELECT sv_entradas.adicionarDetalle(1, 2, 0, 30000.00);

-- [ck_compra_fechas] recepción antes de la fecha de compra
-- SELECT sv_entradas.modificarRecepcion(1, '2000-01-01');

-- [fk_movimiento_detalle_compra] la compra 3 ya se recibió y tiene movimientos de inventario
-- SELECT sv_entradas.eliminarCompra(3);

-- [fk_desperdicio_causa] desperdicio con una causa que no existe
-- SELECT sv_desperdicios.adicionarDesperdicio('2026-10-10', 1.0, 3, 1, 999);

-- [ck_desperdicio_cantidad] desperdicio de cantidad cero
-- SELECT sv_desperdicios.adicionarDesperdicio('2026-10-10', 0, 3, 1, 2);

-- [fk_desperdicio_causa] cambiar la causa por una que no existe
-- SELECT sv_desperdicios.modificarCausa(1, 999);

-- [disparador 3] desperdicio de 999 unidades: no alcanza el inventario
-- SELECT sv_desperdicios.adicionarDesperdicio('2026-10-10', 999, 5, 1, 2);

-- Poblar masivo 
ALTER TABLE Ventas DISABLE TRIGGER USER;
ALTER TABLE Detalles_venta DISABLE TRIGGER USER;
ALTER TABLE Compras DISABLE TRIGGER USER;
ALTER TABLE Detalles_compra DISABLE TRIGGER USER;
ALTER TABLE Desperdicios DISABLE TRIGGER USER;

-- Último id de venta y de compra que hay antes de insertar
CREATE TEMP TABLE limites AS
SELECT (SELECT COALESCE(MAX(id_venta), 0) FROM Ventas) AS ultima_venta,
(SELECT COALESCE(MAX(id_compra), 0) FROM Compras) AS ultima_compra;

-- 150 ventas, cada una atendida por un mesero distinto en rotación
INSERT INTO Ventas (fecha_venta, total, id_mesero)
SELECT
    DATE '2026-07-01' + (i * 7) % 96,
    0,
    (SELECT id_empleado FROM Meseros ORDER BY id_empleado OFFSET i % (SELECT COUNT(*) FROM Meseros) LIMIT 1)
FROM generate_series(1, 150) AS i;

-- 3 platos distintos por venta (450 detalles)
INSERT INTO Detalles_venta (cantidad, precio_unitario, id_venta, id_plato)
SELECT
    1 + (v.id_venta + k) % 3,
    15000.00 + ((v.id_venta + k) % 5) * 3000,
    v.id_venta,
    1 + (v.id_venta + k * 4) % 15
FROM Ventas v, generate_series(0, 2) AS k
WHERE v.id_venta > (SELECT ultima_venta FROM limites);

-- El total de cada venta nueva es la suma de sus detalles
UPDATE Ventas
SET total = (SELECT SUM(d.cantidad * d.precio_unitario)
FROM Detalles_venta d
WHERE d.id_venta = Ventas.id_venta)
WHERE id_venta > (SELECT ultima_venta FROM limites);

-- 60 compras, recibidas entre 1 y 5 días después
INSERT INTO Compras (Fecha_compra, Fecha_recepcion, id_proveedor)
SELECT
    DATE '2026-07-01' + (i * 5) % 96,
    DATE '2026-07-01' + (i * 5) % 96 + 1 + i % 5,
    (SELECT id_proveedor FROM Proveedores ORDER BY id_proveedor OFFSET i % (SELECT COUNT(*) FROM Proveedores) LIMIT 1)
FROM generate_series(1, 60) AS i;

-- 3 ingredientes distintos por compra (180 detalles)
INSERT INTO Detalles_compra (cantidad, Total, id_compra, id_ingrediente)
SELECT
    10 + (c.id_compra + k) % 11,
    (10 + (c.id_compra + k) % 11) * 7000.00,
    c.id_compra,
    1 + (c.id_compra + k * 4) % 15
FROM Compras c, generate_series(0, 2) AS k
WHERE c.id_compra > (SELECT ultima_compra FROM limites);

-- 100 desperdicios
INSERT INTO Desperdicios (fecha, cantidad, id_ingrediente, id_empleado, id_causa)
SELECT
    DATE '2026-07-01' + (i * 3) % 96,
    0.5 + (i % 6) * 0.5,
    1 + i % 15,
    1 + i % 30,
    1 + i % 15
FROM generate_series(1, 100) AS i;

DROP TABLE limites;

ALTER TABLE Ventas ENABLE TRIGGER USER;
ALTER TABLE Detalles_venta ENABLE TRIGGER USER;
ALTER TABLE Compras ENABLE TRIGGER USER;
ALTER TABLE Detalles_compra ENABLE TRIGGER USER;
ALTER TABLE Desperdicios ENABLE TRIGGER USER;

select i.nombre 


select * from platos;
select * from detalles_venta;