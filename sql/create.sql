CREATE TYPE type_acte AS ENUM ('Certificat de mariage', 'Contrat de mariage', 'Divorce', 'Mariage', 'Promesse de mariage - fiançailles', 'Publication de mariage', 'Rectification de mariage');

CREATE TYPE departement AS ENUM ('44', '49', '79', '85');

CREATE TABLE IF NOT EXISTS commune(
	id INT PRIMARY KEY,
	nom VARCHAR(255) NOT NULL,
	departement departement NOT NULL
);

CREATE TABLE IF NOT EXISTS personne (
    id INT PRIMARY KEY,
    nom VARCHAR(255),
    prenom VARCHAR(255),
    prenom_pere VARCHAR(255),
    nom_mere VARCHAR(255),
    prenom_mere VARCHAR(255)
);

CREATE TABLE acte(
	id INT PRIMARY KEY,
	type_id type_acte NOT NULL,
	personne_a INT,
	personne_b INT,
	commune INT,
	date_ TIMESTAMP WITH TIME ZONE,
	num_vue VARCHAR(255) DEFAULT 'null'
);

COPY personne FROM 'C:\Program Files\PostgreSQL\16\mariages\personne_id.csv' DELIMITER ',' CSV;

COPY acte (id,type_id,personne_a,personne_b,commune,date_,num_vue) FROM 'C:\Program Files\PostgreSQL\16\mariages\actes.csv' DELIMITER ',' CSV HEADER;

COPY commune (id,nom,departement) FROM 'C:\Program Files\PostgreSQL\16\mariages\commune_id.csv' DELIMITER ',' CSV;

ALTER TABLE acte ADD CONSTRAINT acte_fk3 FOREIGN KEY (commune) REFERENCES commune(id);

ALTER TABLE acte ADD CONSTRAINT acte_fk1 FOREIGN KEY (personne_a) REFERENCES personne(id);
ALTER TABLE acte ADD CONSTRAINT acte_fk2 FOREIGN KEY (personne_b) REFERENCES personne(id);