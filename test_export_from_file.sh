#!/bin/bash
export USER=test
export EMAIL=khagukhagu2@gmail.com
# 4- Vérifier si une clé SSH est présente sur la VM, sinon en créer une
if [ ! -f ~/.ssh/id_rsa ]; then
    ssh-keygen -t rsa -N "" -f ~/.ssh/id_rsa -C "$USER"
fi

# Lire le contenu du fichier dans une variable
contenu=$(cat ~/.ssh/id_rsa.pub)

# Exporter la variable d'environnement
export VARIABLE_CONTENU="$contenu"

# Afficher le contenu exporté
echo "$USER:$VARIABLE_CONTENU" > ssh_keys