// Ejecuta la lógica real del componente contra el índice, sin navegador.
const fs = require("fs");
const src = fs.readFileSync("C:/Users/Neura/Neura/BRIMMO sitio completo revisión/index.html", "utf8")
  .match(/<script type="text\/x-dc"[^>]*>([\s\S]*?)<\/script>/)[1];

global.window = { L: null, matchMedia: () => ({ matches: false }), addEventListener() {}, scrollTo() {} };
global.document = { activeElement: null };
// setState real, para probar cambios de estado como en el runtime
class DCLogic {
  setState(patch, cb) {
    if (typeof patch === "function") patch = patch(this.state);
    Object.assign(this.state, patch);
    if (cb) cb();
  }
}
global.DCLogic = DCLogic;

const Component = new Function("DCLogic", src + "\n; return Component;")(DCLogic);
const c = new Component();
c.state = { screen: "properties", scrolled: false, t: 0, tPaused: false, q: "", type: "", city: "", price: "", detailId: 1, sent: false, hovered: null, lang: "es", menu: false };
c.tryMaps = () => {};

const fail = [];
const check = (name, cond, got) => { if (!cond) fail.push(`${name} -> ${JSON.stringify(got)}`); else console.log(`ok  ${name}`); };

const v = c.renderVals();

check("6 publicadas", c.publicadas().length === 6, c.publicadas().length);
check("16 en total", eval(src.match(/const DATA = \[[\s\S]*?\n\];/)[0] + "\nDATA.length") === 16, "?");
check("catalogo muestra 6", v.visible.length === 6, v.visible.length);
check("contador texto", v.resultCount === "6 propiedades disponibles", v.resultCount);
check("destacadas 5", v.featured.length === 5, v.featured.length);

const precios = v.visible.map(p => p.price);
check("precio Gs formateado", precios.some(p => /^Gs\. [\d.]+$/.test(p)), precios);
check("precio USD formateado", precios.some(p => /^USD [\d.]+$/.test(p)), precios);
check("ningun precio sin moneda", !precios.some(p => /confirmar/i.test(p)), precios);

const cats = v.categories.map(x => `${x.name}:${x.count}`);
check("categorias suman 6 y ninguna vacia", v.categories.reduce((a, x) => a + +x.count, 0) === 6 && v.categories.every(x => x.count !== "00"), cats);
console.log("    categorias:", cats.join(" "));

check("ciudades sin duplicar", new Set(v.ciudades).size === v.ciudades.length, v.ciudades);
console.log("    ciudades:", v.ciudades.join(", "));

check("contacto tel", v.tel === "+595 992 984 777", v.tel);
check("whatsapp limpio", v.waHref === "https://wa.me/595992984777", v.waHref);
check("mailto", v.mailHref === "mailto:loginvest7@gmail.com", v.mailHref);

check("detalle con descripcion real", v.detailDesc.length > 80 && !/TODO/.test(v.detailDesc), v.detailDesc.slice(0, 50));
check("detalle features", Array.isArray(v.amenities) && v.amenities.length > 0, v.amenities);
check("testimonio real", /Bruno supo responder/.test(v.activeTestimonial), v.activeTestimonial.slice(0, 40));

// filtros
c.state.type = "Quinta";
check("filtro tipo Quinta", c.filtered().length === 1, c.filtered().map(p => p.title));
c.state.type = "";
c.state.city = "Caacupé";
check("filtro ciudad Caacupé", c.filtered().length === 3, c.filtered().map(p => p.title));
c.state.city = "";
c.state.price = "USD:0-160000";
const usd = c.filtered();
check("filtro precio USD no mezcla monedas", usd.every(p => p.currency === "USD"), usd.map(p => p.currency));
c.state.price = "GS:600000000-99999999999";
check("filtro precio Gs alto", c.filtered().every(p => p.currency === "GS"), c.filtered().map(p => p.title));
c.state.price = "";
c.state.q = "atyrá";
check("busqueda por zona", c.filtered().length >= 1, c.filtered().map(p => p.title));
c.state.q = "";

// ningún borrador se filtra al público
c.state.type = ""; c.state.city = ""; c.state.price = "";
const todosPub = c.filtered().every(p => p.published);
check("ningun borrador visible", todosPub, c.filtered().filter(p => !p.published).map(p => p.title));

console.log(fail.length ? "\nFALLOS:\n" + fail.join("\n") : "\nTodo OK");

// --- categorias fotograficas ---
const cats2 = c.renderVals().categories;
check("cada categoria tiene imagen", cats2.every(x => x.image && x.image.length > 10), cats2.map(x => x.image && x.image.slice(0,40)));
check("categoria con foto tiene alt", cats2.filter(x => !/^data:/.test(x.image)).every(x => x.alt && x.alt.length > 10), cats2.map(x => x.alt));
check("fallback sin alt (decorativo)", cats2.filter(x => /^data:/.test(x.image)).every(x => x.alt === ""), "ok");
check("aria descriptivo", cats2.every(x => /propiedad(es)? disponible/.test(x.aria)), cats2.map(x => x.aria));
const usadas = cats2.filter(x => !/^data:/.test(x.image)).map(x => x.image);
check("ninguna foto repetida entre categorias", new Set(usadas).size === usadas.length, usadas);
console.log("    categorias finales:", cats2.map(x => `${x.name}:${x.count}${/^data:/.test(x.image)?"(degradado)":"(foto)"}`).join(" "));
console.log(fail.length ? "FALLOS FINALES:\n"+fail.join("\n") : "");

