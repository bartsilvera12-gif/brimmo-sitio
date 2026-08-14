-- ============================================================================
-- BRIMMO — Setup completo del schema
-- Junta 01-schema + 02-rls + 03-storage en un solo archivo para revisar
-- y correr de una vez. Idempotente: se puede correr varias veces sin romper.
-- No incluye el seed de datos: ese sigue siendo 04-seed.sql.
-- ============================================================================


-- ============================================================================
-- 1. SCHEMA propio del proyecto
-- ============================================================================
create schema if not exists brimmo;

-- Sin este grant PostgREST devuelve 404 aunque el schema exista.
grant usage on schema brimmo to anon, authenticated;


-- ============================================================================
-- 2. TABLAS
-- ============================================================================

-- 2.1 Propiedades ------------------------------------------------------------
create table if not exists brimmo.propiedades (
  id            bigint primary key generated always as identity,

  -- Clasificación
  type          text not null,        -- Villa | Quinta | Terreno | Casa | Rancho | Departamento
  operation     text not null default 'VENTA',   -- VENTA | ALQUILER
  city          text not null,

  -- Precio y superficie
  price         bigint,
  currency      text check (currency in ('USD','GS') or currency is null),
  land          integer,
  built         integer,
  beds          integer,
  baths         integer,

  -- Medios
  video_id      text,                 -- ID de YouTube (11 caracteres)
  maps_short    text,                 -- URL corta para compartir
  maps_long     text,                 -- URL de embed (iframe src)
  lat           numeric(9,6),
  lng           numeric(9,6),

  -- Contenido traducible (español obligatorio, francés e inglés opcionales)
  title_es      text not null,
  title_fr      text,
  title_en      text,
  zone_es       text,
  zone_fr       text,
  zone_en       text,
  desc_es       text,
  desc_fr       text,
  desc_en       text,
  features_es   jsonb not null default '[]'::jsonb,
  features_fr   jsonb not null default '[]'::jsonb,
  features_en   jsonb not null default '[]'::jsonb,

  -- Estado
  published     boolean not null default false,
  featured      boolean not null default false,
  pendiente     text,                                -- nota interna, no se muestra
  orden         integer not null default 0,          -- menor primero

  created_at    timestamptz not null default now(),
  updated_at    timestamptz not null default now()
);

create index if not exists propiedades_publicadas_orden on brimmo.propiedades (orden, id) where published = true;
create index if not exists propiedades_destacadas       on brimmo.propiedades (orden) where featured = true and published = true;
create index if not exists propiedades_por_tipo         on brimmo.propiedades (type)  where published = true;
create index if not exists propiedades_por_ciudad       on brimmo.propiedades (city)  where published = true;

-- 2.2 Imágenes por propiedad -------------------------------------------------
create table if not exists brimmo.propiedad_imagenes (
  id            bigint primary key generated always as identity,
  propiedad_id  bigint not null references brimmo.propiedades(id) on delete cascade,
  storage_path  text not null,        -- path dentro del bucket
  alt_es        text,
  alt_fr        text,
  alt_en        text,
  orden         integer not null default 0,
  es_principal  boolean not null default false,
  created_at    timestamptz not null default now()
);

create index if not exists imagenes_por_propiedad on brimmo.propiedad_imagenes (propiedad_id, orden);
create unique index if not exists imagenes_una_principal_por_propiedad
  on brimmo.propiedad_imagenes (propiedad_id) where es_principal;

-- 2.3 Settings (fila única con datos de contacto) ---------------------------
create table if not exists brimmo.settings (
  id            integer primary key default 1,
  telefono      text,
  whatsapp      text,                 -- solo dígitos, para wa.me/
  email         text,
  direccion     text,
  facebook_url  text,
  youtube_url   text,
  updated_at    timestamptz not null default now(),
  constraint settings_singleton check (id = 1)
);

insert into brimmo.settings (id, telefono, whatsapp, email, direccion, facebook_url, youtube_url)
values (1, '+595 992 984 777', '595992984777', 'loginvest7@gmail.com', 'Cabañas, Caacupé, Paraguay',
        'https://www.facebook.com/groups/754200153951006', 'https://www.youtube.com/@BRUBIO777')
on conflict (id) do nothing;


-- ============================================================================
-- 3. TRIGGER updated_at automático
-- ============================================================================
create or replace function brimmo.set_updated_at()
returns trigger language plpgsql as $$
begin new.updated_at = now(); return new; end $$;

