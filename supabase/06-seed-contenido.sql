-- Seed de contenido editable (servicios, pasos, valores, testimonios, textos)
-- Idempotente: se filtra por (page,key) o por orden.

-- Textos institucionales de Servicios y Nosotros
insert into brimmo.textos (page, key, valor_es, valor_fr, valor_en) values ('servicios', 'banda_eyebrow', 'Servicios', 'Services', 'Services') on conflict (page, key) do nothing;
insert into brimmo.textos (page, key, valor_es, valor_fr, valor_en) values ('servicios', 'banda_title', 'Acompañamiento en cada etapa', 'Un accompagnement à chaque étape', 'Support at every stage') on conflict (page, key) do nothing;
insert into brimmo.textos (page, key, valor_es, valor_fr, valor_en) values ('servicios', 'banda_texto', 'Desde la búsqueda hasta la transferencia, trabajamos sobre propiedades que conocemos y con documentación verificada.', 'De la recherche au transfert, nous travaillons sur des biens que nous connaissons et dont les documents sont vérifiés.', 'From the search to the transfer, we work on properties we know and with verified paperwork.') on conflict (page, key) do nothing;
insert into brimmo.textos (page, key, valor_es, valor_fr, valor_en) values ('servicios', 'proceso_eyebrow', 'Proceso', 'Processus', 'Process') on conflict (page, key) do nothing;
insert into brimmo.textos (page, key, valor_es, valor_fr, valor_en) values ('servicios', 'proceso_title', 'Cómo trabajamos', 'Notre méthode', 'How we work') on conflict (page, key) do nothing;
insert into brimmo.textos (page, key, valor_es, valor_fr, valor_en) values ('nosotros', 'banda_eyebrow', 'BRIMMO', 'BRIMMO', 'BRIMMO') on conflict (page, key) do nothing;
insert into brimmo.textos (page, key, valor_es, valor_fr, valor_en) values ('nosotros', 'banda_title', 'Decisiones inmobiliarias con claridad, confianza y conocimiento local.', 'Des décisions immobilières avec clarté, confiance et connaissance du terrain.', 'Real estate decisions with clarity, confidence and local knowledge.') on conflict (page, key) do nothing;
insert into brimmo.textos (page, key, valor_es, valor_fr, valor_en) values ('nosotros', 'banda_texto', 'En BRIMMO te acompañamos en cada etapa de tu proyecto inmobiliario. Nuestra experiencia y conocimiento del mercado local nos permiten ofrecer una atención personalizada, cercana y enfocada en tus necesidades.', 'Chez BRIMMO, nous vous accompagnons à chaque étape de votre projet immobilier. Notre expérience et notre connaissance du marché local nous permettent d''offrir un service personnalisé, proche et attentif à vos besoins.', 'At BRIMMO we support you at every stage of your real estate project. Our experience and knowledge of the local market let us offer personal, close attention focused on what you need.') on conflict (page, key) do nothing;
insert into brimmo.textos (page, key, valor_es, valor_fr, valor_en) values ('nosotros', 'trabajamos_title', 'Trabajamos donde vivimos', 'Nous travaillons là où nous vivons', 'We work where we live') on conflict (page, key) do nothing;
insert into brimmo.textos (page, key, valor_es, valor_fr, valor_en) values ('nosotros', 'trabajamos_p1', 'Operamos en Caacupé y el departamento de Cordillera. Conocemos los caminos, las zonas y el estado real de cada propiedad, y eso nos permite decirte con franqueza si algo conviene o no.', 'Nous opérons à Caacupé et dans le département de Cordillera. Nous connaissons les routes, les quartiers et l''état réel de chaque bien, ce qui nous permet de vous dire franchement si une opportunité vaut la peine.', 'We operate in Caacupé and the Cordillera department. We know the roads, the areas and the real condition of each property, which lets us tell you frankly whether something is worth it.') on conflict (page, key) do nothing;
insert into brimmo.textos (page, key, valor_es, valor_fr, valor_en) values ('nosotros', 'trabajamos_p2', 'Acompañamos tanto a quien busca un terreno para construir como a quien evalúa una inversión mayor, y seguimos el proceso hasta la transferencia.', 'Nous accompagnons aussi bien celui qui cherche un terrain à bâtir que celui qui évalue un investissement plus important, et nous suivons le processus jusqu''au transfert.', 'We work with people looking for a plot to build on and with those weighing a larger investment, and we follow the process through to transfer.') on conflict (page, key) do nothing;

