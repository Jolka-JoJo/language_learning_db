drop database if exists kalbu_programa_Peisokaite;
create schema kalbu_programa_Peisokaite default character set utf8mb4 collate utf8mb4_unicode_ci;
use kalbu_programa_Peisokaite;

create table vartotojas(
	ID int unsigned auto_increment primary key,
    vardas varchar(50) not null,
    pavarde varchar(50) not null,
    el_pastas varchar(50) not null unique,
    slaptazodis varchar(250) not null
);

create table role( 
	ID smallint unsigned auto_increment primary key,
    pavadinimas varchar(50) not null
);

create table vartotojo_role(
	vartotojo_id int unsigned not null,
    roles_id smallint unsigned not null,
    
	foreign key(vartotojo_id) references vartotojas(ID),
    foreign key(roles_id) references role(ID),
    
    primary key(vartotojo_id, roles_id)
);

create table kalba(
	kodas varchar(3) primary key
);

create table pagrindine_kalba(
	vartotojo_id int unsigned not null,
    kalbos_kodas varchar(3) not null,
    
	foreign key(vartotojo_id) references vartotojas(ID),
    foreign key(kalbos_kodas) references kalba(kodas),
    
    primary key(vartotojo_id, kalbos_kodas)
);

create table vartotojo_kalba(
	vartotojo_id int unsigned not null,
    kalbos_kodas varchar(3) not null,
    
	foreign key(vartotojo_id) references vartotojas(ID),
    foreign key(kalbos_kodas) references kalba(kodas),
    
    primary key(vartotojo_id, kalbos_kodas)
);

create table zodis(
	ID int unsigned auto_increment primary key,
    zodis varchar(50) not null,
    definicija varchar(250) not null
);

create table lygis(
	lygis varchar(2) primary key
);

create table kalbos_zodis(
	kalbos_kodas varchar(3) not null,
    zodzio_id int unsigned not null,
	zodis varchar(50) not null,
    audio varchar(250),
    tarimas_rastu varchar(50) not null,
    pavyzdys varchar(250),
	lygio_lygis varchar(2) not null,
    
    foreign key(kalbos_kodas) references kalba(kodas),
    foreign key(zodzio_id) references zodis(ID),
    foreign key(lygio_lygis) references lygis(lygis),
    
    primary key(kalbos_kodas, zodzio_id)
);

create table vartotojo_zodis(
    vartotojo_id int unsigned not null,
	kalbos_kodas varchar(3) not null,
    zodzio_id int unsigned not null,
    ismoktas boolean default 0,
    isimintas boolean default 0,
    
	foreign key(kalbos_kodas,zodzio_id) references kalbos_zodis(kalbos_kodas, zodzio_id),
    foreign key(vartotojo_id) references vartotojas(ID),
    
    primary key(kalbos_kodas,zodzio_id, vartotojo_id)
);


create table kalbos_vertimas(
	kalbos_kodas varchar(3) not null,
    pagr_kalbos_kodas varchar(3)not null,
	pavadinimas varchar(50) not null,
    aprasymas varchar(250),
    
    foreign key(kalbos_kodas) references kalba(kodas),
    foreign key(pagr_kalbos_kodas) references kalba(kodas),
    
    primary key(kalbos_kodas, pagr_kalbos_kodas)
);

create table rikiavimas(
	ID smallint unsigned auto_increment primary key,
    pavadinimas varchar(50) not null
);

create table kategorija(
	ID smallint unsigned auto_increment primary key,
    pavadinimas varchar(50) not null,
	rikiavimo_id smallint unsigned default 1,
    nuoroda varchar(250),
    aktyvi boolean default 1,
    
    foreign key(rikiavimo_id) references rikiavimas(ID)
);

create table kategorijos_vertimas(
	kalbos_kodas varchar(3) not null,
    kategorijos_id smallint unsigned not null,
	pavadinimas varchar(50) not null,
    
    foreign key(kalbos_kodas) references kalba(kodas),
    foreign key(kategorijos_id) references kategorija(ID),

    primary key(kalbos_kodas, kategorijos_id)
);

create table kategorijos_zodis(
    kategorijos_id smallint unsigned not null,
    zodzio_id int unsigned not null,
    
    foreign key(kategorijos_id) references kategorija(ID),
    foreign key(zodzio_id) references zodis(ID),
    
    primary key(kategorijos_id, zodzio_id)
);

