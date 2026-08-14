# BRIMMO — Setup Supabase

El proyecto vive en su propio schema (`brimmo`) dentro de una instancia
Supabase self-hosted compartida con otros proyectos de Neura. Esto lo aísla
del resto: nada choca con `public`, y quien administre BRIMMO es dueño de
sus propias tablas y políticas.

Toma unos 15 minutos.

## Requisito previo: exponer el schema `brimmo` a la API

**Antes de correr las migraciones**, quien administra la instancia
self-hosted tiene que agregar `brimmo` a la lista de schemas que
PostgREST expone. Sin este paso, la API responde 404 aunque el schema
exista.

En el `docker-compose.yml` (o donde estén las variables de entorno del
servicio `rest`/`postgrest`):

```yaml
environment:
  PGRST_DB_SCHEMAS: "public,brimmo"   # agregar brimmo a los que ya haya
```

Y reiniciar el contenedor de PostgREST (`docker compose restart rest`
o el nombre que tenga el servicio).

Para verificar que quedó expuesto, después del reinicio:

```bash
curl https://api.neura.com.py/rest/v1/ -H "apikey: TU_ANON_KEY" | grep brimmo
```

Debería listar los schemas disponibles.

## Migraciones

En **SQL Editor** del panel Supabase, ejecutar en orden:

0. `00-limpiar-public.sql` — **opcional**, solo si hay un intento previo en `public` que hay que descartar.
1. `01-schema.sql` — crea el schema `brimmo`, sus tres tablas, índices y triggers. Da `usage` a los roles `anon` y `authenticated`.
2. `02-rls.sql` — habilita RLS y define quién puede leer/escribir cada tabla.
3. `03-storage.sql` — crea el bucket público `brimmo-imagenes` (10 MB máx, JPEG/PNG/WebP/AVIF) y sus políticas.
4. `04-seed.sql` — inserta las 16 propiedades reales (6 publicadas + 10 borradores) en los tres idiomas.

Todos son idempotentes; se pueden correr de nuevo sin romper nada.

## Crear el usuario admin

En **Authentication → Users → Add user → Create new user**:

- **Email**: el que use Bruno para acceder al panel.
- **Password**: una fuerte.
- **Auto-confirm user**: marcado (sin esto no puede iniciar sesión).

Luego en **Authentication → Providers → Email**:

- **Confirm email**: desactivado.
- **Enable email signup**: desactivado — así nadie puede crear cuentas
  nuevas desde afuera.

## Credenciales para el sitio

En **Project Settings → API**, tomar:

- **Project URL** (ej: `https://api.neura.com.py`)
- **anon public** key (empieza con `eyJ…`)

Y pegarlas en `sb-config.js` (raíz del repo). El bucket ya está fijado
como `brimmo-imagenes`.

**No compartir la `service_role` key** — esa da acceso total y no es
necesaria para el frontend.

## Verificar

Después de las migraciones, correr `diagnostico.sql` en el SQL Editor.
Los resultados esperados:

1. **Schema `brimmo`**: aparece.
2. **RLS**: `t` en las tres tablas.
3. **Políticas**: 6 filas (2 por tabla), roles `{anon}` o `{authenticated}`.
4. **Buckets**: `brimmo-imagenes` con `public: true`.
5. **Políticas de storage**: 4 filas (`brimmo_lectura_publica`, `_admin_sube`, `_admin_actualiza`, `_admin_borra`).
6. **Propiedades**: 16 total, 6 publicadas.

Y desde fuera con la anon key:

```bash
curl https://api.neura.com.py/rest/v1/propiedades?select=id \
  -H "apikey: TU_ANON_KEY" -I | grep content-range
```

Debe devolver `content-range: 0-5/6` — solo las 6 publicadas. Si devuelve
`0-15/16`, RLS no está activa y los borradores están públicos.

Si algo falla, mandar el mensaje de error y lo revisamos.
