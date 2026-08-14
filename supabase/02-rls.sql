-- BRIMMO — Políticas de seguridad a nivel de fila (RLS)
-- Regla general:
--   Anónimo  → solo lee lo que el sitio necesita (propiedades published=true,
--              sus imágenes y los settings públicos).
--   Autenticado → hace todo (crear, editar, borrar, ver borradores).
-- El proyecto tiene un solo admin (Bruno). No hay auto-registro público:
-- el Signup se deja deshabilitado en el panel de Supabase Auth.

alter table brimmo.propiedades       enable row level security;
alter table brimmo.propiedad_imagenes enable row level security;
alter table brimmo.settings          enable row level security;

-- ---------- brimmo.propiedades ----------
drop policy if exists "publico_ve_publicadas"   on brimmo.propiedades;
drop policy if exists "autenticado_hace_todo_p" on brimmo.propiedades;

create policy "publico_ve_publicadas" on brimmo.propiedades
  for select
  to anon
  using (published = true);

create policy "autenticado_hace_todo_p" on brimmo.propiedades
  for all
  to authenticated
  using (true)
  with check (true);

-- ---------- brimmo.propiedad_imagenes ----------
drop policy if exists "publico_ve_imagenes"     on brimmo.propiedad_imagenes;
drop policy if exists "autenticado_hace_todo_i" on brimmo.propiedad_imagenes;

create policy "publico_ve_imagenes" on brimmo.propiedad_imagenes
  for select
  to anon
  using (exists (select 1 from brimmo.propiedades p
                 where p.id = propiedad_imagenes.propiedad_id and p.published = true));

create policy "autenticado_hace_todo_i" on brimmo.propiedad_imagenes
  for all
  to authenticated
  using (true)
  with check (true);

-- ---------- brimmo.settings ----------
drop policy if exists "publico_lee_settings"       on brimmo.settings;
drop policy if exists "autenticado_edita_settings" on brimmo.settings;

-- El sitio público necesita leerlos (teléfono, WhatsApp, redes)
create policy "publico_lee_settings" on brimmo.settings
  for select
  to anon
  using (true);

create policy "autenticado_edita_settings" on brimmo.settings
  for all
  to authenticated
  using (true)
  with check (true);