// --- fotos en tarjetas ---
const vis = c.renderVals().visible;
check("todas las tarjetas tienen imagen", vis.every(p => p.image && p.image.length > 5), vis.map(p => p.image));
check("todas con foto real (no degradado)", vis.every(p => !/^data:/.test(p.image)), vis.filter(p=>/^data:/.test(p.image)).map(p=>p.title));
check("alt descriptivo en cada tarjeta", vis.every(p => p.alt && p.alt.includes("—")), vis.map(p => p.alt));
check("detalle con imagen", /uploads\/img\//.test(c.renderVals().detailImage), c.renderVals().detailImage);
const fotos = vis.map(p => p.image);
console.log("    reutilizadas:", fotos.length - new Set(fotos).size, "de", fotos.length);
vis.forEach(p => console.log("      " + p.image.replace("uploads/img/","").padEnd(38) + p.title));
console.log(fail.length ? "FALLOS:\n"+fail.join("\n") : "\nTodo OK (fotos)");

// --- pantallas Nosotros y Servicios ---
const pantallas = ["home","properties","detail","nosotros","servicios"];
pantallas.forEach(p => {
  c.state.screen = p;
  const r = c.renderVals();
  const activas = ["isHome","isProps","isDetail","isNosotros","isServicios"].filter(k => r[k]);
  check(`pantalla ${p}: exactamente una activa`, activas.length === 1, activas);
});
c.state.screen = "nosotros";
let r2 = c.renderVals();
check("nosotros marca su nav", r2.actNosotros !== "transparent" && r2.actServicios === "transparent", [r2.actNosotros, r2.actServicios]);
check("nosotros: header solido", r2.barOpacity === 1, r2.barOpacity);
c.state.screen = "servicios";
r2 = c.renderVals();
check("servicios marca su nav", r2.actServicios !== "transparent" && r2.actNosotros === "transparent", [r2.actServicios, r2.actNosotros]);
check("servicios expone services y steps", r2.services.length === 6 && r2.steps.length === 4, [r2.services.length, r2.steps.length]);
check("handlers de seccion existen", typeof r2.goContacto === "function" && typeof r2.goZona === "function", "ok");
c.state.screen = "properties";
console.log(fail.length ? "FALLOS:\n"+fail.join("\n") : "\nTodo OK (pantallas)");

// --- menú móvil e idiomas ---
c.state.screen = "home"; c.state.menu = false;
let m = c.renderVals();
check("menu cerrado inicialmente", m.menuCerrado === true && m.menuAbierto === false, [m.menuCerrado, m.menuAbierto]);
check("toggle es función", typeof m.toggleMenu === "function", typeof m.toggleMenu);
check("ariaMenu en cerrado", /Abrir|Ouvrir|Open/.test(m.menuAria), m.menuAria);
c.state.menu = true;
m = c.renderVals();
check("menu abierto refleja estado", m.menuAbierto === true && m.menuClase === "abierto", [m.menuAbierto, m.menuClase]);
check("ariaMenu en abierto", /Cerrar|Fermer|Close/.test(m.menuAria), m.menuAria);
c.state.menu = false;
// idiomas
check("expone t y lang", typeof m.t === "object" && ["es","fr","en"].indexOf(m.lang) !== -1, {t:!!m.t, lang:m.lang});
check("tres idiomas disponibles", m.idiomas.length === 3, m.idiomas.map(i=>i.code));
const activos = m.idiomas.filter(i => i.activo);
check("exactamente un idioma activo", activos.length === 1, activos.map(i=>i.code));
check("cambiarIdioma no rompe", (function(){ try { c.cambiarIdioma("fr"); const mv=c.renderVals(); const ok = mv.lang === "fr" && mv.t.navInicio === "Accueil"; c.cambiarIdioma("es"); return ok; } catch(e) { return false; } })(), "?");
// operación no debe romper el color del chip
c.state.screen = "properties";
const chips = c.renderVals().visible;
check("cada tarjeta tiene tagBg valido", chips.every(x => x.tagBg === "#1F5A36" || x.tagBg === "#7E9848"), chips.map(x=>x.tagBg));
c.cambiarIdioma("fr");
const chipsFr = c.renderVals().visible;
check("tagBg sigue calculandose bien en francés", chipsFr.every(x => x.tagBg === "#1F5A36" || x.tagBg === "#7E9848"), chipsFr.map(x=>x.tagBg));
check("operación traducida en francés", chipsFr[0].operation === "À VENDRE", chipsFr[0].operation);
c.cambiarIdioma("es");
console.log(fail.length ? "\nFALLOS:\n"+fail.join("\n") : "\nTodo OK (menú móvil e idiomas)");
