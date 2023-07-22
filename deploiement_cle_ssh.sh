#!/bin/bash

# Remplacez "VOTRE_PROJET" par l'ID de votre projet GCP
PROJET="test-final3" # Change me

# Récupère la liste des noms et des zones d'instance à l'aide de gcloud
instances_info=$(gcloud compute instances list --project $PROJET --format="csv(NAME,ZONE)")

# Vérifie si des instances sont trouvées
if [ -z "$instances_info" ]; then
    echo "Aucune instance trouvée dans le projet $PROJET."
else
    echo "Liste des noms et des zones d'instance dans le projet $PROJET :"
    echo "$instances_info"

    # Séparateur par défaut en bash (utilisé pour les boucles)
    IFS=$'\n'

    # Boucle pour traiter chaque nom d'instance et sa zone
    for instance_info in $instances_info; do
        # Découpe la ligne en nom et zone
        IFS=',' read -r instance_name zone <<< "$instance_info"

        echo "Traitement de l'instance : $instance_name (zone : $zone)"

        # Exécute la commande gcloud avec le nom d'instance et la zone actuels
        gcloud compute instances add-metadata "$instance_name" --zone "$zone" --metadata-from-file ssh-keys=ssh_keys

        # Vérifie le code de sortie de la commande gcloud
        if [ $? -eq 0 ]; then
            echo "Clé SSH ajoutée à l'instance $instance_name (zone : $zone) avec succès."
        else
            echo "Une erreur s'est produite lors de l'ajout de la clé SSH à l'instance $instance_name (zone : $zone)."
        fi
    done
fi
