CREATE TABLE Inspecciones (
    id_inspeccion SERIAL,
    codigo VARCHAR(8) NOT NULL,
    fecha_inspeccion DATE NOT NULL,
    resultado VARCHAR(15) NOT NULL,
    cantidad_rechazada DECIMAL(10,2) NOT NULL DEFAULT 0,
    observaciones VARCHAR(200),
    id_detalle_compra INT NOT NULL,
    id_cocinero INT NOT NULL,
    id_causa INT
);


ALTER TABLE Inspecciones
ADD CONSTRAINT ck_inspeccion_codigo CHECK (codigo LIKE 'INS____');

ALTER TABLE Inspecciones
ADD CONSTRAINT ck_inspeccion_resultado
CHECK (resultado IN ('Aprobado','Rechazo parcial','Rechazo total'));

ALTER TABLE Inspecciones
ADD CONSTRAINT ck_inspeccion_cantidad CHECK (cantidad_rechazada >= 0 );

ALTER TABLE Inspecciones
ADD CONSTRAINT ck_inspeccion_rechazo
CHECK (
    (resultado = 'Aprobado' AND cantidad_rechazada = 0 AND id_causa IS NULL)
    OR (resultado IN ('Rechazo parcial','Rechazo total') AND cantidad_rechazada > 0 AND id_causa IS NOT NULL)
);

--Primarias

ALTER TABLE Inspecciones
ADD CONSTRAINT pk_inspecciones PRIMARY KEY (id_inspeccion);

--Unicas

ALTER TABLE 
ADD CONSTRAINT uq_inspeccion_codigo UNIQUE (codigo);

ALTER TABLE Inspecciones
ADD CONSTRAINT uq_inspeccion_detalle UNIQUE (id_detalle_compra);

--Foraneas

ALTER TABLE Inspecciones
ADD CONSTRAINT fk_inspeccion_detalle_compra
FOREIGN KEY (id_detalle_compra) REFERENCES Detalles_compra(id_detalle)
ON DELETE CASCADE;

ALTER TABLE Inspecciones 
ADD CONSTRAINT fk_inspeccion_cocinero
FOREIGN KEY (id_cocinero) REFERENCES Cocineros(id_empleado)
ON DELETE RESTRICT;

ALTER TABLE Inspecciones 
ADD CONSTRAINT fk_inspeccion_causa
FOREIGN KEY (id_causa) REFERENCES Causas_desperdicio(id_causa)
ON DELETE RESTRICT;

-- XTABLA
-- DROP TABLE IF EXISTS Inspecciones;

--Disparadores 

CREATE OR REPLACE FUNCTION f_inspeccion_cantidad() RETURNS TRIGGER AS $$
DECLARE
    v_cantidad DECIMAL(10,2);
BEGIN
    SELECT cantidad INTO v_cantidad
    FROM Detalles_compra
    WHERE id_detalle = NEW.id_detalle_compra;

    IF NEW.cantidad_rechazada > v_cantidad THEN
        RAISE EXCEPTION 'No se puede rechazar % de una línea de compra que recibió solo %',
            NEW.cantidad_rechazada, v_cantidad;
    END IF;

    IF NEW.resultado = 'Rechazo parcial' AND NEW.cantidad_rechazada >= v_cantidad THEN
        RAISE EXCEPTION 'Un rechazo parcial debe ser menor que la cantidad recibida (%)', v_cantidad;
    END IF;

    IF NEW.resultado = 'Rechazo total' AND NEW.cantidad_rechazada <> v_cantidad THEN
        RAISE EXCEPTION 'Un rechazo total debe ser igual a la cantidad recibida (%)', v_cantidad;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER t_inspeccion_cantidad
BEFORE INSERT OR UPDATE ON Inspecciones
FOR EACH ROW EXECUTE FUNCTION f_inspeccion_cantidad();

--Poblar

