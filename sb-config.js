// BRIMMO — Credenciales de Supabase
// Este archivo lo leen tanto index.html (sitio público) como admin.html.
// Pegar los valores del proyecto Supabase y hacer push.
//
// NO poner acá la service_role key — la anon (pública) es la única
// que va en el frontend, y RLS se encarga de limitar qué puede hacer.
window.SUPABASE_URL = "https://api.neura.com.py";
window.SUPABASE_ANON_KEY = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJyb2xlIjoiYW5vbiIsImlzcyI6InN1cGFiYXNlIiwiaWF0IjoxNzc0MTAxNDYxLCJleHAiOjE5MzE3ODE0NjF9.7_wAph8IolPMXtgfpezSwS5XR62IdD__qhqCywLDp3Q";
window.SUPABASE_BUCKET = "brimmo-imagenes";
