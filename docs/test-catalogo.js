// Ejecuta la lógica real del componente contra el índice, sin navegador.
const fs = require("fs");
const src = fs.readFileSync("C:/Users/Neura/Neura/BRIMMO sitio completo revisión/index.html", "utf8")
  .match(/<script type="text\/x-dc"[^>]*>([\s\S]*?)<\/script>/)[1];

global.window = { L: null, matchMedia: () => ({ matches: false }), addEventListener() {}, scrollTo() {} };
global.document = { activeElement: null };
class DCLogic { setState() {} }
global.DCLogic = DCLogic;

const Component = new Function("DCLogic", src + "\n; return Component;")(DCLogic);
const c = new Component();
c.state = { screen: "properties", scrolled: false, t: 0, tPaused: false, q: "", type: "", city: "", price: "", detailId: 1, sent: false, hovered: null };
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
process.exit(fail.length ? 1 : 0);