-- Servicios (6)
insert into brimmo.servicios (orden, name_es, name_fr, name_en, desc_es, desc_fr, desc_en)
select 10, 'Terrenos rurales', 'Terrains ruraux', 'Rural land', 'Campos, chacras y fracciones con título e impuestos en regla.', 'Champs et parcelles avec titre et taxes en règle.', 'Fields and parcels with title and taxes in order.'
where not exists (select 1 from brimmo.servicios where name_es = 'Terrenos rurales');
insert into brimmo.servicios (orden, name_es, name_fr, name_en, desc_es, desc_fr, desc_en)
select 20, 'Villas y casas', 'Villas et maisons', 'Villas and houses', 'Propiedades residenciales en Caacupé y alrededores.', 'Biens résidentiels à Caacupé et alentours.', 'Residential property in Caacupé and nearby.'
where not exists (select 1 from brimmo.servicios where name_es = 'Villas y casas');
insert into brimmo.servicios (orden, name_es, name_fr, name_en, desc_es, desc_fr, desc_en)
select 30, 'Quintas', 'Quintas', 'Country homes', 'Casas de campo con arboleda, quincho y espacio para proyectos.', 'Maisons de campagne avec arbres, quincho et espace pour des projets.', 'Rural houses with trees, barbecue area and room for projects.'
where not exists (select 1 from brimmo.servicios where name_es = 'Quintas');
insert into brimmo.servicios (orden, name_es, name_fr, name_en, desc_es, desc_fr, desc_en)
select 40, 'Ranchos', 'Ranchs', 'Ranches', 'Superficies grandes para producción, ganadería o loteamiento.', 'Grandes surfaces pour l''exploitation, l''élevage ou le lotissement.', 'Large holdings for farming, livestock or subdivision.'
where not exists (select 1 from brimmo.servicios where name_es = 'Ranchos');
insert into brimmo.servicios (orden, name_es, name_fr, name_en, desc_es, desc_fr, desc_en)
select 50, 'Inversión', 'Investissement', 'Investment', 'Oportunidades con potencial de valorización en La Cordillera.', 'Opportunités à fort potentiel de valorisation dans La Cordillera.', 'Opportunities with strong growth potential in La Cordillera.'
where not exists (select 1 from brimmo.servicios where name_es = 'Inversión');
insert into brimmo.servicios (orden, name_es, name_fr, name_en, desc_es, desc_fr, desc_en)
select 60, 'Acompañamiento', 'Accompagnement', 'Support', 'Documentación, mensura y gestión hasta la transferencia.', 'Documents, bornage et démarches jusqu''au transfert.', 'Paperwork, surveying and handling through to transfer.'
where not exists (select 1 from brimmo.servicios where name_es = 'Acompañamiento');

-- Pasos del proceso (4)
insert into brimmo.pasos (orden, numero, title_es, title_fr, title_en, desc_es, desc_fr, desc_en)
select 10, '01', 'Escuchamos tus objetivos', 'Nous écoutons vos objectifs', 'We listen to your goals', 'Entendemos qué buscás, tu plazo y tu presupuesto real.', 'Nous comprenons ce que vous cherchez, votre délai et votre budget réel.', 'We understand what you are looking for, your timeline and your real budget.'
where not exists (select 1 from brimmo.pasos where title_es = 'Escuchamos tus objetivos');
insert into brimmo.pasos (orden, numero, title_es, title_fr, title_en, desc_es, desc_fr, desc_en)
select 20, '02', 'Analizamos el mercado', 'Nous analysons le marché', 'We analyse the market', 'Comparamos valores y condiciones en La Cordillera.', 'Nous comparons les valeurs et les conditions dans La Cordillera.', 'We compare values and conditions across La Cordillera.'
where not exists (select 1 from brimmo.pasos where title_es = 'Analizamos el mercado');
insert into brimmo.pasos (orden, numero, title_es, title_fr, title_en, desc_es, desc_fr, desc_en)
select 30, '03', 'Seleccionamos oportunidades', 'Nous sélectionnons les opportunités', 'We select opportunities', 'Te presentamos solo lo que encaja con tu objetivo.', 'Nous ne présentons que ce qui correspond à votre objectif.', 'We only present what fits your goal.'
where not exists (select 1 from brimmo.pasos where title_es = 'Seleccionamos oportunidades');
insert into brimmo.pasos (orden, numero, title_es, title_fr, title_en, desc_es, desc_fr, desc_en)
select 40, '04', 'Cerramos con seguridad', 'Nous concluons en sécurité', 'We close safely', 'Documentación, negociación y acompañamiento hasta el final.', 'Documents, négociation et accompagnement jusqu''au bout.', 'Paperwork, negotiation and support all the way through.'
where not exists (select 1 from brimmo.pasos where title_es = 'Cerramos con seguridad');

