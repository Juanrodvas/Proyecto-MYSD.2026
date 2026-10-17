create database gruas_nacionales;


create table clientes(
    id_clientes NUMERIC(10) NOT NULL,
    nombre VARCHAR(100) NOT NULL
);

create table privados(
    id_privados NUMERIC(10) NOT NULL,
    actividad_economica VARCHAR(10) NOT NULL
);

create table publicos(
    id_publicos NUMERIC(10) NOT NULL,
    tipo NUMERIC(10) NOT NULL,
    numero_tributario VARCHAR(10) NOT NULL
);

create table conductores(
    tipo_doc VARCHAR(2) NOT NULL,
    numero_documento NUMERIC(10) NOT NULL
);

create table licencias(
    tipo_doc VARCHAR(2) NOT NULL,
    numero_documento NUMERIC(10) NOT NULL,
    fecha_expedicion DATE NOT NULL,
    fecha_vencimiento DATE NOT NULL
);

create table vehiculos(
    id_vehiculos NUMERIC(10) NOT NULL,
    placa VARCHAR(6) NOT NULL,
    categoria VARCHAR(21) NOT NULL,
    tipo_doc VARCHAR(2),
    numero_documento NUMERIC(10)
);

create table facturaciones(
    id_facturaciones NUMERIC(10) NOT NULL,
    numero NUMERIC(10) NOT NULL,
    fecha_emision DATE NOT NULL,
    monto_total NUMERIC(12,2) NOT NULL,
    impuestos NUMERIC(12,2) NOT NULL,
    fecha_limite_pago DATE NOT NULL,
    estado VARCHAR(20) NOT NULL,
    saldo_pendiente NUMERIC(12,2)
);

create table servicios(
    id_servicios NUMERIC(10) NOT NULL,
    fecha_solicitud DATE NOT NULL,
    fecha_cancelacion DATE,
    fecha_finalizacion DATE,
    estado VARCHAR(20) NOT NULL,
    distancia_total NUMERIC(32),
    id_clientes NUMERIC(10) NOT NULL,
    id_vehiculos NUMERIC(10) NOT NULL,
    tipo_doc VARCHAR(2) NOT NULL,
    numero_documento NUMERIC(10) NOT NULL,
    id_facturaciones NUMERIC(10)
);

create table novedades(
    id_servicios NUMERIC(10) NOT NULL,
    fecha DATE NOT NULL
);


create table titulos_novedades(
    id_servicios NUMERIC(10) NOT NULL,
    fecha DATE NOT NULL,
    titulo VARCHAR(200) NOT NULL
);

create table pagos(
    id_pagos NUMERIC(10) NOT NULL,
    referencia VARCHAR(100) NOT NULL,
    fecha DATE NOT NULL,
    monto NUMERIC(12,2) NOT NULL,
    metodo_pago VARCHAR(14) NOT NULL,
    estado VARCHAR(20) NOT NULL,
    id_facturaciones NUMERIC(10) NOT NULL
);

-- Convenios no tiene identificador en el diagrama; se agrega id_convenios
create table convenios(
    id_convenios NUMERIC(10) NOT NULL,
    porcentaje NUMERIC(2) NOT NULL,
    motivo VARCHAR(100) NOT NULL
);

-- Relación muchos a muchos Facturacion - Convenios
create table facturaciones_convenios(
    id_facturaciones NUMERIC(10) NOT NULL,
    id_convenios NUMERIC(10) NOT NULL
);


---------------------------------------------------------------
-- 2. INTEGRIDAD DECLARATIVA - CRUD: Registrar Servicio
--    (servicios, novedades y las tablas que necesitan)
---------------------------------------------------------------

-- Atributos
alter table servicios add constraint ck_servicios_estado
    check (estado in ('Solicitado', 'EnCurso', 'Finalizado', 'Cancelado'));

-- Restricción 2: cancelado <-> fecha de cancelación registrada
alter table servicios add constraint ck_servicios_cancelacion
    check ((estado = 'Cancelado' and fecha_cancelacion is not null)
        or (estado <> 'Cancelado' and fecha_cancelacion is null));

alter table servicios add constraint ck_servicios_finalizacion
    check ((estado = 'Finalizado' and fecha_finalizacion is not null)
        or (estado <> 'Finalizado' and fecha_finalizacion is null));

alter table servicios add constraint ck_servicios_fechas
    check ((fecha_cancelacion is null or fecha_cancelacion >= fecha_solicitud)
    and (fecha_finalizacion is null or fecha_finalizacion >= fecha_solicitud));

alter table servicios add constraint ck_servicios_distancia
    check (distancia_total is null or distancia_total > 0);

alter table vehiculos add constraint ck_vehiculos_placa
    check (placa ~ '^[A-Z]{3}[0-9]{3}$');

alter table conductores add constraint ck_conductores_tipo_doc
    check (tipo_doc in ('CC', 'CE', 'PA'));

