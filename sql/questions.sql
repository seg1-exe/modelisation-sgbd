/*La quantité de communes par département*/
SELECT departement, COUNT(*) AS nombre_de_communes
FROM commune
GROUP BY departement;

/* */
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
