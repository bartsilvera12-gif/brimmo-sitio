-- BRIMMO — Schema para contenido editable de las páginas Servicios y Nosotros
-- Correr después de las migraciones 01-04.

-- ============================================================================
-- Tabla: brimmo.textos (institucionales por página, keyed)
-- Cada fila es un string editable: page + key identifica el lugar en el sitio.
-- Ejemplos:
--   ('servicios','banda_title','Acompañamiento en cada etapa','Un accompagnement à chaque étape','Support at every stage')
--   ('nosotros','trabajamos_p1','Operamos en Caacupé...','Nous opérons à Caacupé...','We operate in Caacupé...')
-- ============================================================================
create table if not exists brimmo.textos (
  id         bigint primary key generated always as identity,
  page       text   not null,
  key        text   not null,
  valor_es   text   not null,
  valor_fr   text,
  valor_en   text,
  updated_at timestamptz not null default now(),
  constraint textos_page_key unique (page, key)
);

-- ============================================================================
-- Tabla: brimmo.servicios (lista de la página Servicios)
-- ============================================================================
create table if not exists brimmo.servicios (
  id         bigint primary key generated always as identity,
  orden      integer not null default 0,
  name_es    text not null,
  name_fr    text,
  name_en    text,
  desc_es    text,
  desc_fr    text,
  desc_en    text,
  activo     boolean not null default true,
  updated_at timestamptz not null default now()
);
create index if not exists servicios_orden on brimmo.servicios (orden) where activo;

-- ============================================================================
-- Tabla: brimmo.pasos (proceso "Cómo trabajamos" en la página Servicios)
-- ============================================================================
create table if not exists brimmo.pasos (
  id         bigint primary key generated always as identity,
  orden      integer not null default 0,
  numero     text not null default '',
  title_es   text not null,
  title_fr   text,
  title_en   text,
  desc_es    text,
  desc_fr    text,
  desc_en    text,
  updated_at timestamptz not null default now()
);
create index if not exists pasos_orden on brimmo.pasos (orden);

-- ============================================================================
-- Tabla: brimmo.valores (bloque de valores de la marca en Nosotros)
-- ============================================================================
create table if not exists brimmo.valores (
  id         bigint primary key generated always as identity,
  orden      integer not null default 0,
  title_es   text not null,
  title_fr   text,
  title_en   text,
  desc_es    text,
  desc_fr    text,
  desc_en    text,
  updated_at timestamptz not null default now()
);
create index if not exists valores_orden on brimmo.valores (orden);

-- ============================================================================
-- Tabla: brimmo.testimonios (carrusel en la home)
-- ============================================================================
create table if not exists brimmo.testimonios (
  id         bigint primary key generated always as identity,
  orden      integer not null default 0,
  author     text not null,        -- nombre real, NO se traduce
  text_es    text not null,
  text_fr    text,
  text_en    text,
  role_es    text,
  role_fr    text,
  role_en    text,
  activo     boolean not null default true,
  updated_at timestamptz not null default now()
);
create index if not exists testimonios_orden on brimmo.testimonios (orden) where activo;

-- ============================================================================
-- Trigger updated_at
-- ============================================================================
drop trigger if exists textos_touch      on brimmo.textos;
drop trigger if exists servicios_touch   on brimmo.servicios;
drop trigger if exists pasos_touch       on brimmo.pasos;
drop trigger if exists valores_touch     on brimmo.valores;
drop trigger if exists testimonios_touch on brimmo.testimonios;

create trigger textos_touch      before update on brimmo.textos      for each row execute function brimmo.set_updated_at();
create trigger servicios_touch   before update on brimmo.servicios   for each row execute function brimmo.set_updated_at();
create trigger pasos_touch       before update on brimmo.pasos       for each row execute function brimmo.set_updated_at();
create trigger valores_touch     before update on brimmo.valores     for each row execute function brimmo.set_updated_at();
create trigger testimonios_touch before update on brimmo.testimonios for each row execute function brimmo.set_updated_at();

-- ============================================================================
-- Grants (mismo patrón que las tablas existentes)
-- ============================================================================
grant select                        on brimmo.textos       to anon, authenticated;
grant select                        on brimmo.servicios    to anon, authenticated;
grant select                        on brimmo.pasos        to anon, authenticated;
grant select                        on brimmo.valores      to anon, authenticated;
grant select                        on brimmo.testimonios  to anon, authenticated;

grant insert, update, delete        on brimmo.textos       to authenticated;
grant insert, update, delete        on brimmo.servicios    to authenticated;
grant insert, update, delete        on brimmo.pasos        to authenticated;
grant insert, update, delete        on brimmo.valores      to authenticated;
grant insert, update, delete        on brimmo.testimonios  to authenticated;

grant usage, select on all sequences in schema brimmo to authenticated;

-- ============================================================================
-- RLS: público lee, autenticado hace todo
-- ============================================================================
alter table brimmo.textos       enable row level security;
alter table brimmo.servicios    enable row level security;
alter table brimmo.pasos        enable row level security;
alter table brimmo.valores      enable row level security;
alter table brimmo.testimonios  enable row level security;

-- Public read
drop policy if exists "publico_ve_textos"       on brimmo.textos;
drop policy if exists "publico_ve_servicios"    on brimmo.servicios;
drop policy if exists "publico_ve_pasos"        on brimmo.pasos;
drop policy if exists "publico_ve_valores"      on brimmo.valores;
drop policy if exists "publico_ve_testimonios"  on brimmo.testimonios;

create policy "publico_ve_textos"       on brimmo.textos       for select to anon using (true);
create policy "publico_ve_servicios"    on brimmo.servicios    for select to anon using (activo);
create policy "publico_ve_pasos"        on brimmo.pasos        for select to anon using (true);
create policy "publico_ve_valores"      on brimmo.valores      for select to anon using (true);
create policy "publico_ve_testimonios"  on brimmo.testimonios  for select to anon using (activo);

-- Authenticated does all
drop policy if exists "autenticado_edita_textos"       on brimmo.textos;
drop policy if exists "autenticado_edita_servicios"    on brimmo.servicios;
drop policy if exists "autenticado_edita_pasos"        on brimmo.pasos;
drop policy if exists "autenticado_edita_valores"      on brimmo.valores;
drop policy if exists "autenticado_edita_testimonios"  on brimmo.testimonios;

create policy "autenticado_edita_textos"       on brimmo.textos       for all to authenticated using (true) with check (true);
create policy "autenticado_edita_servicios"    on brimmo.servicios    for all to authenticated using (true) with check (true);
create policy "autenticado_edita_pasos"        on brimmo.pasos        for all to authenticated using (true) with check (true);
create policy "autenticado_edita_valores"      on brimmo.valores      for all to authenticated using (true) with check (true);
create policy "autenticado_edita_testimonios"  on brimmo.testimonios  for all to authenticated using (true) with check (true);
