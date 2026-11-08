-- =====================================================================
-- AUTOESTUDIO 5/6 - TRANSACCIONES Y MODULARIDAD
-- =====================================================================

-- A. TRANSACCIONES
--
-- 1. ¿Cómo se define el comienzo y fin de una transacción?
--    Se empieza con BEGIN; y se termina con COMMIT; (guarda los cambios)
--    o con ROLLBACK; (los deshace).
--
-- 2. ¿Cómo se manejan las transacciones en los diferentes bloques?
--    - Bloque anónimo (DO): se ejecuta dentro de la transacción de quien lo
--      llama. Puede hacer COMMIT o ROLLBACK solo si no está dentro de un BEGIN.
--    - Procedimiento: se llama con CALL y es el único subprograma que puede
--      hacer COMMIT y ROLLBACK.
--    - Función: no puede hacer COMMIT ni ROLLBACK; hace parte de la
--      transacción de quien la llama.
--    - Disparador: tampoco puede; hace parte de la transacción de la
--      sentencia que lo activó. Si da error, se deshace todo.
--
-- 3. ¿En qué modo trabaja PostgreSQL si no se abre una transacción?
--    En modo autocommit: cada sentencia es una transacción que se confirma
--    sola al terminar.
--
-- 4. ¿Qué niveles de aislamiento soporta PostgreSQL?
--    En PostgreSQL las lecturas no bloquean a nadie. Solo hay bloqueo cuando
--    dos transacciones modifican la misma fila: la segunda espera a que la
--    primera termine.
--    - Read Uncommitted: funciona igual que Read Committed.
--      Evita: lectura sucia.
--    - Read Committed: cada sentencia ve los datos confirmados hasta ese
--      momento.
--      Evita: lectura sucia.
--    - Repeatable Read: toda la transacción ve los mismos datos del inicio.
--      Si otra transacción ya cambió la fila que se quiere modificar, da error.
--      Evita: lectura sucia, lectura no repetible y fantasmas.
--    - Serializable: como Repeatable Read, pero además da error si el
--      resultado no es el mismo que ejecutar las transacciones una tras otra.
--      Evita: todas las anomalías.
--
-- 5. ¿Cuál es el nivel por defecto?
--    Read Committed.

-- B. VISTAS
--
-- 1. ¿Cómo se crean y se borran las vistas?
--    CREATE VIEW v_bands AS SELECT band_id, band_name FROM band;
--    DROP VIEW v_bands;
--    También existe CREATE OR REPLACE VIEW para redefinir una vista.
--
-- 2. ¿Cuándo una vista es actualizable?
--    Cuando consulta una sola tabla y no usa DISTINCT, GROUP BY, HAVING,
--    LIMIT, UNION ni funciones de agregación (COUNT, SUM, etc.).
--    En ese caso permite INSERT, UPDATE y DELETE, que se aplican sobre la tabla.

-- C. ESQUEMAS
--
-- 1. ¿Para qué sirve un esquema?
--    Para agrupar tablas, funciones y otros objetos de la base de datos, como
--    una carpeta. Así se organiza la base por módulos y pueden existir objetos
--    con el mismo nombre en esquemas distintos.
--
-- 2. ¿Cómo se crean, se usan, se modifican y se borran?
--    Crear:     CREATE SCHEMA sv_bands;
--    Usar:      SELECT sv_bands.co();  o  SET search_path TO sv_bands, public;
--    Modificar: ALTER SCHEMA sv_bands RENAME TO sv_music;
--    Borrar:    DROP SCHEMA sv_bands CASCADE;

-- D. REFCURSOR
--
-- 1. ¿Qué es y para qué sirve?
--    Es un tipo de dato que guarda una referencia a un cursor. Sirve para que
--    una función retorne el resultado de una consulta y quien la llama lea las
--    filas con FETCH.
--
-- 2. ¿Cómo se define, se asigna y se retorna?
--    Se define:  DECLARE c REFCURSOR := 'co_cursor';
--    Se asigna:  OPEN c FOR SELECT * FROM band;
--    Se retorna: la función se declara con RETURNS REFCURSOR y hace RETURN c;
--    Quien la llama la lee dentro de una transacción:
--      BEGIN;
--      SELECT sv_bands.co();
--      FETCH ALL FROM co_cursor;
--      COMMIT;

-- =====================================================================
-- PRACTICANDO: SERVICIO SV_BANDS
-- =====================================================================

ALTER TABLE band ALTER COLUMN place_id   DROP NOT NULL;
ALTER TABLE band ALTER COLUMN contact_id DROP NOT NULL;

CREATE TABLE musician_instrument (
    musician_id  INTEGER      NOT NULL REFERENCES musician(musician_id),
    instrument   VARCHAR(20)  NOT NULL,
    PRIMARY KEY (musician_id, instrument)
);

CREATE TABLE composition (
    composition_id  INTEGER      PRIMARY KEY,
    c_title         VARCHAR(40)  NOT NULL,
    musician_id     INTEGER      NOT NULL REFERENCES musician(musician_id)
);

