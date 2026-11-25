

CREATE TABLE Producciones(
    id_produccion SERIAL,
    codigo_lote VARCHAR(10) NOT NULL,
    fecha DATE NOT NULL,
    turno VARCHAR(20) NOT NULL ,
    estado VARCHAR(20) NOT NULL DEFAULT 'Planeada',
    id_plato INTEGER NOT NULL,
    id_cocinero INTEGER NOT NULL,
    porciones_preparadas INTEGER NOT NULL,
    porciones_sobrantes INTEGER NOT NULL default 0
);

ALTER TABLE producciones ADD CONSTRAINT pk_producciones PRIMARY KEY (id_produccion);
ALTER TABLE producciones ADD CONSTRAINT uq_produccion_lote UNIQUE (codigo_lote);
ALTER TABLE Producciones ADD CONSTRAINT ck_produccion_lote CHECK (LENGTH(codigo_lote) = 10);
ALTER TABLE producciones ADD CONSTRAINT ck_producciones_turno CHECK (turno IN ('Mañana','Tarde','Noche'));
ALTER TABLE producciones ADD CONSTRAINT ck_producciones_estado CHECK (estado IN ('Planeada','En preparación','Terminada','Cancelada'));
ALTER TABLE producciones ADD CONSTRAINT ck_producciones_porcionesprep CHECK(porciones_preparadas BETWEEN 1 AND 200);
ALTER TABLE Producciones ADD CONSTRAINT uq_produccion_plato_fecha_turno UNIQUE (id_plato, fecha, turno);
ALTER TABLE Producciones ADD CONSTRAINT ck_produccion_sobrantes CHECK (porciones_sobrantes >= 0 AND porciones_sobrantes <= porciones_preparadas);
ALTER TABLE Producciones ADD CONSTRAINT ck_produccion_sobrante_terminada CHECK (estado = 'Terminada' OR porciones_sobrantes = 0);
ALTER TABLE Producciones ADD CONSTRAINT fk_produccion_plato FOREIGN KEY (id_plato) REFERENCES Platos(id_plato) ON DELETE CASCADE;
ALTER TABLE Producciones ADD CONSTRAINT fk_produccion_cocinero FOREIGN KEY (id_cocinero) REFERENCES Cocineros(id_empleado) ON DELETE RESTRICT;

INSERT INTO Producciones (codigo_lote, fecha, turno, estado, id_plato, id_cocinero, porciones_preparadas, porciones_sobrantes) VALUES
('LOTE000001', '2026-09-01', 'Tarde',  'Terminada',      1, 1, 50, 10),
('LOTE000002', '2026-09-01', 'Mañana', 'Terminada',      2, 5, 40,  3),
('LOTE000003', '2026-09-02', 'Noche',  'Terminada',      4, 3, 30,  9),
('LOTE000004', '2026-09-03', 'Mañana', 'En preparación', 5, 6, 60,  0),
('LOTE000005', '2026-09-03', 'Tarde',  'Cancelada',      7, 7, 25,  0);

INSERT INTO Producciones (codigo_lote, fecha, turno, estado, id_plato, id_cocinero, porciones_preparadas, porciones_sobrantes) VALUES
('LOTE000006', '2026-09-08', 'Tarde',  'Terminada',      1,  3,  60,  9),
('LOTE000007', '2026-08-10', 'Mañana', 'Terminada',      1,  5,  40,  2),
('LOTE000008', '2026-09-15', 'Mañana', 'Terminada',      2,  5,  50,  4),
('LOTE000009', '2026-09-09', 'Noche',  'Terminada',      4,  3,  40, 12),
('LOTE000010', '2026-08-05', 'Tarde',  'Terminada',      3,  6,  80, 20),
('LOTE000011', '2026-08-19', 'Tarde',  'Terminada',      3,  6,  70, 14),
('LOTE000012', '2026-09-10', 'Mañana', 'Terminada',      5,  7, 100, 15),
('LOTE000013', '2026-07-20', 'Noche',  'Terminada',      7,  7,  45, 12),
('LOTE000014', '2026-10-01', 'Noche',  'Terminada',      9,  8,  35, 10),
('LOTE000015', '2026-10-02', 'Tarde',  'Planeada',       6,  9,  50,  0),
('LOTE000016', '2026-10-03', 'Mañana', 'Cancelada',      8, 10,  30,  0),
('LOTE000017', '2026-10-04', 'Tarde',  'En preparación', 10, 11, 40,  0),
('LOTE000018', '2026-09-20', 'Noche',  'Terminada',      11, 12, 60,  3),
('LOTE000019', '2026-09-25', 'Mañana', 'Terminada',      12, 13, 80, 10),
('LOTE000020', '2026-09-12', 'Tarde',  'Terminada',      13, 14, 55, 11);