alter table licencias add constraint ck_licencias_fechas
    check (fecha_vencimiento > fecha_expedicion);

-- Primarias
alter table clientes add constraint pk_clientes primary key (id_clientes);
alter table conductores add constraint pk_conductores primary key (tipo_doc, numero_documento);
alter table licencias add constraint pk_licencias primary key (tipo_doc, numero_documento, fecha_expedicion);
alter table vehiculos add constraint pk_vehiculos primary key (id_vehiculos);
alter table facturaciones add constraint pk_facturaciones primary key (id_facturaciones);
alter table servicios add constraint pk_servicios primary key (id_servicios);
alter table novedades add constraint pk_novedades primary key (id_servicios, fecha);
alter table titulos_novedades add constraint pk_titulos_novedades primary key (id_servicios, fecha, titulo);

alter table vehiculos add constraint uk_vehiculos_placa unique (placa);

alter table servicios add constraint fk_servicios_clientes
    foreign key (id_clientes) references clientes (id_clientes);

alter table servicios add constraint fk_servicios_vehiculos
    foreign key (id_vehiculos) references vehiculos (id_vehiculos);

alter table servicios add constraint fk_servicios_conductores
    foreign key (tipo_doc, numero_documento) references conductores (tipo_doc, numero_documento);

alter table servicios add constraint fk_servicios_facturaciones
    foreign key (id_facturaciones) references facturaciones (id_facturaciones);

alter table vehiculos add constraint fk_vehiculos_conductores
    foreign key (tipo_doc, numero_documento) references conductores (tipo_doc, numero_documento);


alter table licencias add constraint fk_licencias_conductores
    foreign key (tipo_doc, numero_documento) references conductores (tipo_doc, numero_documento);


alter table novedades add constraint fk_novedades_servicios
    foreign key (id_servicios) references servicios (id_servicios);


alter table titulos_novedades add constraint fk_titulos_novedades
    foreign key (id_servicios, fecha) references novedades (id_servicios, fecha);




---------------------------------------------------------------
-- XTABLAS (para borrar todo y volver a empezar)
---------------------------------------------------------------
-- drop table if exists facturaciones_convenios, convenios, pagos, titulos_novedades,
--     novedades, servicios, facturaciones, vehiculos, licencias, conductores,
--     publicos, privados, clientes cascade;
-- drop function if exists fn_servicios_bi(), fn_servicios_bu(), fn_servicios_bd();



--TRIGGERS--
Create or replace function fn_servicios_bi()
RETURNS trigger as $$
begin 
if not EXISTS (select 1 from licencias l 
where l.tipo_doc = new.tipo_doc
and l.numero_documento = new.numero_documento
and new.fecha_solicitud BETWEEN l.fecha_expedicion and l.fecha_vencimiento)
then raise exception 'el conductor no tiene licencia vigente';
end if;
    return NEW;
end;
$$ language plpgsql;

create trigger tg_servicios_bi
BEFORE insert on servicios 
for each row 
execute function fn_servicios_bi();





create or replace function fn_vehiculos_placa()
returns trigger as $$ 
begin
new.placa := upper(new.placa);
return new;
end;
$$ language plpgsql;

create trigger tg_vehiculos_placa
before insert on vehiculos 
for each row
execute FUNCTION fn_vehiculos_placa();




create or replace function fn_servicios_fecha()
returns trigger as $$
begin 
if (new.estado = 'Finalizado') then 
new.fecha_finalizacion := CURRENT_DATE;
end if;
return new;
end;
$$ language plpgsql;

create trigger tg_servicios_fecha
before update on servicios
for each row 
execute FUNCTION fn_servicios_fecha();


create or replace function fn_servicios_estado()
returns trigger as $$ 
begin 
if old.estado = 'Finalizado' then 
raise exception USING message = 'el servicio ya esta finalizado';
end if;
return old;
end;
$$ language plpgsql;

create trigger tg_servicios_estado
before delete on servicios 
for each row 
execute function fn_servicios_estado();


create or replace function fn_pagos_ai()
returns trigger as $$
begin 
update facturaciones 
set saldo_pendiente = saldo_pendiente - new.monto
where id_facturaciones = new.id_facturaciones;

update facturaciones 
set estado = 'pagada'
where id_facturaciones = new.id_facturaciones
and saldo_pendiente <= 0;

return new;
end;
$$ language plpgsql;

create trigger tg_pagos_ai
after insert on pagos
for each row 
execute function fn_pagos_ai();





create table usuarios(
    estado varchar(20) not null
);
create domain Testado as varchar(20)
check (value in ('Finalizado', 'Completado'))

alter table usuarios alter column  estado type Testado;


insert into usuarios(estado) values ('Finalizado');


select * from usuarios;

insert into usuarios (estado) values ('aceptado');

drop table usuarios;

SELECT table_name
FROM information_schema.tables
WHERE table_schema = 'public'
AND table_type = 'BASE TABLE';