drop trigger if exists propiedades_touch on brimmo.propiedades;
create trigger propiedades_touch before update on brimmo.propiedades
  for each row execute function brimmo.set_updated_at();

drop trigger if exists settings_touch on brimmo.settings;
create trigger settings_touch before update on brimmo.settings
  for each row execute function brimmo.set_updated_at();


-- ============================================================================
-- 4. GRANTS (los roles de la API necesitan esto ANTES de RLS)
-- ============================================================================
grant select                          on brimmo.propiedades        to anon, authenticated;
grant select                          on brimmo.propiedad_imagenes to anon, authenticated;
grant select                          on brimmo.settings           to anon, authenticated;

grant insert, update, delete          on brimmo.propiedades        to authenticated;
grant insert, update, delete          on brimmo.propiedad_imagenes to authenticated;
grant insert, update, delete          on brimmo.settings           to authenticated;

grant usage, select on all sequences in schema brimmo               to authenticated;

-- Que las futuras tablas y secuencias hereden los grants
alter default privileges in schema brimmo grant select                 on tables    to anon;
alter default privileges in schema brimmo grant select, insert, update, delete on tables to authenticated;
alter default privileges in schema brimmo grant usage, select          on sequences to authenticated;


-- ============================================================================
-- 5. RLS (Row Level Security)
-- Anon: solo ve propiedades publicadas y las imágenes de esas.
-- Authenticated (el admin): hace todo.
-- ============================================================================
alter table brimmo.propiedades       enable row level security;
alter table brimmo.propiedad_imagenes enable row level security;
alter table brimmo.settings          enable row level security;

-- Propiedades
drop policy if exists "publico_ve_publicadas"   on brimmo.propiedades;
drop policy if exists "autenticado_hace_todo_p" on brimmo.propiedades;

create policy "publico_ve_publicadas" on brimmo.propiedades
  for select to anon using (published = true);

create policy "autenticado_hace_todo_p" on brimmo.propiedades
  for all to authenticated using (true) with check (true);

-- Imágenes
drop policy if exists "publico_ve_imagenes"     on brimmo.propiedad_imagenes;
drop policy if exists "autenticado_hace_todo_i" on brimmo.propiedad_imagenes;

create policy "publico_ve_imagenes" on brimmo.propiedad_imagenes
  for select to anon
  using (exists (select 1 from brimmo.propiedades p
                 where p.id = propiedad_imagenes.propiedad_id and p.published = true));

create policy "autenticado_hace_todo_i" on brimmo.propiedad_imagenes
  for all to authenticated using (true) with check (true);

-- Settings (público lee, solo autenticado edita)
drop policy if exists "publico_lee_settings"       on brimmo.settings;
drop policy if exists "autenticado_edita_settings" on brimmo.settings;

create policy "publico_lee_settings" on brimmo.settings
  for select to anon using (true);

create policy "autenticado_edita_settings" on brimmo.settings
  for all to authenticated using (true) with check (true);


-- ============================================================================
-- 6. STORAGE — bucket para las fotos
-- ============================================================================
insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
values (
  'brimmo-imagenes',
  'brimmo-imagenes',
  true,                                                       -- lectura pública
  10485760,                                                   -- 10 MB por archivo
  array['image/jpeg','image/png','image/webp','image/avif']
)
on conflict (id) do update set
  public              = excluded.public,
  file_size_limit     = excluded.file_size_limit,
  allowed_mime_types  = excluded.allowed_mime_types;

-- Políticas del bucket
drop policy if exists "brimmo_lectura_publica" on storage.objects;
drop policy if exists "brimmo_admin_sube"      on storage.objects;
drop policy if exists "brimmo_admin_actualiza" on storage.objects;
drop policy if exists "brimmo_admin_borra"     on storage.objects;

create policy "brimmo_lectura_publica" on storage.objects
  for select to anon, authenticated
  using (bucket_id = 'brimmo-imagenes');

create policy "brimmo_admin_sube" on storage.objects
  for insert to authenticated
  with check (bucket_id = 'brimmo-imagenes');

create policy "brimmo_admin_actualiza" on storage.objects
  for update to authenticated
  using (bucket_id = 'brimmo-imagenes');

create policy "brimmo_admin_borra" on storage.objects
  for delete to authenticated
  using (bucket_id = 'brimmo-imagenes');


-- ============================================================================
-- FIN. Después de este archivo, correr 04-seed.sql para cargar las 16
-- propiedades. Y exponer el schema con PGRST_DB_SCHEMAS="public,brimmo"
-- en la config del contenedor de PostgREST, y reiniciarlo.
-- ============================================================================
