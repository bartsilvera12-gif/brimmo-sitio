-- BRIMMO — Limpieza opcional
-- Elimina las tablas del intento previo en `public`.
-- CORRÉ ESTO SOLO SI YA HAY DATOS EN `public.propiedades` DE UNA MIGRACIÓN
-- ANTERIOR QUE VAS A DESCARTAR.
--
-- Se ejecuta ANTES de 01-schema.sql para dejar `public` limpio.
-- Si preferís conservar el intento previo, saltealo y solo corré 01, 02, 03, 04.

drop table if exists public.propiedad_imagenes cascade;
drop table if exists public.propiedades        cascade;
drop table if exists public.settings           cascade;
drop function if exists public.set_updated_at();
