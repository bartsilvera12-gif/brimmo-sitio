# Deploy BRIMMO en Hostinger

El sitio es HTML estático. No hay build de código: solo hay que subir los archivos correctos y activar el HTTPS.

## Archivos que van al hosting

Ya están armados en `build/brimmo-hostinger.zip` (26 archivos, ~30 MB).

```
.htaccess              ← config Apache
index.html             ← sitio público
admin.html             ← panel administrador
sb-config.js           ← credenciales Supabase
support.js             ← runtime del sitio
favicon.png
assets/                ← logo e isotipo
uploads/img/           ← imágenes institucionales, categorías, propiedades
```

**No se suben** (son internos): `supabase/`, `docs/`, `uploads/propiedades-origen/`, `crear-bucket.html`, `.git/`.

## Cómo generar el ZIP

Desde la raíz del repo:

```bash
node docs/build-hostinger.js
```

Produce `build/brimmo-hostinger.zip`.

## Cómo subir a Hostinger

1. **hPanel → File Manager**.
2. Entrar a `public_html/`.
3. Si hay contenido de la web anterior (Wix), **borrarlo primero**. El sitio nuevo lo reemplaza.
4. Subir `brimmo-hostinger.zip`.
5. Click derecho → **Extract**. Sale el contenido con la estructura correcta.
6. Borrar el `.zip` para no dejarlo público.

O por FTP: subir el contenido de `build/hostinger/` (sin comprimir) directamente a `public_html/`.

## Antes de dar por bueno

1. **HTTPS** — en hPanel → SSL. Activar el certificado gratuito de Let's Encrypt para `immobilier-paraguay.com`. El `.htaccess` ya fuerza el redirect HTTP → HTTPS.
2. **Verificar** en el navegador:
   - `https://immobilier-paraguay.com/` — sitio público.
   - `https://immobilier-paraguay.com/admin.html` — login del admin (email + password que creaste en Supabase Auth).
   - `https://immobilier-paraguay.com/blank` — debería redirigir al catálogo (301).
3. **En Supabase** — agregar `https://immobilier-paraguay.com` a la lista de orígenes permitidos por CORS (si hay control desde el dashboard). En instancias self-hosted esto se maneja en la config del proxy.

## Después del deploy

Los cambios que Bruno haga en `admin.html` van a impactar el sitio **al instante** (el sitio consulta Supabase en cada carga). No hay que resubir nada al hostinger cuando se edita contenido.

Solo hay que resubir cuando se cambia el código: `index.html`, `admin.html`, `support.js`, `sb-config.js`. Corré `node docs/build-hostinger.js` de nuevo y volvés a subir el ZIP.

## Redirects incluidos en .htaccess

Las URLs viejas de la web Wix redirigen a lo más cercano del sitio nuevo:

| URL vieja | Redirige a |
|---|---|
| `/blank` | catálogo |
| `/paraguay` | sección "La zona" |
| `/services-7` | página Servicios |
| `/book-online` | contacto |
| `/mentions-legales` | contacto |
| `/politique-de-confidentialite` | contacto |
| `/conditions-d-utilisation` | contacto |
| `/politique-en-matiere-de-cookies` | contacto |

Todos con código 301 (redirect permanente) — Google actualiza los enlaces indexados.