-- Valores de la marca (bloque en Nosotros)
insert into brimmo.valores (orden, title_es, title_fr, title_en, desc_es, desc_fr, desc_en)
select 10, 'Confianza', 'Confiance', 'Trust', 'Decisiones claras y relaciones duraderas.', 'Des décisions claires et des relations durables.', 'Clear decisions and lasting relationships.'
where not exists (select 1 from brimmo.valores where title_es = 'Confianza');
insert into brimmo.valores (orden, title_es, title_fr, title_en, desc_es, desc_fr, desc_en)
select 20, 'Crecimiento', 'Croissance', 'Growth', 'Oportunidades que generan valor sostenible.', 'Des opportunités qui créent de la valeur durable.', 'Opportunities that create lasting value.'
where not exists (select 1 from brimmo.valores where title_es = 'Crecimiento');
insert into brimmo.valores (orden, title_es, title_fr, title_en, desc_es, desc_fr, desc_en)
select 30, 'Cercanía', 'Proximité', 'Closeness', 'Conocimiento local y atención humana.', 'Connaissance locale et attention humaine.', 'Local knowledge and human attention.'
where not exists (select 1 from brimmo.valores where title_es = 'Cercanía');
insert into brimmo.valores (orden, title_es, title_fr, title_en, desc_es, desc_fr, desc_en)
select 40, 'Estructura', 'Structure', 'Structure', 'Método, criterio y profesionalismo.', 'Méthode, discernement et professionnalisme.', 'Method, judgement and professionalism.'
where not exists (select 1 from brimmo.valores where title_es = 'Estructura');

-- Testimonios (3)
insert into brimmo.testimonios (orden, author, text_es, text_fr, text_en, role_es, role_fr, role_en)
select 10, 'Aline y Martin Rieux', 'Bruno supo responder a todas nuestras necesidades y nos encontró el terreno de nuestros sueños. Un servicio profesional y atento.', 'Bruno a su répondre à tous nos besoins et nous a trouvé le terrain de nos rêves. Un service professionnel et attentionné.', 'Bruno met every one of our needs and found us the land we had dreamed of. A professional and attentive service.', 'Compradores', 'Acheteurs', 'Buyers'
where not exists (select 1 from brimmo.testimonios where author = 'Aline y Martin Rieux' and text_es = 'Bruno supo responder a todas nuestras necesidades y nos encontró el terreno de nuestros sueños. Un servicio profesional y atento.');
insert into brimmo.testimonios (orden, author, text_es, text_fr, text_en, role_es, role_fr, role_en)
select 20, 'Sophie Duchamps', 'Nuestra experiencia en Caacupé fue muy positiva, excepcional. Más allá de lo inmobiliario, pudimos compartir nuestros proyectos: los consejos no tienen precio.', 'Notre expérience à Caacupé a été très positive, exceptionnelle. Au-delà de l''immobilier, nous avons pu partager nos projets : les conseils n''ont pas de prix.', 'Our experience in Caacupé was very positive, exceptional. Beyond the property itself, we were able to share our plans: the advice was priceless.', 'Compradora — Caacupé', 'Acheteuse — Caacupé', 'Buyer — Caacupé'
where not exists (select 1 from brimmo.testimonios where author = 'Sophie Duchamps' and text_es = 'Nuestra experiencia en Caacupé fue muy positiva, excepcional. Más allá de lo inmobiliario, pudimos compartir nuestros proyectos: los consejos no tienen precio.');
insert into brimmo.testimonios (orden, author, text_es, text_fr, text_en, role_es, role_fr, role_en)
select 30, 'Paul Rossi', 'Recomiendo a Bruno por su trato personalizado y su conocimiento del mercado local en La Cordillera. Una persona de confianza.', 'Je recommande Bruno pour son approche personnalisée et sa connaissance du marché local dans La Cordillera. Une personne de confiance.', 'I recommend Bruno for his personal approach and his knowledge of the local market in La Cordillera. Someone you can trust.', 'Comprador — La Cordillera', 'Acheteur — La Cordillera', 'Buyer — La Cordillera'
where not exists (select 1 from brimmo.testimonios where author = 'Paul Rossi' and text_es = 'Recomiendo a Bruno por su trato personalizado y su conocimiento del mercado local en La Cordillera. Una persona de confianza.');

