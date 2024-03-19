CREATE TYPE departement AS ENUM ('44', '49', '79', '85');


create table if not exists commune(
	id serial primary key,
	nom varchar(255) not null,
	departement departement not null
)

CREATE TYPE type_acte AS ENUM ('Certificat de mariage', 'Contrat de mariage', 'Divorce', 'Mariage', 'Promesse de mariage - fiançailles', 'Publication de mariage', 'Rectification de mariage');

create table acte(
	id int primary key,
	type_id type_acte not null,
	personne_a INT,
	personne_b INT,
	commune INT,
	date_ TIMESTAMP WITH TIME ZONE,
	num_vue VARCHAR(255) DEFAULT 'null'
)



/* Acte -> Personne (a) */
ALTER TABLE acte ADD CONSTRAINT acte_fk1 FOREIGN KEY (personne_a) REFERENCES personne(id);
/* Acte -> Personne (b) */
ALTER TABLE acte ADD CONSTRAINT acte_fk2 FOREIGN KEY (personne_b) REFERENCES personne(id);
/* Acte -> Commune */
ALTER TABLE acte ADD CONSTRAINT acte_fk3 FOREIGN KEY (commune) REFERENCES commune(id);



COPY personne FROM 'C:\Program Files\PostgreSQL\16\mariages\personne_id.csv' DELIMITER ',' CSV;

COPY acte (id,type_id,personne_a,personne_b,commune,date_,num_vue) FROM 'C:\Program Files\PostgreSQL\16\mariages\actes.csv' DELIMITER ',' CSV HEADER;

COPY commune (id,nom,departement) FROM 'C:\Program Files\PostgreSQL\16\mariages\commune_id.csv' DELIMITER ',' CSV;


SELECT departement, COUNT(*) AS nombre_de_communes
FROM commune
GROUP BY departement;

SELECT COUNT(*) AS nombre_d_actes
FROM acte
INNER JOIN commune ON acte.commune = commune.id
WHERE commune.nom = 'LUÇON';


SELECT COUNT(*) AS nombre_de_contrats_de_mariage
FROM acte
WHERE type_id = 'Contrat de mariage' AND date_ < '1855-01-01';

SELECT commune.nom AS commune,
       COUNT(*) AS nombre_de_publications_de_mariage
FROM acte
INNER JOIN commune ON acte.commune = commune.id
WHERE acte.type_id = 'Publication de mariage'
GROUP BY commune.nom
ORDER BY COUNT(*) DESC
LIMIT 1;


SELECT MIN(date_) AS premiere_date_acte, 
       MAX(date_) AS derniere_date_acte
FROM acte;
