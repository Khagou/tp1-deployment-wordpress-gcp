#!/bin/bash

# Définir les variables
PROJECT_ID="test-recup-email"
ZONE="us-east1-b"
INSTANCE_NAME="vm-deploiement"
MACHINE_TYPE="e2-medium"

# Créer la VM
gcloud compute instances create $INSTANCE_NAME \
  --project $PROJECT_ID \
  --zone $ZONE \
  --machine-type $MACHINE_TYPE
  --create-disk=auto-delete=yes,boot=yes,device-name=vm-deploiement,image=projects/debian-cloud/global/images/debian-11-bullseye-v20230629,mode=rw,size=10,type=projects/test-recup-email/zones/us-east1-b/diskTypes/pd-balanced

# Générer les clés SSH
sudo gcloud compute config-ssh --project $PROJECT_ID

# Afficher les détails de la VM créée
gcloud compute instances describe $INSTANCE_NAME \
  --project $PROJECT_ID \
  --zone $ZONE

# Se connecter en SSH à la VM
gcloud compute ssh $INSTANCE_NAME \
  --project $PROJECT_ID \
  --zone $ZONE \
  --command "if ! command -v git &> /dev/null; then sudo apt-get update && sudo apt-get install -y git; fi"

gcloud compute ssh $INSTANCE_NAME \
  --project $PROJECT_ID \
  --zone $ZONE \
  --command "if [ ! -d "tp1-deployment-wordpress-gcp" ]; then git clone https://github.com/Khagou/tp1-deployment-wordpress-gcp.git
    cd tp1-deployment-wordpress-gcp
    else
        cd tp1-deployment-wordpress-gcp
    fi
    sh deployment.sh"