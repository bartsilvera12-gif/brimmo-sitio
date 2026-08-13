-- BRIMMO — Bucket público de imágenes de propiedades

insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
values (
  'brimmo-imagenes',
  'brimmo-imagenes',
  true,                                                       -- lectura pública
  10485760,                                                   -- 10 MB por archivo
  array['image/jpeg','image/png','image/webp','image/avif']
)
on conflict (id) do nothing;

-- Políticas del bucket
drop policy if exists "brimmo_lectura_publica"  on storage.objects;
drop policy if exists "brimmo_admin_sube"        on storage.objects;
drop policy if exists "brimmo_admin_actualiza"   on storage.objects;
drop policy if exists "brimmo_admin_borra"       on storage.objects;

create policy "brimmo_lectura_publica" on storage.objects
  for select
  to anon, authenticated
  using (bucket_id = 'brimmo-imagenes');

create policy "brimmo_admin_sube" on storage.objects
  for insert
  to authenticated
  with check (bucket_id = 'brimmo-imagenes');

create policy "brimmo_admin_actualiza" on storage.objects
  for update
  to authenticated
  using (bucket_id = 'brimmo-imagenes');

create policy "brimmo_admin_borra" on storage.objects
  for delete
  to authenticated
  using (bucket_id = 'brimmo-imagenes');