create table pamoka(
	ID smallint unsigned auto_increment primary key,
    pavadinimas varchar(50) not null
);

create table pamokos_kalbos_zodis(
    pamokos_id smallint unsigned not null,
    zodzio_id int unsigned not null,
    kalbos_kodas varchar(3),
    
    foreign key(pamokos_id) references pamoka(ID),
    foreign key(zodzio_id) references zodis(ID),
    foreign key(kalbos_kodas) references kalba(kodas),
    
    primary key(pamokos_id, zodzio_id)
);

create table kalbos_pamoka(
    pagr_kalbos_kodas varchar(3) not null,
    pamokos_id smallint unsigned not null,
    pavadinimas varchar(50) not null,
    aprasymas varchar(250),

    foreign key(pagr_kalbos_kodas) references kalba(kodas),
    foreign key(pamokos_id) references pamoka(ID),
    
    primary key(pagr_kalbos_kodas, pamokos_id)
);

create table testas(
	ID smallint unsigned auto_increment primary key,
    pamokos_id smallint unsigned not null,
    pavadinimas varchar(50) not null,
    
     foreign key(pamokos_id) references pamoka(ID)
);

create table testo_kalba(
	pagr_kalbos_kodas varchar(3),
    testo_id smallint unsigned,
    pavadinimas varchar(50) not null,
    aprasymas varchar(250),
    
    foreign key(pagr_kalbos_kodas) references kalba(kodas),
	foreign key(testo_id) references testas(id) 
);

create table uzduotis(
	ID smallint unsigned auto_increment primary key,
    atsakymas varchar(50) not null,
    klausimas varchar(250) not null,
    testo_id smallint unsigned not null,
    
	foreign key(testo_id) references testas(ID)
);

-- su vartotoju susijusi informacija
insert into vartotojas (vardas, pavarde, el_pastas, slaptazodis)
values 
('Jonas','Jonaitis','jonasjonaitis@pastas.com', MD5('slaptazodis')),
('Petras','Petraitis','petraspetraitis@pastas.com', MD5('slaptazodis2')),
('Ona','Onaitė','onaonaite@pastas.com', MD5('slaptazodis3')),
('Kazytė','Kazytaitė','kazyte@pastas.com', MD5('slaptazodis4'));

insert into role (pavadinimas)
values
('adminas'),
('paprastas vartotojas');

insert into vartotojo_role values 
(1,2),
(2,2),
(2,1),
(3,1),
(4,2);

-- su kalba susijusi informacija
insert into lygis values 
('A1'),
('A2'),
('B1'),
('B2'),
('C1'),
('C2');

insert into  kalba  values 
('eng'),
('lit'),
('rus');

insert into vartotojo_kalba (vartotojo_id, kalbos_kodas)
values
(1,'eng'),
(2,'lit'),
(2,'rus'),
(4,'eng');

insert into pagrindine_kalba(vartotojo_id, kalbos_kodas)
values
(1,'lit'),
(2,'eng'),
(3,'lit'),
(4,'lit');

insert into kalbos_vertimas(kalbos_kodas, pagr_kalbos_kodas, pavadinimas)
values
('lit','lit','lietuvių'),
('eng','lit','anglų'),
('rus','lit','rusų'),
('lit','eng','Lithuanian'),
('eng','eng','English'),
('rus','eng','Rusian');

