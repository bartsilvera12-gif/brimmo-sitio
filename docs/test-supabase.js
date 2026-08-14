// Tests de la fase 2: conexión con Supabase, mapeo y cache.
// Simulamos un cliente Supabase y verificamos que el sitio se actualiza correctamente.
const fs = require("fs");
const src = fs.readFileSync("C:/Users/Neura/Neura/BRIMMO sitio completo revisión/index.html", "utf8")
  .match(/<script type="text\/x-dc"[^>]*>([\s\S]*?)<\/script>/)[1];

const store = {};
global.window = {
  L: null, matchMedia: () => ({ matches: false }), addEventListener() {}, scrollTo() {},
  localStorage: { getItem: k => store[k] || null, setItem: (k, v) => { store[k] = v; }, removeItem: k => { delete store[k]; } },
  supabase: null
};
global.localStorage = global.window.localStorage;
global.navigator = { languages: ["es-PY"], language: "es-PY" };
global.document = { activeElement: null, documentElement: { setAttribute() {} }, querySelector: () => null, title: "" };
global.console = console;
class DCLogic { setState(p, cb) { Object.assign(this.state, typeof p === "function" ? p(this.state) : p); if (cb) cb(); } }
global.DCLogic = DCLogic;

const Component = new Function("DCLogic", src + "\n; return { Component, mapearDeSupabase, urlImagen, idVideo, sbCliente };")(DCLogic);
const { mapearDeSupabase, urlImagen, idVideo, sbCliente } = Component;

const fail = [];
const ok = (n, cond, got) => { if (!cond) { fail.push(`${n} -> ${JSON.stringify(got)}`); console.log("FALLO " + n); } else console.log("ok  " + n); };

// 1. Sin credenciales: sbCliente devuelve null, DATA hardcoded intacto
ok("sbCliente() null sin credenciales", sbCliente() === null, sbCliente());

// 2. urlImagen construye path público correcto (aunque URL sea vacía por defecto)
// idVideo extrae ID de URL completa o del propio ID
ok("idVideo desde URL youtube.com", idVideo("https://www.youtube.com/watch?v=jb6os04D16A") === "jb6os04D16A", idVideo("https://www.youtube.com/watch?v=jb6os04D16A"));
ok("idVideo desde youtu.be", idVideo("https://youtu.be/jb6os04D16A") === "jb6os04D16A", idVideo("https://youtu.be/jb6os04D16A"));
ok("idVideo desde ID pelado", idVideo("jb6os04D16A") === "jb6os04D16A", idVideo("jb6os04D16A"));
ok("idVideo null si vacío", idVideo(null) === null && idVideo("") === null, [idVideo(null), idVideo("")]);

// 3. mapearDeSupabase transforma una fila real
const filaSupabase = {
  id: 100, published: true, pendiente: null,
  type: "Terreno", operation: "VENTA", city: "Atyrá",
  price: 50000, currency: "USD",
  land: 20000, built: null, beds: null, baths: null,
  video_id: "abc12345678",
  title_es: "Terreno de prueba", title_fr: "Terrain d'essai", title_en: "Test plot",
  zone_es: "Alto", zone_fr: "Haut", zone_en: "Upper",
  desc_es: "descripción es", desc_fr: "description fr", desc_en: "description en",
  features_es: ["a", "b"], features_fr: ["a-fr"], features_en: ["a-en"],
  propiedad_imagenes: [
    { storage_path: "prop-100/foto2.jpg", orden: 2, es_principal: false },
    { storage_path: "prop-100/foto1.jpg", orden: 1, es_principal: true },
    { storage_path: "prop-100/foto3.jpg", orden: 3, es_principal: false }
  ]
};
const { propiedad, traducciones } = mapearDeSupabase(filaSupabase);
ok("mapea id", propiedad.id === 100, propiedad.id);
ok("mapea title al español base", propiedad.title === "Terreno de prueba", propiedad.title);
ok("mapea features_es", JSON.stringify(propiedad.features) === '["a","b"]', propiedad.features);
ok("traducciones fr", traducciones.fr.title === "Terrain d'essai", traducciones.fr.title);
ok("traducciones en", traducciones.en.title === "Test plot", traducciones.en.title);
ok("imagen principal es la marcada", /foto1\.jpg$/.test(propiedad.image || ""), propiedad.image);
ok("galería excluye la principal y ordena", propiedad.gallery.length === 2 && /foto2/.test(propiedad.gallery[0]) && /foto3/.test(propiedad.gallery[1]), propiedad.gallery);

// 4. Sin imágenes marcadas: la primera por orden es la principal
const filaSinPrincipal = { ...filaSupabase, id: 101, propiedad_imagenes: [
  { storage_path: "x/2.jpg", orden: 2, es_principal: false },
  { storage_path: "x/1.jpg", orden: 1, es_principal: false }
]};
const r2 = mapearDeSupabase(filaSinPrincipal);
ok("fallback: primera por orden como principal", /1\.jpg$/.test(r2.propiedad.image), r2.propiedad.image);

