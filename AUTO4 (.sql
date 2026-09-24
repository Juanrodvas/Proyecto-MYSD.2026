DROP TABLE IF EXISTS plays_in CASCADE;
DROP TABLE IF EXISTS band CASCADE;
DROP TABLE IF EXISTS place CASCADE;
DROP TABLE IF EXISTS musician CASCADE;
DROP DOMAIN IF EXISTS tmusictype CASCADE;

CREATE DOMAIN tmusictype AS VARCHAR(10)
    CHECK (VALUE IN ('rock', 'classical', 'jazz', 'blues', 'pop', 'soul'));


-- Tabla de lugares
CREATE TABLE place (
    place_no    INTEGER      PRIMARY KEY,
    place_name  VARCHAR(40)  NOT NULL
);

-- Tabla de músicos
CREATE TABLE musician (
    musician_id    INTEGER      PRIMARY KEY,
    musician_name  VARCHAR(40)  NOT NULL
);

-- Tabla de bandas
CREATE TABLE band (
    band_id     INTEGER      PRIMARY KEY,
    band_name   VARCHAR(20)  NOT NULL UNIQUE,
    band_type   tmusictype,
    b_date      DATE,
    place_id    INTEGER      NOT NULL,
    contact_id  INTEGER      NOT NULL,

    CONSTRAINT check_band_name_not_empty CHECK (length(trim(band_name)) > 0),
    CONSTRAINT check_b_date_in_past      CHECK (b_date IS NULL OR b_date < CURRENT_DATE),

    CONSTRAINT fk_band_place FOREIGN KEY (place_id) 
        REFERENCES place(place_no) 
        ON DELETE RESTRICT 
        ON UPDATE CASCADE,
        
    CONSTRAINT fk_band_contact FOREIGN KEY (contact_id) 
        REFERENCES musician(musician_id) 
        ON DELETE RESTRICT 
        ON UPDATE CASCADE
);

CREATE TABLE plays_in (
    band_no      INTEGER NOT NULL,
    musician_id  INTEGER NOT NULL,

    PRIMARY KEY (band_no, musician_id),

    -- Al eliminar una banda o un músico, se borran sus asociaciones automáticamente
    CONSTRAINT fk_plays_in_band FOREIGN KEY (band_no) 
        REFERENCES band(band_id) 
        ON DELETE CASCADE 
        ON UPDATE CASCADE,
        
    CONSTRAINT fk_plays_in_musician FOREIGN KEY (musician_id) 
        REFERENCES musician(musician_id) 
        ON DELETE CASCADE 
        ON UPDATE CASCADE
);

-- Lugares
INSERT INTO place (place_no, place_name) VALUES
    (1, 'Bogotá'),
    (2, 'Medellín'),
    (3, 'Cali');

-- Músicos
INSERT INTO musician (musician_id, musician_name) VALUES
    (1, 'Ana Ríos'),
    (2, 'Luis Pardo'),
    (3, 'Marta Gil'),
    (4, 'Iván Soto'),
    (5, 'Carla Nieto'),
    (6, 'Pedro León'),
    (7, 'Sofía Ruiz'),
    (8, 'Diego Vega'),
    (9, 'Elena Cruz');

-- Bandas
INSERT INTO band (band_id, band_name, band_type, b_date, place_id, contact_id) VALUES
    (1, 'The Groove Kids', 'soul', '2020-05-10', 1, 1),
    (2, 'Blue Horizon',    'jazz', '2019-11-02', 2, 4),
    (3, 'Stone Echo',      'rock', '2021-01-01', 3, 7);

-- Integrantes de las bandas (3 por banda)
INSERT INTO plays_in (band_no, musician_id) VALUES
    (1, 1), (1, 2), (1, 3),
    (2, 4), (2, 5), (2, 6),
    (3, 7), (3, 8), (3, 9);

SELECT * FROM band;
SELECT * FROM plays_in;

-- Prueba 1: Inserción y borrado permitido (lugar sin bandas asociadas)
INSERT INTO place (place_no, place_name) VALUES (4, 'Cartagena');
DELETE FROM place WHERE place_no = 4;

-- Prueba 2: Borrado en cascada (al borrar la banda 3, se eliminan sus filas en plays_in)
DELETE FROM band WHERE band_id = 3;

-- Debe devolver 0 filas para la banda 3
SELECT * FROM plays_in WHERE band_no = 3;

-- [Pruebas de restricción opcionales para validar en consola]:
-- DELETE FROM place WHERE place_no = 1;     -- Falla (tiene bandas)
-- DELETE FROM musician WHERE musician_id = 1;  -- Falla (es contacto de una banda)