-- Sección "Residencia y trámites" en la página Servicios
insert into brimmo.textos (page, key, valor_es, valor_fr, valor_en) values (
  'servicios', 'residencia_eyebrow',
  $brimmo$Trámites migratorios$brimmo$,
  $brimmo$Formalités d'immigration$brimmo$,
  $brimmo$Immigration formalities$brimmo$
) on conflict (page, key) do nothing;
insert into brimmo.textos (page, key, valor_es, valor_fr, valor_en) values (
  'servicios', 'residencia_titulo',
  $brimmo$Residencia y cédula$brimmo$,
  $brimmo$Résidence et cédula$brimmo$,
  $brimmo$Residency and cédula$brimmo$
) on conflict (page, key) do nothing;
insert into brimmo.textos (page, key, valor_es, valor_fr, valor_en) values (
  'servicios', 'residencia_contenido',
  $brimmo$## Atención
A diferencia de muchos prestadores, todos los gastos administrativos están incluidos: traducciones, registro, autenticaciones y transporte. **Todo entra.**

## Etapa 1 · Residencia temporaria

- Copia del pasaporte vigente.
- Copia íntegra del acta de nacimiento con apostilla, emitida y apostillada exclusivamente por el país de nacimiento del solicitante. Con menos de 3 meses de emisión.
- Certificado de antecedentes penales (bulletin N°3) con apostilla. Con menos de 3 meses de emisión.
- Si el solicitante tiene menos de 14 años, no se requiere certificado de antecedentes penales.

Plazo de entrega por las autoridades locales: 3 meses.

## Etapa 2 · Cédula de identidad

- Reunir los mismos documentos que para la solicitud de residencia y nosotros nos encargamos del resto.
- Una vez emitida, la cédula permite abrir cuentas bancarias, obtener licencia de conducir, crear una empresa, firmar contratos y participar plenamente en los sistemas económicos y administrativos de Paraguay.

## Etapa 3 · Residencia permanente (10 años, renovable)

- Los documentos a presentar son de origen local: deben justificar tu solvencia en Paraguay.
- El expediente se presenta a las autoridades 3 meses antes del final de la residencia temporaria y conviene prepararlo con bastante antelación según el caso.

Contactanos según el estatus que declares previamente: comerciante, jubilado, u otro.

## Tarifas · Residencia temporaria

- 1 persona: 10.600.000 Gs
- 2 personas: 9.000.000 Gs por persona
- Grupo de 3 o más: 10.200.000 Gs por persona

## Tarifas · Cédula de identidad

- 1 persona: 3.000.000 Gs
- 2 personas: 2.800.000 Gs por persona
- Grupo de 3 o más: 2.500.000 Gs por persona

## Opciones adicionales

- Apertura de RUC: sin cargo + gastos administrativos.
- Seguimiento y declaración mensual: 3.320.000 Gs por año (puede ser parcial), impuesto no incluido.
- Domiciliación: 3.500.000 Gs por año.
- Licencia de conducir: 1.200.000 Gs.
- Asistencia para compra inmobiliaria: 7.000.000 Gs.
- Expatour La Cordillera: 700.000 Gs por día.

## Residencia permanente

Presupuesto a medida según cada caso.$brimmo$,
  $brimmo$## Attention
Contrairement à beaucoup de prestataires, tous les frais administratifs sont inclus : traductions, enregistrement, authentifications et transport. **Tout est compris.**

## Étape 1 · Résidence temporaire

- Copie du passeport valide.
- Copie intégrale de l'acte de naissance avec apostille, délivré et apostillé exclusivement par le pays de naissance du demandeur. Moins de 3 mois d'ancienneté.
- Certificat de casier judiciaire (bulletin N°3) avec apostille. Moins de 3 mois d'ancienneté.
- Si le demandeur a moins de 14 ans, aucun certificat de casier judiciaire n'est requis.

Délai de délivrance par les autorités locales : 3 mois.

## Étape 2 · Cédula (carte d'identité)

- Rassembler les mêmes documents que pour la demande de résidence et nous nous occupons du reste.
- Une fois délivrée, la cédula permet d'ouvrir des comptes bancaires, d'obtenir un permis de conduire, de créer une entreprise, de signer des contrats et de participer pleinement aux systèmes économiques et administratifs du Paraguay.

## Étape 3 · Résidence permanente (10 ans, renouvelable)

- Les documents à présenter sont d'ordre local : ils doivent justifier votre solvabilité au Paraguay.
- Le dossier se présente aux autorités 3 mois avant la fin de la résidence temporaire et doit se préparer bien en amont selon votre cas.

Nous contacter selon votre statut déclaré au préalable : commerçant, retraité ou autre.

## Tarifs · Résidence temporaire

- 1 personne : 10 600 000 Gs
- 2 personnes : 9 000 000 Gs par personne
- Groupe de 3 ou plus : 10 200 000 Gs par personne

## Tarifs · Cédula (carte d'identité)

- 1 personne : 3 000 000 Gs
- 2 personnes : 2 800 000 Gs par personne
- Groupe de 3 ou plus : 2 500 000 Gs par personne

## Options complémentaires

- Ouverture du RUC : 0 + frais administratifs.
- Suivi et déclaration mensuelle : 3 320 000 Gs par an (peut être partiel), hors impôt.
- Domiciliation : 3 500 000 Gs par an.
- Permis de conduire : 1 200 000 Gs.
- Assistance à l'achat immobilier : 7 000 000 Gs.
- Expatour La Cordillera : 700 000 Gs par jour.

## Résidence permanente

Sur devis, selon chaque cas.$brimmo$,
  $brimmo$## Heads up
Unlike many providers, all administrative fees are included: translations, registration, authentications and transport. **Everything is covered.**

## Step 1 · Temporary residency

- A valid passport copy.
- A full birth certificate with apostille, issued and apostilled exclusively by the applicant's country of birth. Less than 3 months old.
- Criminal record certificate (bulletin N°3) with apostille. Less than 3 months old.
- Applicants under 14 don't need a criminal record certificate.

Delivery time from the local authorities: 3 months.

## Step 2 · Cédula (national ID card)

- Gather the same documents as for the residency application; we handle the rest.
- Once issued, the cédula lets you open bank accounts, get a driver's licence, register a company, sign contracts and take full part in Paraguay's economic and administrative systems.

## Step 3 · Permanent residency (10 years, renewable)

- The required paperwork is local: it must show your solvency in Paraguay.
- The file is submitted to the authorities 3 months before the end of the temporary residency and should be prepared well in advance depending on your case.

Contact us based on the status you declared upfront: merchant, retiree or other.

## Fees · Temporary residency

- 1 person: Gs. 10,600,000
- 2 people: Gs. 9,000,000 per person
- Group of 3 or more: Gs. 10,200,000 per person

## Fees · Cédula (national ID card)

- 1 person: Gs. 3,000,000
- 2 people: Gs. 2,800,000 per person
- Group of 3 or more: Gs. 2,500,000 per person

## Add-on services

- RUC opening: no fee + administrative costs.
- Monthly bookkeeping and reporting: Gs. 3,320,000 per year (can be partial), taxes not included.
- Business address: Gs. 3,500,000 per year.
- Driver's licence: Gs. 1,200,000.
- Real estate purchase assistance: Gs. 7,000,000.
- La Cordillera expat tour: Gs. 700,000 per day.

## Permanent residency

Quoted individually per case.$brimmo$
) on conflict (page, key) do nothing;
