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

-- XINDICESVISTAS
--drop view if exists vw_sobreproduccion_turno;
--drop view if exists vw_produccion_detalle;
--drop view if exists vw_inventario_bajo;

--drop index if exists idx_produccion_cocinero;
--drop index if exists idx_detalle_venta_plato;
--drop index if exists idx_detalle_venta_venta;
--drop index if exists idx_venta_mesero;
--drop index if exists idx_compra_proveedor;
--drop index if exists idx_detalle_compra_compra;
--drop index if exists idx_desperdicio_ingrediente;
--drop index if exists idx_movimiento_ingrediente;
--drop index if exists idx_produccion_terminada;
--drop index if exists idx_produccion_fecha;
--drop index if exists idx_menu_activo;

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
