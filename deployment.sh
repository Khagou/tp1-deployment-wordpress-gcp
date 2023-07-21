#!/bin/bash
export ZONE=us-east1-b # A modifier
export WORDPRESS_INSTANCE=wordpress-instance # A modifier
# 5- Vérifier et installer Terraform si nécessaire
if ! command -v terraform &> /dev/null; then
    sudo apt-get update && sudo apt-get install -y gnupg software-properties-common
    wget -O- https://apt.releases.hashicorp.com/gpg | \
    gpg --dearmor | \
    sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg
    echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
    https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
    sudo tee /etc/apt/sources.list.d/hashicorp.list
    sudo apt update
    sudo apt-get install terraform
fi

# 6- Vérifier et installer Ansible si nécessaire
if ! command -v ansible &> /dev/null; then
    sudo apt update
    sudo apt install -y ansible
fi

gcloud services enable compute.googleapis.com --project="tp1-wordpress-mariadb"
gcloud services enable cloudresourcemanager.googleapis.com --project="tp1-wordpress-mariadb"
gcloud services enable iam.googleapis.com --project="tp1-wordpress-mariadb"
# 7- Vérification de la présence des fichiers Terraform et exécution de terraform init si nécessaire
if [ ! -d "terraform" ]; then
    git clone https://github.com/Khagou/tp1-deployment-wordpress-gcp.git
    cd tp1-deployment-wordpress-gcp/terraform
else
    cd terraform
fi
terraform init

# 8- Application de la création avec Terraform
terraform apply -auto-approve

cd ..

sh test_export_from_file.sh

sh recolte-instances-names.sh

# 9- Utiliser la commande de déploiement Ansible pour appliquer le déploiement sur les machines
if [ ! -d "ansible" ]; then
    git clone https://github.com/tp1-deployment-wordpress-gcp.git
    cd tp1-deployment-wordpress-gcp/ansible
else
    cd ansible
fi

ansible-playbook playbook.yml -i ./gcp_compute.yml

# 10- Vérification que l'application fonctionne
wordpress_ip=$(gcloud compute instances describe $WORDPRESS_INSTANCE --zone $ZONE --format='get(networkInterfaces[0].accessConfigs[0].natIP)')

url_to_check="$wordpress_ip/wordpress"  # Remplacez cette URL par l'URL que vous souhaitez vérifier

# Effectuer une requête GET à l'URL spécifiée et stocker le code de statut dans une variable
status_code=$(curl -s -o /dev/null -w "%{http_code}" $url_to_check)

if [ $status_code -eq 200 ] || [ $status_code -eq 301 ]; then
  echo "La page $url_to_check renvoie le code 200."
else
  echo "La page $url_to_check ne renvoie pas le code 200. Code : $status_code"
fi