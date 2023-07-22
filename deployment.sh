#!/bin/bash
export PROJET="test-final-393611" # Change me

gcloud config set project $PROJET
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

gcloud services enable compute.googleapis.com --project=$PROJET
gcloud services enable cloudresourcemanager.googleapis.com --project=$PROJET
gcloud services enable iam.googleapis.com --project=$PROJET
# 7- Vérification de la présence des fichiers Terraform et exécution de terraform init si nécessaire
if [ ! -d "terraform" ]; then
    git clone https://github.com/khagou/tp1-deployment-wordpress-gcp.git
    cd tp1-deployment-wordpress-gcp/terraform
else
    cd terraform
fi
terraform init

# 8- Application de la création avec Terraform
terraform apply -auto-approve

cd ..

sh creation_cle_ssh.sh

sh deploiement_cle_ssh.sh

# 9- Utiliser la commande de déploiement Ansible pour appliquer le déploiement sur les machines
if [ ! -d "ansible" ]; then
    git clone https://github.com/khagou/tp1-deployment-wordpress-gcp.git
    cd tp1-deployment-wordpress-gcp/ansible
else
    cd ansible
fi

ansible-playbook playbook.yml -i ./gcp_compute.yml

# 10- Vérification que l'application fonctionne
cd ..
sh test_deploiement.sh