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
