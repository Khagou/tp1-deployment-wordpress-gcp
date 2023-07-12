#!/bin/bash

# Définir les variables
PROJECT_ID="test-recup-email"
ZONE="us-east1-b"
INSTANCE_NAME="vm-deploiement"
MACHINE_TYPE="e2-medium"

# Générer les clés SSH
gcloud compute config-ssh

# Créer la VM
gcloud compute instances create $INSTANCE_NAME \
  --project $PROJECT_ID \
  --zone $ZONE \
  --machine-type $MACHINE_TYPE
  --create-disk=auto-delete=yes,boot=yes,device-name=vm-deploiement,image=projects/debian-cloud/global/images/debian-11-bullseye-v20230629,mode=rw,size=10,type=projects/test-recup-email/zones/us-east1-b/diskTypes/pd-balanced

# Afficher les détails de la VM créée
gcloud compute instances describe $INSTANCE_NAME \
  --project $PROJECT_ID \
  --zone $ZONE

# Se connecter en SSH à la VM
gcloud compute ssh $INSTANCE_NAME \
  --project $PROJECT_ID \
  --zone $ZONE \
  --command "if ! command -v git &> /dev/null; then sudo apt-get update && sudo apt-get install -y git; fi"