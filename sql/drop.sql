ALTER TABLE acte DROP CONSTRAINT IF EXISTS acte_fk1;
ALTER TABLE acte DROP CONSTRAINT IF EXISTS acte_fk2;
ALTER TABLE acte DROP CONSTRAINT IF EXISTS acte_fk3;

DROP TABLE IF EXISTS acte;
DROP TABLE IF EXISTS commune;
DROP TABLE IF EXISTS personne;

DROP TYPE IF EXISTS departement;

DROP TYPE IF EXISTS type_acte;