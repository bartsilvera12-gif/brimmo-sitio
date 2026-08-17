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