INSERT INTO musician_instrument (musician_id, instrument) VALUES
    (1, 'voice'), (1, 'piano'),
    (2, 'guitar'), (2, 'bass'), (2, 'voice'),
    (3, 'drums'),
    (4, 'saxophone'), (4, 'piano'),
    (5, 'bass'),
    (6, 'drums'), (6, 'piano'),
    (7, 'guitar'), (7, 'voice'),
    (8, 'bass'),
    (9, 'drums'), (9, 'guitar'), (9, 'piano');

INSERT INTO composition (composition_id, c_title, musician_id) VALUES
    (1, 'Soul Morning', 1),
    (2, 'Groove Street', 1),
    (3, 'Late Bass', 2),
    (4, 'Blue Smoke', 4),
    (5, 'Night Train', 4),
    (6, 'Horizon', 4),
    (7, 'Cold Stone', 7),
    (8, 'Echoes', 9);

CREATE SCHEMA sv_bands;

CREATE FUNCTION sv_bands.ad(p_name VARCHAR, p_type VARCHAR, p_b_date DATE)
RETURNS NUMERIC AS $$
DECLARE
    v_id INTEGER;
BEGIN
    SELECT MAX(band_id) + 1 INTO v_id FROM band;
    INSERT INTO band (band_id, band_name, band_type, b_date)
    VALUES (v_id, p_name, p_type, p_b_date);
    RETURN v_id;
END;
$$ LANGUAGE plpgsql;

CREATE FUNCTION sv_bands.up(p_band NUMERIC, p_b_date DATE)
RETURNS VOID AS $$
BEGIN
    UPDATE band SET b_date = p_b_date WHERE band_id = p_band;
END;
$$ LANGUAGE plpgsql;

CREATE FUNCTION sv_bands.ad_musician(p_band NUMERIC, p_musician NUMERIC)
RETURNS VOID AS $$
BEGIN
    INSERT INTO plays_in (band_no, musician_id) VALUES (p_band, p_musician);
END;
$$ LANGUAGE plpgsql;

CREATE FUNCTION sv_bands.de_musician(p_band NUMERIC, p_musician NUMERIC)
RETURNS VOID AS $$
BEGIN
    DELETE FROM plays_in WHERE band_no = p_band AND musician_id = p_musician;
END;
$$ LANGUAGE plpgsql;

CREATE FUNCTION sv_bands.de(p_band NUMERIC)
RETURNS VOID AS $$
BEGIN
    DELETE FROM band WHERE band_id = p_band;
END;
$$ LANGUAGE plpgsql;

CREATE FUNCTION sv_bands.co()
RETURNS REFCURSOR AS $$
DECLARE
    c REFCURSOR := 'co_cursor';
BEGIN
    OPEN c FOR
        SELECT band_id, band_name, band_type, b_date
        FROM band
        ORDER BY band_id;
    RETURN c;
END;
$$ LANGUAGE plpgsql;

CREATE FUNCTION sv_bands.co_musicians()
RETURNS REFCURSOR AS $$
DECLARE
    c REFCURSOR := 'co_musicians_cursor';
BEGIN
    OPEN c FOR
        SELECT m.musician_id, m.musician_name,
               (SELECT COUNT(*) FROM musician_instrument i WHERE i.musician_id = m.musician_id) AS instruments,
               (SELECT COUNT(*) FROM composition c WHERE c.musician_id = m.musician_id) AS compositions
        FROM musician m
        ORDER BY m.musician_id;
    RETURN c;
END;
$$ LANGUAGE plpgsql;

CREATE FUNCTION sv_bands.co_bands()
RETURNS REFCURSOR AS $$
DECLARE
    c REFCURSOR := 'co_bands_cursor';
BEGIN
    OPEN c FOR
        SELECT band_no, COUNT(*) AS musicians
        FROM plays_in
        GROUP BY band_no
        HAVING COUNT(*) > (SELECT COUNT(*) FROM plays_in) * 1.0 / (SELECT COUNT(*) FROM band)
        ORDER BY band_no;
    RETURN c;
END;
$$ LANGUAGE plpgsql;

SELECT sv_bands.ad('Night Owls', 'blues', '2022-03-15');

SELECT sv_bands.ad_musician(4, 2);
SELECT sv_bands.ad_musician(4, 5);
SELECT sv_bands.ad_musician(4, 8);

SELECT sv_bands.up(4, '2021-12-01');

SELECT sv_bands.de_musician(4, 8);

BEGIN;
SELECT sv_bands.co();
FETCH ALL FROM co_cursor;
COMMIT;

BEGIN;
SELECT sv_bands.co_musicians();
FETCH ALL FROM co_musicians_cursor;
COMMIT;

BEGIN;
SELECT sv_bands.co_bands();
FETCH ALL FROM co_bands_cursor;
COMMIT;

SELECT sv_bands.de(4);

SELECT sv_bands.ad('Polka Party', 'polka', '2020-01-01');

SELECT sv_bands.up(1, '2030-01-01');

SELECT sv_bands.ad_musician(1, 1);

DROP SCHEMA sv_bands CASCADE;
DROP TABLE composition;
DROP TABLE musician_instrument;