INSERT INTO Detalles_compra (cantidad, Total, id_compra, id_ingrediente) VALUES
(12, 96000.00,  1, 2),   -- 16 (proveedor 1)
(8,  64000.00,  1, 4),   -- 17 (proveedor 1)
(25, 175000.00, 2, 5),   -- 18 (proveedor 2)
(6,  54000.00,  2, 3),   -- 19 (proveedor 2)
(30, 210000.00, 5, 1),   -- 20 (proveedor 3)
(14, 98000.00,  5, 2);   -- 21 (proveedor 3)

INSERT INTO Inspecciones
(codigo, fecha_inspeccion, resultado, cantidad_rechazada, observaciones, id_detalle_compra, id_cocinero, id_causa) VALUES
('INS-0001', '2026-09-17', 'Aprobado',        0,  NULL,                          1,  1,  NULL),
('INS-0002', '2026-09-17', 'Rechazo parcial', 3,  'Cajas con hielo derretido',   16, 1,  6),
('INS-0003', '2026-09-17', 'Rechazo parcial', 2,  'Bolsas rotas',                17, 3,  10),
('INS-0004', '2026-09-19', 'Rechazo total',   10, 'Papa con moho',               2,  3,  15),
('INS-0005', '2026-09-19', 'Rechazo parcial', 5,  'Lote cercano a vencer',       18, 5,  1),
('INS-0006', '2026-09-19', 'Aprobado',        0,  NULL,                          19, 5,  NULL),
('INS-0007', '2026-09-04', 'Rechazo parcial', 2,  'Temperatura fuera de rango',  4,  6,  6),
('INS-0008', '2026-09-04', 'Aprobado',        0,  NULL,                          5,  7,  NULL),
('INS-0009', '2026-09-04', 'Rechazo parcial', 4,  'Humedad en el almacenamiento',20, 7,  5),
('INS-0010', '2026-09-04', 'Aprobado',        0,  NULL,                          21, 8,  NULL),
('INS-0011', '2026-09-06', 'Aprobado',        0,  NULL,                          6,  8,  NULL),
('INS-0012', '2026-09-06', 'Rechazo total',   12, 'Plaga detectada en el lote',  7,  9,  11),
('INS-0013', '2026-09-08', 'Aprobado',        0,  NULL,                          8,  9,  NULL),
('INS-0014', '2026-09-08', 'Rechazo parcial', 3.5,'Empaque roto',                9,  10, 10),
('INS-0015', '2026-09-10', 'Aprobado',        0,  NULL,                          10, 10, NULL),
('INS-0016', '2026-09-10', 'Rechazo parcial', 4,  'Llegó en mal estado',         11, 11, 15),
('INS-0017', '2026-09-12', 'Aprobado',        0,  NULL,                          12, 11, NULL),
('INS-0018', '2026-09-12', 'Rechazo parcial', 1,  'Contacto con carne cruda',    13, 12, 4),
('INS-0019', '2026-09-14', 'Aprobado',        0,  NULL,                          14, 12, NULL),
('INS-0020', '2026-09-14', 'Rechazo total',   20, 'Cadena de frío rota',         15, 13, 6);


--consulta gerencial 

SELECT
    p.nombre                                              AS proveedor,
    COUNT(*)                                              AS lineas_inspeccionadas,
    SUM(CASE WHEN i.cantidad_rechazada > 0 THEN 1 ELSE 0 END) AS lineas_con_rechazo,
    SUM(d.cantidad)                                       AS cantidad_recibida,
    SUM(i.cantidad_rechazada)                             AS cantidad_rechazada,
    ROUND(SUM(i.cantidad_rechazada) * 100 / SUM(d.cantidad), 2) AS porcentaje_rechazado,
    ROUND(SUM(i.cantidad_rechazada * d.Total / d.cantidad), 2)  AS valor_rechazado
FROM Inspecciones i
JOIN Detalles_compra d ON d.id_detalle = i.id_detalle_compra
JOIN Compras c         ON c.id_compra = d.id_compra
JOIN Proveedores p     ON p.id_proveedor = c.id_proveedor
WHERE c.Fecha_compra BETWEEN '2026-09-01' AND '2026-09-30'   -- rango que se cambia
GROUP BY p.id_proveedor, p.nombre
HAVING COUNT(*) >= 3
ORDER BY porcentaje_rechazado DESC;