insert into zodis (zodis, definicija)
values 
('dog','a domesticated carnivorous mammal that typically has a long snout, an acute sense of smell, non-retractable claws, and a barking, howling, or whining voice.'),
('cat','a small domesticated carnivorous mammal with soft fur, a short snout, and retractable claws. It is widely kept as a pet or for catching mice, and many breeds have been developed.'),
('car','a four-wheeled road vehicle that is powered by an engine and is able to carry a small number of people.'),
('cow','a fully grown female animal of a domesticated breed of ox, kept to produce milk or beef'),
('rabbit','a gregarious burrowing plant-eating mammal, with long ears, long hind legs, and a short tail'),
('horse','a large plant-eating domesticated mammal with solid hoofs and a flowing mane and tail, used for riding, racing, and to carry and pull loads'),
('truck','a large, heavy road vehicle used for carrying goods, materials, or troops; a lorry'),
('bicycle','a vehicle consisting of two wheels held in a frame one behind the other, propelled by pedals and steered with handlebars attached to the front wheel'),
('potato','a starchy plant tuber which is one of the most important food crops, cooked and eaten as a vegetable'),
('cucumber','a long, green-skinned fruit with watery flesh, usually eaten raw in salads or pickled'),
('tomato','a glossy red, or occasionally yellow, pulpy edible fruit that is eaten as a vegetable or in salad'),
('pear','a yellowish- or brownish-green edible fruit that is typically narrow at the stalk and wider towards the base, with sweet, slightly gritty flesh'),
('apple','the round fruit of a tree of the rose family, which typically has thin green or red skin and crisp flesh'),
('tennis','a game in which two or four players strike a ball with rackets over a net stretched across a court. The usual form (originally called lawn tennis ) is played with a felt-covered hollow rubber ball on a grass, clay, or artificial surface'),
('basketball','a game played between two teams of five players in which goals are scored by throwing a ball through a netted hoop fixed at each end of the court');

insert into kalbos_zodis (kalbos_kodas, zodzio_id, zodis, tarimas_rastu, lygio_lygis)
values
('eng',1,'dog','dɒɡ','A1'),
('eng',2,'cat','kat','A1'),
('eng',3,'car','ka:','A1'),
('eng',4,'cow','kaʊ','A1'),
('eng',5,'rabbit','ˈrabɪt','A2'),
('eng',6,'horse','hɔːs','A2'),
('eng',7,'truck','trʌk','B1'),
('eng',8,'bicycle','ˈbʌɪsɪk(ə)l','A2'),
('eng',9,'potato','pəˈteɪtəʊ','A1'),
('eng',10,'cucumber','ˈkjuːkʌmbə','A1'),
('eng',11,'tomato','təˈmɑːtəʊ','A1'),
('eng',12,'pear','pɛː','A2'),
('eng',13,'apple','ˈap(ə)l','A1'),
('eng',14,'tennis','ˈtɛnɪs','A1'),
('eng',15,'basketball','ˈbɑːskɪtbɔːl','A1'),
('lit',1,'šuo','šuõ','A1'),
('lit',2,'katinas','','A1'),
('lit',3,'automobilis','','A2'),
('lit',4,'karvė','','A1'),
('lit',5,'kiškis','kìškis','A1'),
('lit',6,'arklys','arklỹs','A1'),
('lit',7,'sunkvežemis','sunkvežemis','B1'),
('lit',8,'dviratis','dvìratis','A2'),
('lit',9,'bulvė','bùlvė','A2'),
('lit',10,'agurkas','agur̃kas','A1'),
('lit',11,'pomidoras','pomidòras','A1'),
('lit',12,'kriaušė','kriáušė','A2'),
('lit',13,'obuolys','obuolỹs','A1'),
('lit',14,'tenisas','tènisas','A1'),
('lit',15,'krepšinis','krepšìnis','A1');

insert into vartotojo_zodis (vartotojo_id, kalbos_kodas, zodzio_ID, ismoktas, isimintas)
values
(1, 'eng', 1, 0, 1),
(1, 'eng', 3, 0, 1),
(1, 'eng', 5, 0, 1),
(1, 'eng', 6, 0, 1),
(2, 'eng', 7, 1, 1),
(2, 'eng', 1, 1, 0);

-- su kategorija susijusi informacija
insert into rikiavimas (pavadinimas)
values
('A-Z'),
('Z-A');

insert into kategorija (pavadinimas)
values 
('animals'),
('transport'),
('vegetables'),
('fruits'),
('sports');

insert into kategorijos_zodis (kategorijos_id, zodzio_id)
values
(1,1),
(1,2),
(2,3),
(1,4),
(1,5),
(1,6),
(2,7),
(2,8),
(3,9),
(3,10),
(3,11),
(4,12),
(4,13),
(5,14),
(5,15);

insert into kategorijos_vertimas (kalbos_kodas, kategorijos_id, pavadinimas)
values
('eng', 1, 'animals'),
('eng', 2, 'transport'),
('eng', 3, 'vegetables'),
('eng', 4, 'fruits'),
('eng', 5, 'sports'),
('lit', 1, 'gyvūnai'),
('lit', 2, 'transportas'),
('lit', 3, 'daržovės'),
('lit', 4, 'vaisiai'),
('lit', 5, 'sportas');

