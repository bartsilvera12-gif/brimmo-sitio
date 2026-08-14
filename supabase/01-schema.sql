-- BRIMMO — Schema aislado
-- Todo el proyecto vive dentro del schema "brimmo", no en "public".
-- Esto lo separa de otros proyectos que comparten la instancia self-hosted.
-- Idempotente: puede correrse varias veces sin romper nada.

-- ============================================================================
-- 1. Crear el schema propio del proyecto
-- ============================================================================
create schema if not exists brimmo;

-- Dar acceso al schema a los roles que la API usa.
-- Sin este grant PostgREST responde 404 aunque el schema exista.
grant usage on schema brimmo to anon, authenticated;

-- ============================================================================
-- 2. Tabla: brimmo.propiedades
-- Los campos "no traducibles" (precio, superficie, tipo) van sueltos.
-- Los "traducibles" van con sufijo _es/_fr/_en. El español es obligatorio.
-- ============================================================================
create table if not exists brimmo.propiedades (
  id            bigint primary key generated always as identity,

  -- Clasificación
  type          text not null,        -- Villa | Quinta | Terreno | Casa | Rancho | Departamento
  operation     text not null default 'VENTA',   -- VENTA | ALQUILER
  city          text not null,        -- ciudad principal, se usa para el mapa

  -- Precio y superficie
  price         bigint,
  currency      text check (currency in ('USD','GS') or currency is null),
  land          integer,              -- superficie del terreno en m²
  built         integer,              -- superficie construida en m²
  beds          integer,
  baths         integer,

  -- Medios
  video_id      text,                 -- ID de YouTube (11 caracteres), null si no hay
  maps_short    text,                 -- URL corta para compartir (goo.gl/maps/…, maps.app.goo.gl/…)
  maps_long     text,                 -- URL de embed (iframe src)
  lat           numeric(9,6),
  lng           numeric(9,6),

  -- Contenido traducible
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
  published     boolean not null default false,     -- si aparece en el sitio
  featured      boolean not null default false,     -- si aparece en el carrusel "Destacadas"
  pendiente     text,                                -- nota interna: dato a confirmar
  orden         integer not null default 0,          -- orden en el catálogo (menor primero)

  created_at    timestamptz not null default now(),
  updated_at    timestamptz not null default now()
);

create index if not exists propiedades_publicadas_orden on brimmo.propiedades (orden, id) where published = true;
create index if not exists propiedades_destacadas       on brimmo.propiedades (orden) where featured  = true and published = true;
create index if not exists propiedades_por_tipo         on brimmo.propiedades (type)  where published = true;
create index if not exists propiedades_por_ciudad       on brimmo.propiedades (city)  where published = true;

-- ============================================================================
-- 3. Tabla: brimmo.propiedad_imagenes
-- Cada fila apunta a un archivo del bucket "brimmo-imagenes".
-- La imagen "principal" es la que se muestra en tarjetas, popup del mapa y
-- galería del detalle. Una sola por propiedad (garantizado por índice único).
-- ============================================================================
create table if not exists brimmo.propiedad_imagenes (
  id            bigint primary key generated always as identity,
  propiedad_id  bigint not null references brimmo.propiedades(id) on delete cascade,
  storage_path  text not null,        -- path relativo dentro del bucket (ej: prop-12/foto-3.jpg)
  alt_es        text,                 -- texto alternativo, opcional
  alt_fr        text,
  alt_en        text,
  orden         integer not null default 0,
  es_principal  boolean not null default false,
  created_at    timestamptz not null default now()
);

create index if not exists imagenes_por_propiedad on brimmo.propiedad_imagenes (propiedad_id, orden);
create unique index if not exists imagenes_una_principal_por_propiedad
  on brimmo.propiedad_imagenes (propiedad_id) where es_principal;

-- ============================================================================
-- 4. Tabla: brimmo.settings
-- Fila única (id=1) con los datos de contacto que el admin puede editar.
-- ============================================================================
create table if not exists brimmo.settings (
  id            integer primary key default 1,
  telefono      text,                 -- ej: "+595 992 984 777"
  whatsapp      text,                 -- solo dígitos, ej: "595992984777"
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
-- 5. Trigger para mantener updated_at automáticamente
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
-- 6. Permisos base para los roles de la API
-- RLS se define en 02-rls.sql, pero los roles necesitan el grant primero.
-- ============================================================================
grant select on brimmo.propiedades       to anon, authenticated;
grant select on brimmo.propiedad_imagenes to anon, authenticated;
grant select on brimmo.settings          to anon, authenticated;

grant insert, update, delete on brimmo.propiedades       to authenticated;
grant insert, update, delete on brimmo.propiedad_imagenes to authenticated;
grant insert, update, delete on brimmo.settings          to authenticated;

-- Las secuencias también necesitan permiso para poder insertar
grant usage, select on all sequences in schema brimmo to authenticated;
