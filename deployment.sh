#!/bin/bash

# 1- Configuerer et récupérer la zone du projet
gcloud config set compute/region europe-west1
gcloud config set compute/zone europe-west1-b
export ZONE=$(gcloud config get-value compute/zone)

# 2- Créer une VM de déploiement
gcloud compute instances create deployment-vm --zone=$ZONE --machine-type=e2-medium  --tags=ansible

# 3- Se connecter à l'instance en SSH
gcloud compute ssh deployment-vm --zone=$ZONE <<eof

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
ansible-playbook -i ansible/deploy.yml

# 10- Vérification que l'application fonctionne
wordpress_ip=$(terraform output -raw wordpress_instance_ip)
curl_result=$(curl -s "$wordpress_ip" | grep "WordPress Installation")
if [[ -n $curl_result ]]; then
    echo "L'application WordPress est fonctionnelle."
else
    echo "L'application WordPress n'est pas fonctionnelle."
fi
eof