-- uq_produccion_lote
-- INSERT INTO Producciones (codigo_lote, fecha, turno, id_plato, id_cocinero, porciones_preparadas)
-- VALUES ('LOTE000001', '2026-09-02', 'Noche', 2, 1, 40);

-- ck_produccion_lote
-- INSERT INTO Producciones (codigo_lote, fecha, turno, id_plato, id_cocinero, porciones_preparadas)
-- VALUES ('LOTE00002', '2026-09-02', 'Noche', 2, 1, 40);

-- ck_producciones_turno
-- INSERT INTO Producciones (codigo_lote, fecha, turno, id_plato, id_cocinero, porciones_preparadas)
-- VALUES ('LOTE000099', '2026-09-02', 'Madrugada', 2, 1, 40);

-- ck_producciones_estado
-- INSERT INTO Producciones (codigo_lote, fecha, turno, estado, id_plato, id_cocinero, porciones_preparadas)
-- VALUES ('LOTE000099', '2026-09-02', 'Noche', 'Pausada', 2, 1, 40);

-- ck_producciones_porcionesprep
-- INSERT INTO Producciones (codigo_lote, fecha, turno, id_plato, id_cocinero, porciones_preparadas)
-- VALUES ('LOTE000099', '2026-09-02', 'Noche', 2, 1, 0);

-- ck_producciones_porcionesprep
-- INSERT INTO Producciones (codigo_lote, fecha, turno, id_plato, id_cocinero, porciones_preparadas)
-- VALUES ('LOTE000099', '2026-09-02', 'Noche', 2, 1, 201);

-- ck_produccion_sobrantes
-- INSERT INTO Producciones (codigo_lote, fecha, turno, estado, id_plato, id_cocinero, porciones_preparadas, porciones_sobrantes)
-- VALUES ('LOTE000099', '2026-09-02', 'Noche', 'Terminada', 2, 1, 40, 41);

-- ck_produccion_sobrante_terminada
-- INSERT INTO Producciones (codigo_lote, fecha, turno, estado, id_plato, id_cocinero, porciones_preparadas, porciones_sobrantes)
-- VALUES ('LOTE000099', '2026-09-02', 'Noche', 'Planeada', 2, 1, 40, 5);

-- uq_produccion_plato_fecha_turno
-- INSERT INTO Producciones (codigo_lote, fecha, turno, id_plato, id_cocinero, porciones_preparadas)
-- VALUES ('LOTE000099', '2026-09-01', 'Tarde', 1, 3, 40);

-- fk_produccion_cocinero
-- INSERT INTO Producciones (codigo_lote, fecha, turno, id_plato, id_cocinero, porciones_preparadas)
-- VALUES ('LOTE000099', '2026-09-02', 'Noche', 2, 2, 40);

-- fk_produccion_plato
-- INSERT INTO Producciones (codigo_lote, fecha, turno, id_plato, id_cocinero, porciones_preparadas)
-- VALUES ('LOTE000099', '2026-09-02', 'Noche', 999, 1, 40);

