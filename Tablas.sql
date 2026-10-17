CREATE TABLE Proveedores (
    id_provedor   INT AUTO_INCREMENT PRIMARY KEY,
    nombre        VARCHAR(100) NOT NULL,
    telefono      INT,
    correo        VARCHAR(50)
);

CREATE TABLE Empleados (
    id_empleado   INT AUTO_INCREMENT PRIMARY KEY,
    nombre        VARCHAR(100) NOT NULL,
    salario       DECIMAL(10,2) NOT NULL
);

CREATE TABLE Causas_desperdicio (
    id_causa      INT AUTO_INCREMENT PRIMARY KEY,
    descripcion   VARCHAR(200) NOT NULL
);

CREATE TABLE Ingredientes (
    id_ingrediente     INT AUTO_INCREMENT PRIMARY KEY,
    Fecha_vencimiento  DATE
);

CREATE TABLE Recetas (
    id_receta          INT AUTO_INCREMENT PRIMARY KEY,
    Nombre             VARCHAR(100) NOT NULL,
    tiempo_preparacion INT,              -- minutos
    Descripcion        VARCHAR(255),
    ingredientes       VARCHAR(255)      -- texto libre según el diagrama
);

CREATE TABLE Cocineros (
    id_empleado   INT PRIMARY KEY,
    Especialidad  VARCHAR(50)
);

CREATE TABLE Meseros (
    id_empleado   INT PRIMARY KEY,
    turno         VARCHAR(20)
);

CREATE TABLE Inventarios (
    id_ingrediente      INT PRIMARY KEY,
    cantidad            INT NOT NULL DEFAULT 0
);

CREATE TABLE Movimientos_inventario (
    id_movimiento   INT AUTO_INCREMENT PRIMARY KEY,
    fecha           DATE NOT NULL,
    tipo_movimiento VARCHAR(20) NOT NULL,   -- p.ej. 'Entrada' / 'Salida'
    id_ingrediente  INT NOT NULL
);

CREATE TABLE Compras (
    id_compra        INT AUTO_INCREMENT PRIMARY KEY,
    Fecha_compra     DATE NOT NULL,
    Fecha_recepcion  DATE,
    id_proveedor     INT NOT NULL
);

CREATE TABLE Detalles_compra (
    id_detalle      INT AUTO_INCREMENT PRIMARY KEY,
    cantidad        INT NOT NULL,
    Total           DECIMAL(10,2) NOT NULL,
    id_compra       INT NOT NULL,
    id_ingrediente  INT NOT NULL
);

CREATE TABLE Platos (
    id_plato           INT AUTO_INCREMENT PRIMARY KEY,
    nombre             VARCHAR(100) NOT NULL,
    tiempo_preparacion INT,           -- minutos
    id_receta          INT
);

CREATE TABLE Ventas (
    id_venta      INT AUTO_INCREMENT PRIMARY KEY,
    fecha_venta   DATE NOT NULL,
    precio        DECIMAL(10,2) NOT NULL,
    id_plato      INT NOT NULL
);

CREATE TABLE Desperdicios (
    id_desperdicio              INT AUTO_INCREMENT PRIMARY KEY,
    fecha                       DATE NOT NULL,
    ingredientes_desperdiciados VARCHAR(255),
    id_ingrediente              INT NOT NULL,
    id_empleado                 INT NOT NULL,
    id_causa                    INT NOT NULL
);

