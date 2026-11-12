-- ============================================================
-- AUTOESTUDIO 6/6 - JSON BÁSICO (MYSD 2026-2)
-- Sobre el modelo de bandas de AUTO4.sql
-- MITAD 1: Parte A (definiendo y poblando) y Parte B (consultando)
-- Pendiente: teoría "Investigando en PostgreSQL" y Parte C (JSON Schema)
-- ============================================================

-- ------------------------------------------------------------
-- A.1 ESTRUCTURA DEL JSON
-- ------------------------------------------------------------
-- La columna band.description es JSONB. Es un objeto con tres claves:
--
-- {
--   "vestuario": {
--     "prendas":    ["chaqueta de cuero", "jeans negros"],
--     "accesorios": ["gafas oscuras", "cadenas"],
--     "maquillaje": ["delineador negro"],
--     "otros":      ["guantes sin dedos"]
--   },
--   "premios": [
--     {"nombre": "Premio Nacional de Rock", "anio": 2022, "monto": 5000},
--     {"nombre": "Mejor banda revelación",  "anio": 2021}
--   ],
--   "modalidades": [
--     {"nombre": "telonero", "descripcion": "Abre conciertos de otras bandas",
--      "precio_min": 300, "precio_max": 800, "valoracion": 4.5}
--   ]
-- }
--
-- vestuario:   objeto con cuatro listas de textos (prendas, accesorios,
--              maquillaje, otros).
-- premios:     lista de objetos. nombre y anio siempre; monto (USD) solo
--              si el premio incluye recompensa económica.
-- modalidades: lista de objetos con nombre, descripcion, precio_min y
--              precio_max (USD) y valoracion (promedio 1..5).

-- ------------------------------------------------------------
-- A.2 CREACIÓN DE LAS TABLAS (band con el nuevo atributo description)
-- ------------------------------------------------------------
DROP TABLE IF EXISTS plays_in CASCADE;
DROP TABLE IF EXISTS band CASCADE;
DROP TABLE IF EXISTS place CASCADE;
DROP TABLE IF EXISTS musician CASCADE;
DROP DOMAIN IF EXISTS tmusictype CASCADE;

CREATE DOMAIN tmusictype AS VARCHAR(10)
    CHECK (VALUE IN ('rock', 'classical', 'jazz', 'blues', 'pop', 'soul'));

CREATE TABLE place (
    place_no    INTEGER      PRIMARY KEY,
    place_name  VARCHAR(40)  NOT NULL
);

CREATE TABLE musician (
    musician_id    INTEGER      PRIMARY KEY,
    musician_name  VARCHAR(40)  NOT NULL
);