-- ck_produccion_sobrantes
-- UPDATE Producciones SET porciones_sobrantes = 60 WHERE codigo_lote = 'LOTE000001';

-- fk_produccion_cocinero
-- DELETE FROM Cocineros WHERE id_empleado = 1;


--Consulta Gerencial
SELECT p.nombre AS plato,pr.turno,COUNT(*) AS producciones,SUM(pr.porciones_preparadas) AS porciones_preparadas,SUM(pr.porciones_sobrantes) AS porciones_sobrantes, ROUND(100.0 * SUM(pr.porciones_sobrantes) / SUM(pr.porciones_preparadas), 1) AS porcentaje_sobrante,SUM(pr.porciones_sobrantes) * mp.precio AS valor_sobrante
FROM Producciones pr
JOIN Platos p        ON p.id_plato = pr.id_plato
JOIN Menus_platos mp ON mp.id_plato = p.id_plato
JOIN Menus m         ON m.id_menu = mp.id_menu AND m.activo = TRUE
WHERE pr.estado = 'Terminada'
GROUP BY p.nombre, pr.turno, mp.precio
HAVING 100.0 * SUM(pr.porciones_sobrantes) / SUM(pr.porciones_preparadas) >= 10
ORDER BY valor_sobrante DESC;




-- SEGURIDAD 


-- VISTA OPERATIVA (COCINERO): detalle de las producciones
CREATE OR REPLACE VIEW vw_produccion_detalle AS
SELECT pr.id_produccion,pr.codigo_lote,pr.fecha,pr.turno,pr.estado,p.id_plato,p.nombre AS plato,e.id_empleado AS id_cocinero,e.nombre AS cocinero,pr.porciones_preparadas,pr.porciones_sobrantes
FROM Producciones pr
JOIN Platos p ON p.id_plato = pr.id_plato
JOIN Empleados e ON e.id_empleado = pr.id_cocinero;

-- VISTA GERENCIAL (GERENTE): sobreproduccion por plato y turno
-- Solo producciones terminadas; valor del sobrante al precio de la carta vigente
CREATE OR REPLACE VIEW vw_sobreproduccion_turno AS
SELECT p.id_plato,p.nombre AS plato,pr.turno,COUNT(*) AS producciones, SUM(pr.porciones_preparadas) AS porciones_preparadas,SUM(pr.porciones_sobrantes) AS porciones_sobrantes,ROUND(100.0 * SUM(pr.porciones_sobrantes) / SUM(pr.porciones_preparadas), 1) AS porcentaje_sobrante,SUM(pr.porciones_sobrantes) * mp.precio AS valor_sobrante
FROM Producciones pr
JOIN Platos p ON p.id_plato = pr.id_plato
JOIN Menus_platos mp ON mp.id_plato = p.id_plato
JOIN Menus m ON m.id_menu = mp.id_menu AND m.activo = TRUE
WHERE pr.estado = 'Terminada'
GROUP BY p.id_plato, p.nombre, pr.turno, mp.precio;

-- VISTA OPERATIVA (INVENTARIO): ingredientes por debajo del stock minimo
CREATE OR REPLACE VIEW vw_inventario_bajo AS
SELECT i.id_ingrediente,i.nombre,i.unidad_medida,i.stock_minimo,inv.cantidad_disponible,i.stock_minimo - inv.cantidad_disponible AS faltante
FROM Ingredientes i
JOIN Inventarios inv ON inv.id_ingrediente = i.id_ingrediente
WHERE inv.cantidad_disponible < i.stock_minimo;

INSERT INTO Desperdicios (fecha, cantidad, id_ingrediente, id_empleado, id_causa) VALUES
('2026-10-20', 20, 2, 1, 1),
('2026-10-20',  6, 4, 1, 1),
('2026-10-20', 30, 7, 1, 1);


-- CONSULTAS SOBRE LAS VISTAS

