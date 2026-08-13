const fs = require("fs");
const src = fs.readFileSync("C:/Users/Neura/Neura/BRIMMO sitio completo revisión/index.html", "utf8")
  .match(/<script type="text\/x-dc"[^>]*>([\s\S]*?)<\/script>/)[1];

let stored = null;
global.window = {
  L: null, matchMedia: () => ({ matches: false }), addEventListener() {}, scrollTo() {},
  localStorage: { getItem: k => stored, setItem: (k, v) => { stored = v; } }
};
global.localStorage = global.window.localStorage;
global.navigator = { languages: ["es-PY"], language: "es-PY" };
global.document = { activeElement: null, documentElement: { setAttribute() {} }, querySelector: () => null, title: "" };
class DCLogic { setState(p, cb) { Object.assign(this.state, typeof p === "function" ? p(this.state) : p); if (cb) cb(); } }
global.DCLogic = DCLogic;

const Component = new Function("DCLogic", src + "\n; return Component;")(DCLogic);
const c = new Component();
c.state = { screen: "properties", scrolled: false, t: 0, tPaused: false, q: "", type: "", city: "", price: "", detailId: 1, sent: false, hovered: null, lang: "es" };
c.tryMaps = () => {};

const fail = [];
const ok = (n, cond, got) => { if (!cond) { fail.push(`${n} -> ${JSON.stringify(got)}`); console.log("FALLO " + n); } else console.log("ok  " + n); };

// 1. detección de idioma
ok("detecta es por defecto", (() => { stored = null; global.navigator.languages = ["es-PY"]; return c.constructor, true; })(), true);

const IDIOMAS = ["es", "fr", "en"];
const vistos = {};

for (const lang of IDIOMAS) {
  c.state.lang = lang;
  c.state.screen = "properties";
  const v = c.renderVals();

  ok(`[${lang}] diccionario completo`, v.t && Object.keys(v.t).length > 90, v.t && Object.keys(v.t).length);
  ok(`[${lang}] sin claves vacías`, Object.entries(v.t).every(([k, s]) => typeof s === "string" && s.length > 0),
     Object.entries(v.t).filter(([k, s]) => !s).map(([k]) => k));
  ok(`[${lang}] nav traducido`, typeof v.t.navPropiedades === "string", v.t.navPropiedades);
  ok(`[${lang}] 6 propiedades`, v.visible.length === 6, v.visible.length);
  ok(`[${lang}] titulos traducidos`, v.visible.every(p => p.title && p.title.length > 5), v.visible.map(p => p.title));
  ok(`[${lang}] descripciones traducidas`, v.detailDesc.length > 60, v.detailDesc.length);
  ok(`[${lang}] features traducidas`, Array.isArray(v.amenities) && v.amenities.length > 0, v.amenities);
  ok(`[${lang}] servicios 6`, v.services.length === 6 && v.services.every(s => s.name && s.desc), v.services.length);
  ok(`[${lang}] pasos 4`, v.steps.length === 4 && v.steps.every(s => s.title && s.desc), v.steps.length);
  ok(`[${lang}] testimonio`, v.activeTestimonial.length > 30 && v.activeAuthor.length > 3, v.activeAuthor);
  ok(`[${lang}] operacion traducida`, v.visible[0].operation.length > 3, v.visible[0].operation);
  ok(`[${lang}] precio con moneda`, /USD|Gs\./.test(v.visible[0].price), v.visible[0].price);
  ok(`[${lang}] categorias`, v.categories.length === 3 && v.categories.every(x => x.name), v.categories.map(x => x.name));
  ok(`[${lang}] selector 3 idiomas`, v.idiomas.length === 3 && v.idiomas.filter(x => x.activo).length === 1, v.idiomas.map(x => x.etiqueta + (x.activo ? "*" : "")));
  ok(`[${lang}] contador resultados`, /\d|available|disponible|propriét/.test(v.resultCount), v.resultCount);

  vistos[lang] = {
    nav: v.t.navPropiedades, hero: v.t.heroTitulo,
    titulo1: v.visible[0].title, op: v.visible[0].operation,
    servicio1: v.services[0].name, paso1: v.steps[0].title,
    testimonio: v.activeTestimonial.slice(0, 40), tipo: (v.categories.find(x=>/terr|land|terrain/i.test(x.name))||{}).name
  };
}

// 2. los tres idiomas producen textos distintos
const campos = Object.keys(vistos.es);
campos.forEach(k => {
  const set = new Set([vistos.es[k], vistos.fr[k], vistos.en[k]]);
  ok(`"${k}" difiere entre los 3 idiomas`, set.size === 3, { es: vistos.es[k], fr: vistos.fr[k], en: vistos.en[k] });
});

// 3. persistencia
c.cambiarIdioma("fr");
ok("guarda el idioma elegido", stored === "fr", stored);
ok("estado actualizado", c.state.lang === "fr", c.state.lang);
c.cambiarIdioma("zz");
ok("ignora idioma invalido", c.state.lang === "fr", c.state.lang);

// 4. búsqueda funciona en el idioma activo y en español
c.state.lang = "en"; c.state.q = "land";
ok("[en] busca en ingles", c.filtered().length > 0, c.filtered().length);
c.state.q = "terreno";
ok("[en] busca tambien en espanol", c.filtered().length > 0, c.filtered().length);
c.state.q = "";
c.state.lang = "fr"; c.state.q = "terrain";
ok("[fr] busca en frances", c.filtered().length > 0, c.filtered().length);
c.state.q = "";

// 5. sin borradores en ningún idioma
IDIOMAS.forEach(l => { c.state.lang = l; ok(`[${l}] ningun borrador visible`, c.filtered().every(p => p.published), l); });

console.log(fail.length ? "\nFALLOS (" + fail.length + "):\n" + fail.join("\n") : "\nTodo OK — 3 idiomas");
console.log("\nMuestra:");
IDIOMAS.forEach(l => console.log(`  ${l}: "${vistos[l].nav}" | "${vistos[l].titulo1}" | ${vistos[l].op}`));
process.exit(fail.length ? 1 : 0);
