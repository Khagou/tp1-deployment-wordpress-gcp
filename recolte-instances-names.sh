#!/bin/bash

# Remplacez "VOTRE_PROJET" par l'ID de votre projet GCP
PROJET="tp1-wordpress-mariadb"

# Récupère la liste des noms d'instance à l'aide de gcloud
instances=$(gcloud compute instances list --project $PROJET --format="value(NAME)")

# Vérifie si des instances sont trouvées
if [ -z "$instances" ]; then
    echo "Aucune instance trouvée dans le projet $PROJET."
else
    echo "Liste des noms d'instance dans le projet $PROJET :"
    echo "$instances"

    # Séparateur par défaut en bash (utilisé pour les boucles)
    IFS=$'\n'

    # Boucle pour traiter chaque nom d'instance
    for instance_name in $instances; do
        echo "Traitement de l'instance : $instance_name"

        # Exécute la commande gcloud avec le nom d'instance actuel
        gcloud compute instances add-metadata "$instance_name" --metadata-from-file ssh-keys=ssh_keys

        # Vérifie le code de sortie de la commande gcloud
        if [ $? -eq 0 ]; then
            echo "Clé SSH ajoutée à l'instance $instance_name avec succès."
        else
            echo "Une erreur s'est produite lors de l'ajout de la clé SSH à l'instance $instance_name."
        fi
    done
fi
