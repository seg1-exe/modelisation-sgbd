import pandas as pd

# Charger le fichier personnes.csv dans un DataFrame
personnes_df = pd.read_csv('/media/Qi/agillier/L3/Projet-Modélisation/data/personne_id.csv', header=None, names=['id', 'nom', 'prenom', 'prenom_pere', 'nom_mere', 'prenom_mere'], keep_default_na=False)
commune_df = pd.read_csv('/media/Qi/agillier/L3/Projet-Modélisation/data/commune_id.csv', header=None, names=['id', 'nom', 'departement'], keep_default_na=False)

# Fonction pour rechercher le numéro dans personnes.csv
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


# Ouvrir un fichier de sortie CSV pour écrire les résultats
with open('/media/Qi/agillier/L3/Projet-Modélisation/data/mariages_L3_5k.csv', 'r') as f:
    with open('/media/Qi/agillier/L3/Projet-Modélisation/data/actes.csv', 'w') as output_file:
        output_file.write("Identifiant d’acte,Type d’acte,Id Personne A,Id Personne B,Commune,Date,Num Vue\n")
        for line in f:
            mariage_info = line.strip().split(',')
            if len(mariage_info) == 16:  # Assurez-vous que la ligne contient suffisamment de champs
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