-- informacija susijusi su pamoka
insert into pamoka (pavadinimas) 
values
('Home'),
('Animals'),
('Traveling'),
('Vegetables'),
('Fruits'),
('Sports'),
('Namai'),
('Gyvūnai'),
('Kelionės'),
('Daržovės'),
('Vaisiai'),
('Sportas');

insert into kalbos_pamoka(pagr_kalbos_kodas, pamokos_id, pavadinimas, aprasymas)
values
('lit', 7, 'Namai', 'Išmok namo dalis'),
('eng', 1, 'Home','Learn about house parts'),
('lit', 8, 'Gyvūnai', 'Išmok gyvūnų pavadinimus'),
('eng', 2, 'Animals','Learn about animals and their names'),
('lit', 9, 'Kelionės', 'Sužinok apie transportą ir keliones'),
('eng', 3, 'Traveling','Lear about transport and trips'),
('eng', 4, 'Vegetables','Lear about vegetables'),
('eng', 5, 'Fruits','Lear about fruits'),
('eng', 6, 'Sports','Lear about sports'),
('lit', 10, 'Daržovės', 'Sužinok apie daržoves'),
('lit', 11, 'Vaisiai', 'Sužinok apie vaisius'),
('lit', 12, 'Sportas', 'Sužinok apie sportą');

insert into pamokos_kalbos_zodis (pamokos_id, zodzio_id, kalbos_kodas)
values
(2,1,'eng'),
(2,2,'eng'),
(3,3,'eng'),
(2,4,'eng'),
(2,5,'eng'),
(2,6,'eng'),
(3,7,'eng'),
(3,8,'eng'),
(4,9,'eng'),
(4,10,'eng'),
(4,11,'eng'),
(5,12,'eng'),
(5,13,'eng'),
(6,14,'eng'),
(6,15,'eng'),
(8,1,'lit'),
(8,2,'lit'),
(9,3,'lit'),
(8,4,'lit'),
(8,5,'lit'),
(8,6,'lit'),
(9,7,'lit'),
(9,8,'lit'),
(10,9,'lit'),
(10,10,'lit'),
(10,11,'lit'),
(11,12,'lit'),
(11,13,'lit'),
(12,14,'lit'),
(12,15,'lit');

insert into testas (pamokos_id, pavadinimas) 
values
(1, 'Main house parts'),
(1, 'Living room'),
(1, 'Kitchen'),
(2, 'Wild animals'),
(2, 'Pets'),
(3, 'Transport'),
(3, 'Directions'),
(5,'Fruits growing on tree'),
(6, 'Games with a ball'),
(8, 'Naminiai gyvūnai'),
(9, 'Transporto priemonės'),
(10, 'Daržovės'),
(11, 'Žaidimai su kamuoliu');

insert into testo_kalba(pagr_kalbos_kodas, testo_id, pavadinimas)
values
('lit', 1, 'Pagrindinės namo dalys'),
('lit', 2, 'Svetainė'),
('lit', 3, 'Virtuvė'),
('lit', 4, 'Laukiniai gyvūnai'),
('lit', 5, 'Naminiai gyvūnai'),
('lit', 6, 'Transportas'),
('lit', 7, 'Kelionės kryptys'),
('eng', 1, 'Main house parts'),
('eng', 2,  'Living room'),
('eng', 3,  'Kitchen'),
('eng', 4,  'Wild animals'),
('eng', 5,  'Pets'),
('eng', 6,  'Transport'),
('eng', 7,  'Directions'),
('lit', 7, 'Kryptys'),
('eng', 8,'Fruits growing on tree'),
('lit', 8, 'Vaisiai augantys ant medžio'),
('eng', 9, 'Games with a ball'),
('lit', 9, 'Žaidimai su kamuoliu'),
('lit', 10, 'Naminiai gyvūnai'),
('eng', 10,  'Pets'),
('lit', 11, 'Transporto priemonės'),
('eng', 11,  'Transport'),
('lit', 12, 'Daržovės'),
('eng', 12,  'Vegetables'),
('eng', 13, 'Games with a ball'),
('lit', 13, 'Žaidimai su kamuoliu');

