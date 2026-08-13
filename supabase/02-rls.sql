-- BRIMMO — Políticas de seguridad a nivel de fila (RLS)
-- Regla general:
--   Anónimo  → solo lee lo que el sitio necesita (propiedades published=true,
--              sus imágenes y los settings públicos).
--   Autenticado → hace todo (crear, editar, borrar, ver borradores).
-- El proyecto tiene un solo admin (Bruno). No hay auto-registro público:
-- el Signup se deja deshabilitado en el panel de Supabase Auth.

alter table public.propiedades       enable row level security;
alter table public.propiedad_imagenes enable row level security;
alter table public.settings          enable row level security;

-- ---------- propiedades ----------
drop policy if exists "publico_ve_publicadas"   on public.propiedades;
drop policy if exists "autenticado_hace_todo_p" on public.propiedades;

create policy "publico_ve_publicadas" on public.propiedades
  for select
  to anon
  using (published = true);

create policy "autenticado_hace_todo_p" on public.propiedades
  for all
  to authenticated
  using (true)
  with check (true);

-- ---------- propiedad_imagenes ----------
drop policy if exists "publico_ve_imagenes"     on public.propiedad_imagenes;
drop policy if exists "autenticado_hace_todo_i" on public.propiedad_imagenes;

create policy "publico_ve_imagenes" on public.propiedad_imagenes
  for select
  to anon
  using (exists (select 1 from public.propiedades p
                 where p.id = propiedad_imagenes.propiedad_id and p.published = true));

create policy "autenticado_hace_todo_i" on public.propiedad_imagenes
  for all
  to authenticated
  using (true)
  with check (true);

-- ---------- settings ----------
drop policy if exists "publico_lee_settings"    on public.settings;
drop policy if exists "autenticado_edita_settings" on public.settings;

-- El sitio público necesita leerlos (teléfono, WhatsApp, redes)
create policy "publico_lee_settings" on public.settings
  for select
  to anon
  using (true);

create policy "autenticado_edita_settings" on public.settings
  for all
  to authenticated
  using (true)
  with check (true);
