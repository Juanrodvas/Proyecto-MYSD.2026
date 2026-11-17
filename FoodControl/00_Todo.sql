-- Carga todo en orden (sin los scripts X de eliminacion: 06_XTablas, 11_XPoblar, 14_XDisparadores, 21_XComponentes).
-- Uso, desde esta carpeta:  psql -d <base> -f 00_Todo.sql
\i 01_Tablas.sql
\i 02_Atributos.sql
\i 03_Primarias.sql
\i 04_Unicas.sql
\i 05_Foraneas.sql
\i 07_ConsultasOperativas.sql
\i 08_ConsultasGerenciales.sql
\i 09_PoblarOK.sql
\i 10_PoblarNoOK.sql
\i 12_Tuplas.sql
\i 13_Disparadores.sql
\i 15_TuplasOK.sql
\i 16_TuplasNoOK.sql
\i 17_AccionesOK.sql
\i 18_DisparadoresOK.sql
\i 19_DisparadoresNoOK.sql
\i 20_Componentes.sql
\i 22_ComponentesOK.sql
\i 23_ComponentesNoOK.sql
