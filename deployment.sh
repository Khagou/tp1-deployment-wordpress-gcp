#!/bin/bash

# Définir les variables
PROJECT_ID="test-recup-email"
ZONE="us-east1-b"
INSTANCE_NAME="vm_deploiement"
MACHINE_TYPE="e2-medium"
IMAGE_FAMILY="Debian GNU/Linux 11"
# IMAGE_PROJECT="projet_de_l'image"

# Créer la VM
gcloud compute instances create $INSTANCE_NAME \
  --project $PROJECT_ID \
  --zone $ZONE \
  --machine-type $MACHINE_TYPE \
  --image-family $IMAGE_FAMILY 
#   --image-project $IMAGE_PROJECT

# Afficher les détails de la VM créée
gcloud compute instances describe $INSTANCE_NAME \
  --project $PROJECT_ID \
  --zone $ZONE

# Se connecter en SSH à la VM
gcloud compute ssh $INSTANCE_NAME \
  --project $PROJECT_ID \
  --zone $ZONE

# 4- Vérifier si une clé SSH est présente sur la VM, sinon en créer une
if [ ! -f ~/.ssh/id_rsa ]; then
    ssh-keygen -t rsa -N "" -f ~/.ssh/id_rsa
fi

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

gcloud services enable cloudresourcemanager.googleapis.com --project="test-recup-email"
gcloud services enable iam.googleapis.com --project="test-recup-email"

# 7- Vérification de la présence des fichiers Terraform et exécution de terraform init si nécessaire
if [ ! -d "terraform" ]; then
    git clone https://github.com/tp1-deployment-wordpress-gcp.git
    cd tp1-deployment-wordpress-gcp/terraform
else
    cd terraform
fi
terraform init

# 8- Application de la création avec Terraform
terraform apply -auto-approve

# 9- Utiliser la commande de déploiement Ansible pour appliquer le déploiement sur les machines
cd ..
if [ ! -d "ansible" ]; then
    git clone https://github.com/tp1-deployment-wordpress-gcp.git
    cd tp1-deployment-wordpress-gcp/ansible
else
    cd ansible
fi
ansible-playbook playbook.yml

# 10- Vérification que l'application fonctionne
wordpress_ip=$(terraform output -raw wordpress_instance_ip)
curl_result=$(curl -s "$wordpress_ip" | grep "WordPress Installation")
if [[ -n $curl_result ]]; then
    echo "L'application WordPress est fonctionnelle."
else
    echo "L'application WordPress n'est pas fonctionnelle."
fi
