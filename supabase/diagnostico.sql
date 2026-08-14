-- BRIMMO — Diagnóstico rápido
-- Correr en el SQL Editor y mandar el resultado.
-- No modifica nada, solo consulta.

-- 1. ¿RLS está habilitado en las tres tablas?
select 'tabla' as tipo, tablename as nombre, rowsecurity as rls_activo
from pg_tables
where schemaname = 'public'
  and tablename in ('propiedades', 'propiedad_imagenes', 'settings')
order by tablename;

-- 2. ¿Qué políticas están creadas?
select tablename, policyname, cmd, roles::text
from pg_policies
where schemaname = 'public'
  and tablename in ('propiedades', 'propiedad_imagenes', 'settings')
order by tablename, policyname;

-- 3. ¿Qué buckets hay?
select id, name, public
from storage.buckets
order by name;

-- 4. Políticas del storage
select policyname, cmd
from pg_policies
where schemaname = 'storage'
  and tablename = 'objects'
  and policyname like 'brimmo%'
order by policyname;

-- 5. Conteo de propiedades
select
  (select count(*) from public.propiedades) as total,
  (select count(*) from public.propiedades where published) as publicadas;