insert into uzduotis (atsakymas, klausimas, testo_id)
values
('šuo', 'Dažniausiai pririštas prie būdos', 10),
('cat', 'This animal loves milk and caths mice', 5),
('rabbit', 'This animal usually known for eating carrots',4),
('cow', 'This animal gives us milk',4),
('horse', 'An animal for travelling and carrying things',5),
('car', 'The most common transport',6),
('bicycle', 'Two wheels transport',6),
('truck', 'Large transports for transporting things',6),
('pear', 'Sweet yellow or green fruit',8),
('apple', 'Usually red fruit. Common used in pies',8),
('tennis', 'Game with rackets',9),
('basketball', 'Game of throwing a ball through a netted hoop',9),
('katinas', 'Pieną mėgstantis gyvūnas, kuris gaudo peles',10),
('automobilis', 'Viena dažniausių transpoto priemonių',11),
('dviratis', 'Dviratė transpoto priemonė be motoro',11),
('sunkvežemis', 'Didelė transporto priemonė gabenti daiktams',11),
('bulvė', 'Iš šios daržovės gaminami cepelinai',12),
('agurkas', 'Žalia pailga daržovė naudojama salotoms',12),
('pomidoras', 'Raudona daržovė auganti šlitnamyje',12),
('tenisas', 'Žaidimas su raketėmis',13),
('krepšinis', 'Žaidimas, kurio metu mėtomas kamuolys per tinklą',13);

-- Vartotojai, kurie mokosi kalbų. Informacija, kokias kalbas mokosi.
select vartotojas.ID as vartotojo_ID, vardas, pavarde, el_pastas, role.pavadinimas as vartotojo_role, 
vartotojo_kalba.kalbos_kodas as besimokoma_kalba from vartotojas
left join vartotojo_role on vartotojas.ID=vartotojo_role.vartotojo_id
left join role on vartotojo_role.roles_id=role.ID
left join vartotojo_kalba on vartotojo_kalba.vartotojo_ID=vartotojas.ID 
where role.ID=2;

-- Kiek koks vartotojas mokosi kalbų
select vartotojas.ID as vartotojo_ID, vardas, pavarde, el_pastas, role.pavadinimas as vartotojo_role, 
count(vartotojo_kalba.kalbos_kodas) as kalbu_skaicius_mokosi from vartotojas
left join vartotojo_role on vartotojas.ID=vartotojo_role.vartotojo_id
left join role on vartotojo_role.roles_id=role.ID
left join vartotojo_kalba on vartotojo_kalba.vartotojo_ID=vartotojas.ID 
where role.ID=2
group by vartotojo_ID;

-- Kiek žodžių turi tam tikra kalba
select kalba.kodas as kalbos_kodas , count(kalbos_zodis.zodzio_id) as kalbos_zodziu_skaicius from kalba
left join kalbos_zodis on kalbos_zodis.kalbos_kodas=kalba.kodas
group by kalba.kodas;

-- Kalbų kodai ir jų pavadinimai visomis esamomis kalbomis
select kalbos_vertimas.kalbos_kodas, kalbos_vertimas.pavadinimas as kalbos_pavadinimas from kalba
left join kalbos_vertimas on kalbos_vertimas.kalbos_kodas=kalba.kodas;

-- Kiek kokio lygio kalbos žodžių yra lietuvių kalboje
select kalba.kodas as kalbos_kodas, kalbos_zodis.lygio_lygis as lygis, count(kalbos_zodis.zodzio_id) as zodziu_skaicius from kalba
left join kalbos_zodis on kalbos_zodis.kalbos_kodas=kalba.kodas
where kalba.kodas='lit'
group by kalbos_zodis.lygio_lygis;

-- Pamokos testai
select pamoka.ID as pamokos_ID, pamoka.pavadinimas as pamokos_pavadinimas, testas.pavadinimas as testo_pavadinimas from pamoka
left join testas on pamoka.ID=testas.pamokos_id;

-- Visų testų užduotys su atsakymais
select testas.pavadinimas as testo_pavadinimas, uzduotis.klausimas, uzduotis.atsakymas from testas
left join uzduotis on testas.ID=uzduotis.testo_id;