select codigo_lote, fecha, turno, estado, plato, cocinero, porciones_preparadas, porciones_sobrantes
from vw_produccion_detalle
where fecha = date '2026-09-01'
order by turno, plato;

select * from vw_inventario_bajo order by faltante desc limit 5;

select plato, turno, producciones, porciones_preparadas, porciones_sobrantes, porcentaje_sobrante, valor_sobrante
from vw_sobreproduccion_turno
where porcentaje_sobrante >= 10
order by valor_sobrante desc;

select count(*) as combinaciones_plato_turno,count(*) filter (where porcentaje_sobrante >= 10) as con_sobrante_de_10_o_mas,sum(valor_sobrante) filter (where porcentaje_sobrante >= 10) as valor_total_sobrante
from vw_sobreproduccion_turno;


-- ACTORES (SERVICIOS), ROLES Y PERMISOS


-- COCINERO: servicios de produccion
CREATE SCHEMA sv_produccion;

-- Registrar una produccion (queda Planeada, sin sobrantes)
CREATE FUNCTION sv_produccion.adicionarProduccion(p_codigo_lote VARCHAR, p_fecha DATE, p_turno VARCHAR,p_id_plato INT, p_id_cocinero INT, p_porciones INT)
RETURNS VOID AS $$
BEGIN
    INSERT INTO Producciones (codigo_lote, fecha, turno, id_plato, id_cocinero, porciones_preparadas)
    VALUES (p_codigo_lote, p_fecha, p_turno, p_id_plato, p_id_cocinero, p_porciones);
END;
$$ LANGUAGE plpgsql;

-- Cambiar el estado de una produccion
CREATE FUNCTION sv_produccion.modificarEstado(p_codigo_lote VARCHAR, p_estado VARCHAR)
RETURNS VOID AS $$
BEGIN
    UPDATE Producciones SET estado = p_estado WHERE codigo_lote = p_codigo_lote;
END;
$$ LANGUAGE plpgsql;

-- Reportar los sobrantes al cierre (solo si la produccion esta Terminada)
CREATE FUNCTION sv_produccion.modificarSobrantes(p_codigo_lote VARCHAR, p_sobrantes INT)
RETURNS VOID AS $$
BEGIN
    UPDATE Producciones SET porciones_sobrantes = p_sobrantes WHERE codigo_lote = p_codigo_lote;
END;
$$ LANGUAGE plpgsql;

-- Consultar las producciones de una fecha
CREATE FUNCTION sv_produccion.consultarProduccion(p_fecha DATE)
RETURNS REFCURSOR AS $$
DECLARE
    v_cursor REFCURSOR := 'produccion_cursor';
BEGIN
    OPEN v_cursor FOR
        SELECT * FROM vw_produccion_detalle WHERE fecha = p_fecha ORDER BY turno, plato;
    RETURN v_cursor;
END;
$$ LANGUAGE plpgsql;

-- GERENTE: analizar la sobreproduccion por plato y turno
CREATE SCHEMA sv_gerente;

CREATE FUNCTION sv_gerente.analizarSobreproduccion(p_min_porcentaje DECIMAL DEFAULT 10)
RETURNS REFCURSOR AS $$
DECLARE
    v_cursor REFCURSOR := 'sobreproduccion_cursor';
BEGIN
    OPEN v_cursor FOR
        SELECT plato, turno, producciones, porciones_preparadas, porciones_sobrantes,porcentaje_sobrante, valor_sobrante
        FROM vw_sobreproduccion_turno
        WHERE porcentaje_sobrante >= p_min_porcentaje
        ORDER BY valor_sobrante DESC;
    RETURN v_cursor;
END;
$$ LANGUAGE plpgsql;

-- INVENTARIO: consultar ingredientes por debajo del stock minimo
CREATE SCHEMA sv_inventario;

CREATE FUNCTION sv_inventario.consultarInventarioBajo()
RETURNS REFCURSOR AS $$
DECLARE
    v_cursor REFCURSOR := 'inventario_bajo_cursor';