// 5. Sin imágenes: propiedad.image queda null, galería vacía
const sinFotos = { ...filaSupabase, id: 102, propiedad_imagenes: [] };
const r3 = mapearDeSupabase(sinFotos);
ok("sin fotos: image null", r3.propiedad.image === null, r3.propiedad.image);
ok("sin fotos: gallery vacía", r3.propiedad.gallery.length === 0, r3.propiedad.gallery);

// 6. Componente: aplicarSnapshot reemplaza DATA y respeta detailId
const c = new Component.Component();
c.state = { screen: "properties", scrolled: false, t: 0, tPaused: false, q: "", type: "", city: "", price: "", detailId: 1, sent: false, hovered: null, lang: "es", menu: false };
c.tryMaps = () => {};
const antesConteo = c.publicadas().length;
c.aplicarSnapshot({
  propiedades: [
    { id: 500, published: true, title: "Nueva 1", type: "Villa", operation: "VENTA", city: "Caacupé", price: 100, currency: "USD", features: [], desc: "" },
    { id: 501, published: false, title: "Nueva 2", type: "Terreno", operation: "VENTA", city: "Atyrá", price: 200, currency: "GS", features: [], desc: "" }
  ],
  traducciones: {},
  settings: { telefono: "+595 000 111 222", whatsapp: "595000111222", email: "nuevo@brimmo.com", facebook_url: "https://facebook.com/brimmo-nuevo" }
});
const v = c.renderVals();
ok("snapshot reemplaza DATA", c.publicadas().length === 1 && c.publicadas()[0].title === "Nueva 1", { antes: antesConteo, ahora: c.publicadas().length });
ok("detailId cae en primera si la anterior no existe", c.state.detailId === 500, c.state.detailId);
ok("settings actualiza tel", v.tel === "+595 000 111 222", v.tel);
ok("settings actualiza whatsapp limpio", v.waHref === "https://wa.me/595000111222", v.waHref);
ok("settings actualiza email", v.mailHref === "mailto:nuevo@brimmo.com", v.mailHref);
ok("settings actualiza facebook", v.facebookHref === "https://facebook.com/brimmo-nuevo", v.facebookHref);

// 6b. Snapshot vacío NO reemplaza el DATA hardcodeado (migración pendiente)
const c_b = new Component.Component();
c_b.state = { screen: "properties", scrolled: false, t: 0, tPaused: false, q: "", type: "", city: "", price: "", detailId: 1, sent: false, hovered: null, lang: "es", menu: false };
c_b.tryMaps = () => {};
const antesBackup = c_b.publicadas().length;
c_b.aplicarSnapshot({ propiedades: [], traducciones: {}, settings: { telefono: "+000" } });
ok("snapshot vacio conserva DATA local", c_b.publicadas().length === antesBackup, { antes: antesBackup, ahora: c_b.publicadas().length });
ok("settings sí se aplica aunque props vengan vacías", c_b.renderVals().tel === "+000", c_b.renderVals().tel);

// 7. Cache: aplicarCacheSiExiste lee de localStorage si es fresco
Object.keys(store).forEach(k => delete store[k]);
const snapCache = {
  propiedades: [{ id: 900, published: true, title: "Desde cache", type: "Villa", operation: "VENTA", city: "Caacupé", price: 1, currency: "USD", features: [], desc: "" }],
  traducciones: {},
  settings: null
};
store.brimmo_cache_v1 = JSON.stringify({ ts: Date.now(), snap: snapCache });
const c2 = new Component.Component();
c2.state = { ...c.state, detailId: 999 };
c2.tryMaps = () => {};
c2.aplicarCacheSiExiste();
ok("cache fresco se aplica", c2.publicadas().some(p => p.title === "Desde cache"), c2.publicadas().map(p => p.title));

// 8. Cache expirado se ignora
Object.keys(store).forEach(k => delete store[k]);
store.brimmo_cache_v1 = JSON.stringify({ ts: Date.now() - (25 * 60 * 60 * 1000), snap: snapCache });   // 25h atrás
const c3 = new Component.Component();
c3.state = { ...c.state };
c3.tryMaps = () => {};
const antesCache = c3.publicadas().length;
c3.aplicarCacheSiExiste();
ok("cache expirado NO se aplica", c3.publicadas().length === antesCache, { antes: antesCache, ahora: c3.publicadas().length });

// 9. Cache corrupto no rompe
store.brimmo_cache_v1 = "{esto no es JSON válido";
const c4 = new Component.Component();
c4.state = { ...c.state };
c4.tryMaps = () => {};
try { c4.aplicarCacheSiExiste(); ok("cache corrupto no rompe", true, "ok"); }
catch (e) { ok("cache corrupto no rompe", false, e.message); }

console.log(fail.length ? "\nFALLOS (" + fail.length + "):\n" + fail.join("\n") : "\nTodo OK — fase 2");
process.exit(fail.length ? 1 : 0);
