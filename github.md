repo: bartsilvera12-gif/santerra
branch: main

## Last sync
date: 2026-08-12T19:36:44Z

### Updated in this project
- Analizado el repo Santerra (Next.js 14 + Tailwind + Framer Motion + Supabase + Leaflet) como base técnica.
- Creado el sistema visual BRIMMO (`BRIMMO Sitio.dc.html`): inicio, catálogo con mapa Leaflet real y detalle de propiedad.
- Tokens BRIMMO definidos (forest/lime/olive/stone/charcoal, Montserrat + Inter, ease-brimmo).
- Sin cambios escritos en el repositorio: este proyecto es la referencia de diseño para la implementación.

## Screen map
| Pantalla | Archivos del repo de referencia |
| --- | --- |
| Header / nav | components/Header.tsx |
| Hero | components/Hero.tsx, components/HeroActions.tsx |
| Destacadas | components/FeaturedProperties.tsx, lib/supabase/useLiveData.ts |
| Categorías / Servicios / Proceso | components/Categories.tsx, app/servicios/page.tsx, components/Process.tsx |
| Catálogo + mapa | app/propiedades/PropertiesClient.tsx, components/PropertiesMap.tsx, lib/maps.ts |
| Detalle | app/propiedades/PropertyDetail.tsx, components/PropertyGallery.tsx, components/PropertyLocation.tsx |
| Contacto / Footer | components/Contact.tsx, components/Footer.tsx |
| Tokens / metadata | tailwind.config.ts, app/globals.css, app/layout.tsx, lib/animations.ts |