BEGIN
    OPEN v_cursor FOR SELECT * FROM vw_inventario_bajo ORDER BY faltante DESC;
    RETURN v_cursor;
END;
$$ LANGUAGE plpgsql;

-- Roles
CREATE ROLE rol_cocinero;
CREATE ROLE rol_gerente;
CREATE ROLE rol_inventario;

-- Cada rol solo entra al esquema de los servicios de su actor
GRANT USAGE ON SCHEMA sv_produccion TO rol_cocinero;
GRANT USAGE ON SCHEMA sv_gerente TO rol_gerente;
GRANT USAGE ON SCHEMA sv_inventario, sv_entradas, sv_desperdicios TO rol_inventario;

GRANT EXECUTE ON ALL FUNCTIONS IN SCHEMA sv_produccion TO rol_cocinero;
GRANT EXECUTE ON ALL FUNCTIONS IN SCHEMA sv_gerente TO rol_gerente;
GRANT EXECUTE ON ALL FUNCTIONS IN SCHEMA sv_inventario TO rol_inventario;
GRANT EXECUTE ON ALL FUNCTIONS IN SCHEMA sv_entradas TO rol_inventario;
GRANT EXECUTE ON ALL FUNCTIONS IN SCHEMA sv_desperdicios TO rol_inventario;

-- Las funciones corren con los privilegios de quien las invoca
-- Cocinero: registra y actualiza producciones (no puede borrarlas)
GRANT SELECT, INSERT ON Producciones TO rol_cocinero;
GRANT UPDATE (estado, porciones_sobrantes) ON Producciones TO rol_cocinero;
GRANT USAGE ON SEQUENCE producciones_id_produccion_seq TO rol_cocinero;
GRANT SELECT ON vw_produccion_detalle TO rol_cocinero;

-- Gerente: solo lee la vista gerencial
GRANT SELECT ON vw_sobreproduccion_turno TO rol_gerente;

-- Inventario: compras, recepcion, desperdicios e inventario
GRANT SELECT ON vw_inventario_bajo TO rol_inventario;
GRANT SELECT ON Proveedores, Ingredientes, Empleados, Causas_desperdicio TO rol_inventario;
GRANT SELECT, INSERT, UPDATE, DELETE ON Compras, Detalles_compra TO rol_inventario;
GRANT SELECT, INSERT, UPDATE ON Inventarios, Movimientos_inventario, Desperdicios TO rol_inventario;
GRANT DELETE ON Desperdicios TO rol_inventario;
GRANT USAGE ON SEQUENCE compras_id_compra_seq, detalles_compra_id_detalle_seq,desperdicios_id_desperdicio_seq, movimientos_inventario_id_movimiento_seq
TO rol_inventario;


-- SEGURIDADOK : uso correcto de los servicios de los actores


-- ---- COCINERO ----
set role rol_cocinero;

select sv_produccion.adicionarProduccion('LOTE880001', date '2027-04-01', 'Tarde', 1, 1, 60);
select sv_produccion.modificarEstado('LOTE880001', 'Terminada');
select sv_produccion.modificarSobrantes('LOTE880001', 12);

begin;
select sv_produccion.consultarProduccion(date '2027-04-01');
fetch all in produccion_cursor;
commit;

reset role;

-- ---- GERENTE ----
set role rol_gerente;

begin;
select sv_gerente.analizarSobreproduccion(10);
fetch 3 in sobreproduccion_cursor;
commit;

reset role;

-- ---- INVENTARIO (servicios de inventario, entradas y desperdicios) ----
set role rol_inventario;

begin;
select sv_inventario.consultarInventarioBajo();
fetch all in inventario_bajo_cursor;
commit;

select sv_entradas.adicionarCompra(current_date, 1);
select sv_entradas.adicionarDetalle((select max(id_compra) from compras), 1, 5, 25000);

begin;
select sv_entradas.consultarCompra((select max(id_compra) from compras));
fetch all in compra_cursor;
commit;

