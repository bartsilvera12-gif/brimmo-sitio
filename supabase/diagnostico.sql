-- BRIMMO — Diagnóstico rápido
-- Correr en el SQL Editor y mandar el resultado.
-- No modifica nada, solo consulta.

-- 1. ¿Existe el schema `brimmo`?
select schema_name
from information_schema.schemata
where schema_name = 'brimmo';

-- 2. ¿RLS está habilitado en las tres tablas?
select tablename as nombre, rowsecurity as rls_activo
from pg_tables
where schemaname = 'brimmo'
  and tablename in ('propiedades', 'propiedad_imagenes', 'settings')
order by tablename;

-- 3. ¿Qué políticas están creadas en las tablas del proyecto?
select tablename, policyname, cmd, roles::text
from pg_policies
where schemaname = 'brimmo'
order by tablename, policyname;

-- 4. ¿Qué buckets hay?
select id, name, public
from storage.buckets
order by name;

-- 5. Políticas del storage
select policyname, cmd
from pg_policies
where schemaname = 'storage'
  and tablename = 'objects'
  and policyname like 'brimmo%'
order by policyname;

-- 6. Conteo de propiedades
select
  (select count(*) from brimmo.propiedades) as total,
  (select count(*) from brimmo.propiedades where published) as publicadas;