CREATE TABLE band (
    band_id     INTEGER      PRIMARY KEY,
    band_name   VARCHAR(20)  NOT NULL UNIQUE,
    band_type   tmusictype,
    b_date      DATE,
    place_id    INTEGER      NOT NULL,
    contact_id  INTEGER      NOT NULL,
    description JSONB,                       -- NUEVO

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

    CONSTRAINT fk_plays_in_band FOREIGN KEY (band_no)
        REFERENCES band(band_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,

    CONSTRAINT fk_plays_in_musician FOREIGN KEY (musician_id)
        REFERENCES musician(musician_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- ------------------------------------------------------------
-- A.3 POBLAR
-- ------------------------------------------------------------
INSERT INTO place (place_no, place_name) VALUES
    (1, 'Bogotá'),
    (2, 'Medellín'),
    (3, 'Cali');

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

-- Banda 1: usa maquillaje, telonero con 4.5, un premio con monto y otro sin monto
-- Banda 2: NO usa maquillaje (lista vacía), telonero con 3.2, sin premios
-- Banda 3: usa maquillaje, telonero con 4.0 exacto, un premio con monto
INSERT INTO band (band_id, band_name, band_type, b_date, place_id, contact_id, description) VALUES
    (1, 'The Groove Kids', 'soul', '2020-05-10', 1, 1,
     '{
        "vestuario": {
            "prendas":    ["chaqueta de cuero", "jeans negros"],
            "accesorios": ["gafas oscuras", "cadenas"],
            "maquillaje": ["delineador negro"],
            "otros":      ["guantes sin dedos"]
        },
        "premios": [
            {"nombre": "Premio Nacional de Soul", "anio": 2022, "monto": 5000},
            {"nombre": "Mejor banda revelación",  "anio": 2021}
        ],
        "modalidades": [
            {"nombre": "telonero", "descripcion": "Abre conciertos de otras bandas",
             "precio_min": 300, "precio_max": 800, "valoracion": 4.5},
            {"nombre": "evento privado", "descripcion": "Bodas y fiestas",
             "precio_min": 500, "precio_max": 1500, "valoracion": 4.1}
        ]
     }'),
    (2, 'Blue Horizon', 'jazz', '2019-11-02', 2, 4,
     '{
        "vestuario": {
            "prendas":    ["traje gris", "camisa blanca"],
            "accesorios": ["corbatín"],
            "maquillaje": [],
            "otros":      []
        },
        "premios": [],
        "modalidades": [
            {"nombre": "telonero", "descripcion": "Abre conciertos de otras bandas",
             "precio_min": 200, "precio_max": 600, "valoracion": 3.2},
            {"nombre": "restaurante", "descripcion": "Música de fondo en restaurantes",
             "precio_min": 150, "precio_max": 400, "valoracion": 4.8}
        ]
     }'),
    (3, 'Stone Echo', 'rock', '2021-01-01', 3, 7,
     '{
        "vestuario": {
            "prendas":    ["camiseta negra", "botas"],
            "accesorios": ["pulseras de tachas"],
            "maquillaje": ["pintura facial", "sombras oscuras"],
            "otros":      ["peluca"]
        },
        "premios": [
            {"nombre": "Rock al Parque", "anio": 2023, "monto": 12000}
        ],
        "modalidades": [
            {"nombre": "telonero", "descripcion": "Abre conciertos de otras bandas",
             "precio_min": 400, "precio_max": 1000, "valoracion": 4.0},
            {"nombre": "festival", "descripcion": "Presentaciones en festivales",
             "precio_min": 1000, "precio_max": 3000, "valoracion": 4.6}
        ]
     }');

INSERT INTO plays_in (band_no, musician_id) VALUES
    (1, 1), (1, 2), (1, 3),
    (2, 4), (2, 5), (2, 6),
    (3, 7), (3, 8), (3, 9);

SELECT band_id, band_name, description FROM band;

-- ------------------------------------------------------------
-- B. CONSULTANDO
-- ------------------------------------------------------------

-- B.1 Bandas con valoración >= 4 como teloneros
-- Esperado: The Groove Kids y Stone Echo
SELECT band_name
FROM band
WHERE jsonb_path_exists(description,
    '$.modalidades[*] ? (@.nombre == "telonero" && @.valoracion >= 4)');

-- B.2 Bandas que usan maquillaje (lista maquillaje con al menos un elemento)
-- Esperado: The Groove Kids y Stone Echo
SELECT band_name
FROM band
WHERE jsonb_path_exists(description, '$.vestuario.maquillaje[*]');

-- B.3 Número de bandas en cada modalidad de contratación
-- Esperado: telonero 3, evento privado 1, restaurante 1, festival 1
SELECT m #>> '{}' AS modalidad, COUNT(*) AS num_bandas
FROM band b, jsonb_path_query(b.description, '$.modalidades[*].nombre') AS m
GROUP BY m #>> '{}'
ORDER BY num_bandas DESC, modalidad;

-- B.4 (propia, con jsonb_to_recordset)
-- Premios con recompensa económica: banda, premio, año y monto en USD
-- Esperado: The Groove Kids / Premio Nacional de Soul / 2022 / 5000
--           Stone Echo / Rock al Parque / 2023 / 12000
SELECT b.band_name, p.nombre, p.anio, p.monto
FROM band b,
     jsonb_to_recordset(b.description -> 'premios')
         AS p(nombre TEXT, anio INTEGER, monto NUMERIC)
WHERE p.monto IS NOT NULL
ORDER BY p.monto;

-- B.5 (propia, con to_jsonb y jsonb_agg)
-- Por tipo de música, un arreglo JSON con los nombres de sus bandas
-- Esperado: jazz ["Blue Horizon"], rock ["Stone Echo"], soul ["The Groove Kids"]
SELECT band_type,
       jsonb_agg(to_jsonb(band_name)) AS bandas
FROM band
GROUP BY band_type
ORDER BY band_type;

-- ============================================================
-- TEORÍA: INVESTIGANDO EN PostgreSQL
-- ============================================================

-- ------------------------------------------------------------
-- 1. TIPO DE DATOS
-- ------------------------------------------------------------
-- ¿Cómo se define un atributo para que contenga datos en JSON?
--   Con el tipo JSONB (o JSON) en el CREATE TABLE:
--     description JSONB
--
-- ¿Qué diferencia hay entre JSON y JSONB?
--   JSON guarda el texto tal cual se escribió (conserva espacios, orden de
--   las claves y claves repetidas) y lo vuelve a interpretar en cada consulta.
--   JSONB guarda el dato en formato binario ya interpretado: no conserva
--   espacios ni el orden de las claves y elimina claves duplicadas (queda la
--   última). Es un poco más lento al insertar, pero mucho más rápido al
--   consultar, soporta índices (GIN) y soporta todos los operadores y
--   funciones de JSON Path. Por eso se recomienda JSONB.
--
-- ¿Cómo se inserta una tupla con un valor JSONB?
--   Se escribe el JSON como una cadena entre comillas simples; PostgreSQL la
--   convierte a JSONB (opcionalmente con ::jsonb):
--     INSERT INTO band (band_id, ..., description)
--     VALUES (1, ..., '{"vestuario": {"prendas": ["chaqueta"]}}');
--   También se puede construir con funciones: to_jsonb(...), jsonb_build_object(...).

-- ------------------------------------------------------------
-- 2. CONSULTAS
-- ------------------------------------------------------------
-- ¿Cómo se integra JSON Path a las expresiones SQL?
--   Mediante funciones (jsonb_path_exists, jsonb_path_query, ...) que reciben
--   el dato JSONB y una cadena con la expresión JSON Path, o mediante los
--   operadores @? (existe) y @@ (predicado) en el WHERE. En JSON Path:
--     $            es el documento completo
--     .clave       entra a un atributo
--     [*]          recorre todos los elementos de un arreglo
--     ? (cond)     filtra; dentro de la condición @ es el elemento actual
--   Ejemplo: '$.modalidades[*] ? (@.valoracion >= 4)'
--
-- ¿Qué hacen jsonb_path_query y jsonb_path_exists?
--   jsonb_path_exists(json, path): devuelve true si la ruta devuelve al
--     menos un elemento; se usa para filtrar en el WHERE.
--   jsonb_path_query(json, path): devuelve como filas (cada una JSONB) todos
--     los elementos que cumplen la ruta; se usa en SELECT o en FROM.
--
-- ¿Cómo se usa el operador de conversión de tipos :: tipo?
--   Se pone después del valor y convierte al tipo indicado:
--     '{"a": 1}'::jsonb          texto a JSONB
--     (description->'a')::int    JSONB a entero (solo si el valor es numérico)
--     fecha::text                cualquier valor a texto
--   Para sacar un texto de un JSONB sin comillas se usa el operador ->> (o
--   #>> '{}') y luego ::tipo si hace falta.
--
-- ¿Qué hacen jsonb_to_recordset, to_jsonb y jsonb_agg?
--   jsonb_to_recordset(arreglo): convierte un arreglo JSONB de objetos en un
--     conjunto de filas relacionales; las columnas se declaran con
--     AS t(col1 tipo, col2 tipo). Pasa de JSON a SQL.
--   to_jsonb(valor): convierte un valor SQL (texto, número, fila completa) a
--     JSONB. Pasa de SQL a JSON.
--   jsonb_agg(expr): función de agregación que junta los valores de varias
--     filas en un solo arreglo JSONB (se usa con GROUP BY).

-- ------------------------------------------------------------
-- 3. VALIDACIÓN
-- ------------------------------------------------------------
-- ¿Cuándo se verifica si un dato JSON es bien formado?
--   Al momento de asignar el valor a una columna JSON/JSONB (INSERT o
--   UPDATE) o de convertirlo con ::jsonb. Si la sintaxis es incorrecta
--   (llaves sin cerrar, comillas simples en vez de dobles, coma sobrante),
--   PostgreSQL lanza el error "invalid input syntax for type json" y no
--   guarda nada.
--
-- ¿Es posible verificar si un dato JSON cumple un esquema JSON Schema?
--   PostgreSQL no lo trae de forma nativa. Se puede hacer con extensiones,
--   por ejemplo pg_jsonschema (función jsonb_matches_schema(esquema, dato))
--   o postgres-json-schema (función validate_json_schema), usándolas dentro
--   de un CHECK.
--
-- ¿Qué mecanismos se pueden usar para validar restricciones sobre un dato JSON?
--   - CHECK sobre la columna con funciones y operadores JSON, por ejemplo:
--       CHECK (jsonb_typeof(description) = 'object')
--       CHECK (description ? 'vestuario')                     (existe la clave)
--       CHECK (jsonb_path_exists(description, '$.vestuario.prendas[*]'))
--       CHECK (NOT jsonb_path_exists(description,
--              '$.modalidades[*] ? (@.valoracion < 1 || @.valoracion > 5)'))
--   - CHECK con una extensión de JSON Schema (jsonb_matches_schema).
--   - DOMAIN con un CHECK, para reutilizar la regla en varias columnas.
--   - Disparadores (triggers) que revisan el dato antes de insertar o
--     actualizar, para reglas más complejas.