select sv_entradas.modificarRecepcion((select max(id_compra) from compras), current_date);
select sv_desperdicios.adicionarDesperdicio(current_date, 0.5, 1, 1, 1);

reset role;


-- SEGURIDADNOOK (cada intento debe dar ERROR)

-- 1. El cocinero intenta analizar la sobreproduccion (servicio del gerente)
-- set role rol_cocinero;
-- select sv_gerente.analizarSobreproduccion(10);
-- reset role;
-- ERROR esperado: permission denied for schema sv_gerente

-- 2. El cocinero intenta registrar una compra (servicio de inventario)
-- set role rol_cocinero;
-- select sv_entradas.adicionarCompra(current_date, 1);
-- reset role;
-- ERROR esperado: permission denied for schema sv_entradas

-- 3. El cocinero intenta borrar producciones (solo puede registrar y actualizar)
-- set role rol_cocinero;
-- delete from producciones where codigo_lote = 'LOTE880001';
-- reset role;
-- ERROR esperado: permission denied for table producciones

-- 4. El cocinero intenta cambiar las porciones preparadas (solo puede cambiar estado y sobrantes)
-- set role rol_cocinero;
-- update producciones set porciones_preparadas = 1 where codigo_lote = 'LOTE880001';
-- reset role;
-- ERROR esperado: permission denied for table producciones

-- 5. El gerente intenta registrar una produccion (servicio del cocinero)
-- set role rol_gerente;
-- select sv_produccion.adicionarProduccion('LOTE880002', date '2027-04-02', 'Noche', 2, 1, 30);
-- reset role;
-- ERROR esperado: permission denied for schema sv_produccion

-- 6. El gerente intenta leer la tabla de producciones directamente
-- set role rol_gerente;
-- select * from producciones;
-- reset role;
-- ERROR esperado: permission denied for table producciones

-- 7. Inventario intenta usar un servicio del gerente
-- set role rol_inventario;
-- select sv_gerente.analizarSobreproduccion(10);
-- reset role;
-- ERROR esperado: permission denied for schema sv_gerente

-- 8. Inventario intenta cambiar el estado de una produccion (servicio del cocinero)
-- set role rol_inventario;
-- select sv_produccion.modificarEstado('LOTE880001', 'Cancelada');
-- reset role;
-- ERROR esperado: permission denied for schema sv_produccion

-- 9. Servicio autorizado, dato invalido: un mesero (empleado 2) como responsable
-- set role rol_cocinero;
-- select sv_produccion.adicionarProduccion('LOTE880003', date '2027-04-03', 'Noche', 2, 2, 30);
-- reset role;
-- ERROR esperado: viola la llave foranea fk_produccion_cocinero

-- 10. Servicio autorizado, dato invalido: sobrantes en una produccion que no esta Terminada
-- set role rol_cocinero;
-- select sv_produccion.adicionarProduccion('LOTE880004', date '2027-04-04', 'Tarde', 3, 1, 30);
-- select sv_produccion.modificarSobrantes('LOTE880004', 5);
-- reset role;
-- ERROR esperado: viola ck_produccion_sobrante_terminada


--delete from producciones where codigo_lote like 'LOTE88%';

-- XVISTAS
--drop view if exists vw_sobreproduccion_turno;
--drop view if exists vw_produccion_detalle;
--drop view if exists vw_inventario_bajo;

-- XSEGURIDAD : eliminacion de servicios de actores, roles y permisos
--drop schema if exists sv_produccion cascade;
--drop schema if exists sv_gerente cascade;
--drop schema if exists sv_inventario cascade;
--drop schema if exists sv_entradas cascade;
--drop schema if exists sv_desperdicios cascade;

--drop owned by rol_cocinero, rol_gerente, rol_inventario;
--drop role if exists rol_cocinero;
--drop role if exists rol_gerente;
--drop role if exists rol_inventario;
