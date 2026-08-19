// BRIMMO — Empaqueta los archivos públicos del sitio en build/brimmo-hostinger.zip
// Se ejecuta con:  node docs/build-hostinger.js
// Requiere 'zip' disponible en PATH (Git Bash / WSL / Linux / Mac).

const fs = require("fs");
const path = require("path");
const { execFileSync } = require("child_process");

const raiz = path.resolve(__dirname, "..");
const build = path.join(raiz, "build");
const dest = path.join(build, "hostinger");
const zipOut = path.join(build, "brimmo-hostinger.zip");

// Lista blanca de lo que va al hosting.
// Directorios se copian enteros (con exclusiones abajo).
const ARCHIVOS = [
  ".htaccess",
  "index.html",
  "admin.html",
  "sb-config.js",
  "support.js",
  "favicon.png"
];
const CARPETAS = ["assets", "uploads/img"];

// Exclusiones dentro de carpetas
const EXCLUIR = [
  /^uploads\/propiedades-origen/,
  /\.git/,
  /\.DS_Store/,
  /Thumbs\.db/
];

function limpiarDest() {
  if (fs.existsSync(dest)) fs.rmSync(dest, { recursive: true, force: true });
  fs.mkdirSync(dest, { recursive: true });
}

function copiarArchivo(rel) {
  const src = path.join(raiz, rel);
  if (!fs.existsSync(src)) { console.log("  falta:", rel); return 0; }
  const d = path.join(dest, rel);
  fs.mkdirSync(path.dirname(d), { recursive: true });
  fs.copyFileSync(src, d);
  return fs.statSync(src).size;
}

function copiarCarpeta(rel) {
  const src = path.join(raiz, rel);
  if (!fs.existsSync(src)) { console.log("  falta:", rel); return 0; }
  let total = 0;
  function recur(sub) {
    const dir = path.join(src, sub);
    for (const nombre of fs.readdirSync(dir)) {
      const relFull = path.join(rel, sub, nombre).replace(/\\/g, "/");
      if (EXCLUIR.some(re => re.test(relFull))) continue;
      const p = path.join(dir, nombre);
      const st = fs.statSync(p);
      if (st.isDirectory()) recur(path.join(sub, nombre));
      else {
        const d = path.join(dest, relFull);
        fs.mkdirSync(path.dirname(d), { recursive: true });
        fs.copyFileSync(p, d);
        total += st.size;
      }
    }
  }
  recur("");
  return total;
}

// ==============================================================
console.log("BRIMMO — empaquetado para Hostinger\n");
limpiarDest();

let total = 0;
for (const f of ARCHIVOS) {
  const b = copiarArchivo(f);
  console.log("  " + f.padEnd(30) + " " + (b ? Math.round(b / 1024) + " KB" : ""));
  total += b;
}
for (const c of CARPETAS) {
  const b = copiarCarpeta(c);
  console.log("  " + (c + "/").padEnd(30) + " " + Math.round(b / 1024) + " KB");
  total += b;
}
console.log("\nsubtotal: " + Math.round(total / 1024) + " KB");

// Empaquetar con adm-zip (Node puro, cross-platform). Los paths quedan
// con forward slashes, que es lo que Linux/Apache esperan.
// adm-zip está instalado en scratchpad/node_modules (fuera del repo).
if (fs.existsSync(zipOut)) fs.unlinkSync(zipOut);

let AdmZip;
try {
  AdmZip = require(path.join(__dirname, "../../..",
    "AppData/Local/Temp/claude/C--Users-Neura-Neura-BRIMMO-sitio-completo-revisi-n/de5c7380-1d4a-4b11-9c36-a7b058ab31a6/scratchpad/node_modules/adm-zip"));
} catch (e) {
  try { AdmZip = require("adm-zip"); }
  catch (e2) {
    console.error("\nadm-zip no está disponible. Instalalo con: npm install adm-zip");
    process.exit(1);
  }
}

function agregarRecursivo(zip, dirAbs, prefRel) {
  for (const nombre of fs.readdirSync(dirAbs)) {
    const abs = path.join(dirAbs, nombre);
    const rel = prefRel ? prefRel + "/" + nombre : nombre;
    const st = fs.statSync(abs);
    if (st.isDirectory()) agregarRecursivo(zip, abs, rel);
    else zip.addFile(rel, fs.readFileSync(abs));
  }
}

const zip = new AdmZip();
agregarRecursivo(zip, dest, "");
zip.writeZip(zipOut);
const zipSize = fs.statSync(zipOut).size;
console.log("\nZIP listo: " + zipOut.replace(raiz + path.sep, ""));
console.log("       tamaño: " + Math.round(zipSize / 1024) + " KB");
console.log("\nSubí el contenido de build/hostinger/  a la carpeta public_html/ de Hostinger");
console.log("(o el ZIP completo y lo descomprimís desde el File Manager).");
