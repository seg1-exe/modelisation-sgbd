
# Database modeling project

**Arthur Gillier - Florian Chacun**


## Summary

This report presents a modeling, cleaning, and analysis project of a historical dataset extracted from departmental marriage archives. The goal is to demonstrate mastery of relational modeling principles, normalization, and relational database management using PostgreSQL. After conceptualizing the schema, cleaning the source data, and inserting it into the defined tables, various queries were executed to answer specific questions (quantities of records, municipalities, time periods, etc.). The results validate the approach, despite the data being occasionally incomplete or noisy. Finally, this work discusses the challenges encountered, as well as possible improvements, particularly for processing a larger file (500k rows).

- [Introduction](#introduction)
- [Methodological and Theoretical Framework](#methodological-and-theoretical-framework)
- [Database Conceptualization and Modeling](#database-conceptualization-and-modeling)
    - [Data Description](#data-description)
    - [Definition of Tables and Attributes](#definition-of-tables-and-attributes)
    - [Primary and Foreign Key Management](#primary-and-foreign-key-management)
    - [Relationships Between Tables](#relationships-between-tables)
- [Database Schema](#database-schema)
- [Relational Schema Normalization](#relational-schema-normalization)
    - [Normalization Principles](#normalization-principles)
- [Table Creation](#table-creation)
    - [Departement Table](#departement-table)
    - [Type d'Acte Table](#type-table)
    - [Commune Table](#commune-table)
    - [Personne Table](#personne-table)
    - [Acte Table](#acte-table)
- [Data Cleaning, Transformation, and Insertion Procedures](#data-cleaning-transformation-and-insertion-procedures)
    - [Record Extraction](#record-extraction)
    - [Adding Relationships](#adding-relationships)
        - [Acte -> Municipality](#acte---commune)
        - [Acte -> Personne A & B](#acte---personne-a--b)
- [Results and Analysis Queries](#results-and-analysis-queries)
- [Challenges and Limitations](#challenges-and-limitations)
- [Future Improvements](#future-improvements)
- [Conclusion](#conclusion)
- [Authors](#authors)

## Introduction

The aim of this project, carried out as part of the Database Modeling course at the University of La Rochelle, was to put into practice the skills acquired in the design, standardization and manipulation of relational databases. The aim was to use a historical dataset of marriages, with heterogeneous and sometimes imperfect attributes, to create a usable relational database.
This project consolidates the knowledge acquired in SQL, reinforces the understanding of normalization and provides an insight into the management of real, often imperfect, data. The expected result is a system enabling users (genealogists, demographers) to consult and analyze marriage data efficiently.


## Methodological and Theoretical Framework

The project is based on the fundamentals of relational modeling and best practices established in the DBMS community. Data has been structured according to the principles of the first three normal forms (1NF, 2NF, 3NF) to reduce redundancy, improve consistency and facilitate updating.
In particular, normalization ensures that each relationship contains only atomic attributes, that partial dependencies are eliminated, and that no transitive dependencies between non-key attributes exist. In addition, by respecting ACID properties (Atomicity, Consistency, Isolation, Durability) and following relational modeling standards, the system gains in robustness, maintainability and scalability.

## Database Conceptualization and Modeling

The first step in this project is to understand the data provided and model it in such a way as to meet the initial need.

### Data Description

The data is extracted from the Vendée departmental archives and includes detailed information on registered marriages. Each record contained in the file mariages_L3_5k.csv includes the following columns:

```bash
1. Act identifier 
2. Act type
3. Name of person A
4. First name person A
5. First name father person A 
6. Last name mother person A
7. First name mother person A 
8. Last name person B
9. First name person B
10. First name father person B 
11. Last name mother person B 
12. First name mother person B 
13. Town
14. Department 
15. Date
```

### Definition of Tables and Attributes


Based on the data description, we have identified several entities: deeds, persons, deed types, communes and départements. Each entity will be represented by a table or enumeration in the database, with attributes corresponding to the various record fields.

Our database will therefore be represented by these tables:

```bash
• Acte : id, type, personne_a, personne_b, date, commune, num_vue
• Personne : id, nom, prenom, prenom_pere, nom_mere, prenom_mere
• Commune : id, departement, nom
```

We have chosen to create two enumerations for procedure types and departments, as we have a finite set of possible values (labels for types and numbers for departments). This also offers advantages in terms of data consistency, ease of maintenance and simplified reading.

```bash
• Departement : numéro
• Type : libelle
```

It will therefore not be necessary to have foreign key constraints between Act/Type and Municipality/Department.

### Primary and Foreign Key Management

To guarantee data integrity and consistency, we need to define primary and foreign keys. Each table will have a primary key, which will be a unique identifier. In addition, relationships between tables will be established using foreign keys on logical links between different data.

So for each table, we have an ```id``` attribute as primary key. 

As for foreign keys :

```bash
Acte :

“personne_a” and “personne_b” associated with the table Personne
“commune” associated with the table Commune
```

### Relationships Between Tables

In our database schema for marriage registers, we have identified and chosen to use a Many-to-One realtion.

**Many-to-One relationship between the ``Acte`` Table and the ``Personne`` Table**.

Each act can involve two distinct people: person A and person B. To model this relationship, ``personne_a`` and ``personne_b`` serve as foreign keys, referring to the unique identifiers of the persons in the ``Personne`` table.

This many-to-one relationship between the ``acte`` and ``persone`` tables represents the link between registered acts and the persons in each act. A marriage deed can have two people involved (personne_a and personne_b), and each person can be linked to several deeds.


**Many-to-One relationship between the ``acte`` Table and the ``commune`` Table** 

Each marriage certificate is registered in a commune. To represent this association, the ``commune`` column in the ``acte`` table is a foreign key referring to the unique identifiers of the communes in the ``commune`` table.

This many-to-one relationship between the ``acte`` and ``commune`` tables links each marriage record to the commune where it was registered. An act can be registered in a single commune, but several acts can be registered in the same commune. This makes it easier to search and analyze marriage certificates according to their place of registration.

## Database Schema

![https://i.imgur.com/uRH4WPi.png](https://i.imgur.com/uRH4WPi.png)


Note that the `departement` and `type` tables are not actually tables, but enums.

## Relational Schema Normalization

### Normalization Principles

Normalization is the process of reducing data redundancy, improving integrity and minimizing anomalies in data manipulation. We have based our work on normal forms, the main ones being the first normal form (1NF), the second normal form (2NF), and the third normal form (3NF).

To apply the principles of normalization to our database, we examined the structure of each table and the functional dependencies between attributes. We ensured that each table was in 1NF by making sure that each attribute was atomic.

A relationship is 1FN if all attributes :

- Are atomic (not decomposable) / Non-repetitive
- (Are constant over time)

Next, we checked that each table was in 2NF, ensuring that every non-key attribute depended entirely on the primary key.

A 1FN relation is in 2nd normal form if :

- No non-key attribute depends on only part of a key <br>
- Only applies to tables with a compound primary key

For example, in our “Acte” table, the attributes `type`, `personne_a` and `personne_b` depend directly on the act identifier. Finally, we examined the 3NF to ensure that no non-key attribute depended transitively on another non-key attribute.

A 2FN relation is in 3rd normal form if :

- There is no FD between non-key attributes

For example, in our `Commune` table, the `departement` attribute depends directly on the commune identifier, without depending on the commune `nom`. To avoid redundancy, we have created tables for repeating values, such as commune and people, which will/can be constant or repeat. In addition, the management of departments and deed types in enumeration further avoids redundancy.

## Table Creation

### `Departement` Table

```sql 
CREATE TYPE departement AS ENUM ('44', '49', '79', '85');
```

### `Type` Table

```sql
CREATE TYPE type_acte AS ENUM ('Certificat de mariage', 'Contrat de mariage', 'Divorce', 'Mariage', 'Promesse de mariage - fiançailles', 'Publication de mariage', 'Rectification de mariage');
```

### `Commune` Table

```sql
CREATE TABLE IF NOT EXISTS commune(
    id INT PRIMARY KEY,
    nom VARCHAR(255) NOT NULL,
    departement departement NOT NULL
)
```

### `Personne` Table

```sql
CREATE TABLE IF NOT EXISTS personne (
    id INT PRIMARY KEY,
    nom VARCHAR(255),
    prenom VARCHAR(255),
    prenom_pere VARCHAR(255),
    nom_mere VARCHAR(255),
    prenom_mere VARCHAR(255)
);
```

### `Acte` Table

```sql
CREATE TABLE acte(
    id INT PRIMARY KEY,
    type_id type_acte NOT NULL,
    personne_a INT,
    personne_b INT,
    commune INT,
    date_ TIMESTAMP WITH TIME ZONE,
    num_vue VARCHAR(255) DEFAULT 'null'
)
```
## Data Cleaning, Transformation, and Insertion Procedures

The source data, derived from CSV files, presented a number of inaccuracies (missing data, heterogeneous date formats, accented names, etc.). Pre-processing was carried out using Linux commands (cut, sort, uniq, awk) to filter and reorganize the data. Python scripts were then used to associate each person, commune or act with its unique identifier and produce consistent final files.

```bash
# Split the file marriage_L3_5k.csv to obtain communes and persons.
cut -f13,14 -d ',' mariages_L3_5k.csv | sort | uniq > commune.csv
cut -f3,4,5,6,7 -d ',' mariages_L3_5k.csv | sort | uniq > personnes.csv

# Note that >> lets you add data to the end of the file without overwriting the previous content.
cut -f8,9,10,11,12 -d ',' mariages_L3_5k.csv | sort | uniq >> personnes.csv

# Add ids for each line of the person and commune csvs.
awk -F, '{print NR","$0}' personne.csv > personne_id.csv
awk -F, '{print NR","$0}' commune.csv > commune_id.csv
```

### Record Extraction

To retrieve the acts, we used a python script that uses the files `marriages_L3_5k.csv`, `personne_id.csv` and `commune_id.csv` to generate a `actes.csv` file containing the marriage acts.

```python
import pandas as pd

# Loading the people.csv file into a DataFrame
personnes_df = pd.read_csv('/media/Qi/agillier/L3/Projet-Modélisation/data/personne_id.csv', header=None, names=['id', 'nom', 'prenom', 'prenom_pere', 'nom_mere', 'prenom_mere'], keep_default_na=False)
commune_df = pd.read_csv('/media/Qi/agillier/L3/Projet-Modélisation/data/commune_id.csv', header=None, names=['id', 'nom', 'departement'], keep_default_na=False)

# Function to search for the number in personnes.csv
def trouver_id_personne(nom, prenom, prenom_pere, nom_mere, prenom_mere):
    filtre = (personnes_df['nom'] == nom) & (personnes_df['prenom'] == prenom) & (personnes_df['prenom_pere'] == prenom_pere) & (personnes_df['nom_mere'] == nom_mere) & (personnes_df['prenom_mere'] == prenom_mere)
    resultats = personnes_df[filtre]
    if not resultats.empty:
        return resultats['id'].values[0]
    else:
        return None
    
def trouver_id_commune(nom, departement):
    filtre = (commune_df['nom'] == nom) & (commune_df['departement'].astype(str) == str(departement))
    resultats = commune_df[filtre]
    if not resultats.empty:
        return resultats['id'].values[0]
    else:
        return None


# Open a CSV output file to write results
with open('/media/Qi/agillier/L3/Projet-Modélisation/data/mariages_L3_5k.csv', 'r') as f:
    with open('/media/Qi/agillier/L3/Projet-Modélisation/data/actes.csv', 'w') as output_file:
        output_file.write("Identifiant d’acte,Type d’acte,Id Personne A,Id Personne B,Commune,Date,Num Vue\n")
        for line in f:
            mariage_info = line.strip().split(',')
            if len(mariage_info) == 16:  # Make sure the line contains enough fields
                nom_personne_a = mariage_info[2]
                prenom_personne_a = mariage_info[3]
                prenom_pere_personne_a = mariage_info[4]
                nom_mere_personne_a = mariage_info[5]
                prenom_mere_personne_a = mariage_info[6]
                id_personne_a = trouver_id_personne(nom_personne_a, prenom_personne_a, prenom_pere_personne_a, nom_mere_personne_a, prenom_mere_personne_a)
                nom_personne_b = mariage_info[7]
                prenom_personne_b = mariage_info[8]
                prenom_pere_personne_b = mariage_info[9]
                nom_mere_personne_b = mariage_info[10]
                prenom_mere_personne_b = mariage_info[11]
                id_personne_b = trouver_id_personne(nom_personne_b, prenom_personne_b, prenom_pere_personne_b, nom_mere_personne_b, prenom_mere_personne_b)
                commune = trouver_id_commune(mariage_info[12], mariage_info[13])
                temps = mariage_info[14].split('/')
                if len(temps) == 3:
                    mariage_info[14] = temps[2] + '-' + temps[1] + '-' + temps[0]
                else:
                    mariage_info[14] = ''
                if (id_personne_a is not None and id_personne_b is not None):
                    output_file.write(f"{mariage_info[0]},{mariage_info[1]},{id_personne_a},{id_personne_b},{commune},{mariage_info[14]},{mariage_info[15]}\n")
```


Inserting data into the database :

```sql
COPY personne FROM 'C:\Program Files\PostgreSQL\16\mariages\personne_id.csv' DELIMITER ',' CSV;

/* Note that the CSV HEADER is used to eliminate the csv header. */
COPY acte (id,type_id,personne_a,personne_b,commune,date_,num_vue) FROM 'C:\Program Files\PostgreSQL\16\mariages\actes.csv' DELIMITER ',' CSV HEADER;

COPY commune (id,nom,departement) FROM 'C:\Program Files\PostgreSQL\16\mariages\commune_id.csv' DELIMITER ',' CSV;
```

### Adding Relationships

#### Acte -> Commune

```sql
ALTER TABLE acte ADD CONSTRAINT acte_fk3 FOREIGN KEY (commune) REFERENCES commune(id);
```

#### Acte -> Personne (a) & (b)

```sql
/* Acte -> Personne (a) */
ALTER TABLE acte ADD CONSTRAINT acte_fk1 FOREIGN KEY (personne_a) REFERENCES personne(id);
/* Acte -> Personne (b) */
ALTER TABLE acte ADD CONSTRAINT acte_fk2 FOREIGN KEY (personne_b) REFERENCES personne(id);
```

## Results and Analysis Queries

Several queries were run to answer the questions posed:

**The number of communes per department**: a simple GROUP BY on the communes table yields the number of distinct communes per department.

```sql
SELECT departement, COUNT(*) AS nombre_de_communes
FROM commune
GROUP BY departement;
```
Result : <br>
![https://i.imgur.com/TQwhhrO.png](https://i.imgur.com/DQoVwIS.png)

**The number of acts in LUÇON** : A join between `acte` and `commune` followed by a filtering on the name allows to count the number of acts in this locality.

```sql
SELECT COUNT(*) AS nombre_d_actes
FROM acte
INNER JOIN commune ON acte.commune = commune.id
WHERE commune.nom = 'LUÇON';
```
Result : `105`

**The number of “marriage contracts” before 1855**: Filtering by type of act and date, we obtain the exact number of contracts prior to this date.

```sql
SELECT COUNT(*) AS nombre_de_contrats_de_mariage
FROM acte
WHERE type_id = 'Contrat de mariage' AND date_ < '1855-01-01';
```
Result : `196`

**The commune with the highest number of “marriage publications ‘**: A GROUP BY on `Publication de mariage` type records and a descending sort provide the commune most concerned.

```sql
SELECT commune.nom AS commune,
       COUNT(*) AS nombre_de_publications_de_mariage
FROM acte
INNER JOIN commune ON acte.commune = commune.id
WHERE acte.type_id = 'Publication de mariage'
GROUP BY commune.nom
ORDER BY COUNT(*) DESC
LIMIT 1;
```
Result : `SAINT PIERRE DU CHEMIN : 20`

**The date of the first act and the last act**: A simple MIN and MAX in the date_ column reveals the chronological range covered.

```sql
SELECT MIN(date_) AS premiere_date_acte, 
       MAX(date_) AS derniere_date_acte
FROM acte;
```
Result : `First date : "1581-12-23 00:00:00+00:09:21"` & `Last date : "1915-09-14 00:00:00+00"`

The results show good consistency. The queries returned the expected quantities, despite the exclusion of some missing data. This illustrates the trade-off between completeness and data quality.

## Challenges and Limitations

The main difficulty lay in the variable quality of the source data. Some entries were incomplete, others did not conform to the expected format. The choices made (exclusion of incomplete records, use of ENUM to restrict possible values) strengthened overall consistency, but at the cost of reducing the exploitable volume.<br>
In terms of performance, the manageable volume for the test phase (5k lines) was relatively modest. Moving up to a set of 500k lines will raise additional challenges in terms of memory management, loading time and robustness of the cleaning process.

## Future Improvements

To efficiently process a large file (500k lines), a more advanced methodology would be required, involving :

- A more industrial cleaning strategy (robust scripts, automated quality checks, use of batch processing).
- Additional indexes on key tables to speed up queries.
- More powerful parsing tools (e.g. use of Python pandas, stream management, etc.) and batch processing to limit the impact on resources.
- More refined management of missing values, possibly via imputation techniques or more elaborate integration of metadata.

These improvements will help maintain data performance, consistency and relevance on a larger scale.

## Conclusion

This project confirmed our understanding of the principles of modeling, standardization and data management in a realistic context, where data quality and consistency were not always guaranteed. <br>
The whole process - from conceptualization to setting up the relational database, from cleansing to insertion, then exploration via targeted queries - demonstrated the relevance of good database management practices.<br>.
What's more, this work has strengthened our technical skills in SQL, data manipulation and reflection on data quality, foreshadowing a scaling-up to larger volumes. <br>
My sincere thanks go to the professors at the University of La Rochelle, Carlos-Emiliano González-Gallardo and Marwa Hamdi, for their guidance, as well as for the opportunity to concretely apply the knowledge acquired.<br>.
Finally, I'd like to thank Florian Chacun, with whom we worked in pairs on this project.


## Authors

- Arthur Gillier
- Florian Chacun
- ChatGPT editorial support
- Subjet : Université de La Rochelle.