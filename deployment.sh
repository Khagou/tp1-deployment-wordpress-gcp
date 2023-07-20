#!/bin/bash
sh test_export_from_file.sh

sh recolte-instance-name.sh


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

# 9- Utiliser la commande de déploiement Ansible pour appliquer le déploiement sur les machines
cd ..
if [ ! -d "ansible" ]; then
    git clone https://github.com/tp1-deployment-wordpress-gcp.git
    cd tp1-deployment-wordpress-gcp/ansible
else
    cd ansible
fi
# export GCP_AUTH_KIND=serviceaccount
# export GCP_SERVICE_ACCOUNT_EMAIL=terraform@test-recup-email.iam.gserviceaccount.com
# export GCP_SERVICE_ACCOUNT_FILE=./service_account.json
# export GCP_SCOPES=https://www.googleapis.com/auth/compute
ansible-playbook playbook.yml -i ./gcp_compute.yml

# 10- Vérification que l'application fonctionne
wordpress_ip=$(terraform output -raw wordpress_instance_ip)
curl_result=$(curl -s "$wordpress_ip" | grep "WordPress Installation")
if [[ -n $curl_result ]]; then
    echo "L'application WordPress est fonctionnelle."
else
    echo "L'application WordPress n'est pas fonctionnelle."
fi
