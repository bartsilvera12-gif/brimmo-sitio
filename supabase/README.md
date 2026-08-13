# BRIMMO — Setup Supabase

Estos son los pasos para preparar la base de datos, el storage y el usuario
admin en un proyecto Supabase existente.

Toma unos 10 minutos.

## 1. Correr las migraciones

Abrí **SQL Editor** en el panel del proyecto Supabase y ejecutá los archivos
en este orden, uno por vez:

1. `01-schema.sql` — crea las tablas `propiedades`, `propiedad_imagenes` y `settings`, con sus índices y triggers.
2. `02-rls.sql` — habilita RLS y define quién puede leer/escribir cada tabla.
3. `03-storage.sql` — crea el bucket público `brimmo-imagenes` (10 MB máx, JPEG/PNG/WebP/AVIF) y sus políticas.
4. `04-seed.sql` — inserta las 16 propiedades reales del sitio actual (6 publicadas + 10 borradores) en los tres idiomas. Idempotente: si ya existen no se duplican.

Todos son idempotentes; se pueden correr de nuevo sin romper nada.

## 2. Crear el usuario admin

En **Authentication → Users → Add user → Create new user**:

- **Email**: el de Bruno (o el que use para acceder al panel).
- **Password**: uno fuerte.
- **Auto-confirm user**: marcado (si no lo marcás, no puede iniciar sesión).

Luego en **Authentication → Providers → Email**, dejá **Confirm email**
en desactivado y **Enable email signup** en desactivado — esto evita que
alguien cree cuentas nuevas desde fuera.

## 3. Pasarme las credenciales

En **Project Settings → API** copiá:

- **Project URL** (algo como `https://abcxyz.supabase.co`)
- **anon public** key (empieza con `eyJ…`)

Con esas dos claves conecto el sitio y el panel admin. La `anon` es
segura para publicar en el frontend porque RLS limita qué puede hacer.

**No compartas la `service_role` key** — esa da acceso total y no la
necesito para nada.

## Verificación rápida

Después de correr los 4 SQL, en **Table Editor** deberías ver:

- 3 tablas: `propiedades` (16 filas), `propiedad_imagenes` (0 filas), `settings` (1 fila).
- Bucket `brimmo-imagenes` en **Storage**.
- 1 usuario en **Authentication → Users**.

Si algo falla, mandame el mensaje de error y lo revisamos.
