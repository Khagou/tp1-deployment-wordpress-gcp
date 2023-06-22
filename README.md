tp1-deployment-wordpress-gcp
Sujet TP – Créer des VM sur GCP à l’aide de terraform et déployer une application Wordpress dans ces VM avec Ansible

1- Configuerer et récupérer la zone du projet
gcloud config set compute/region europe-west1 gcloud config set compute/zone europe-west1-b export ZONE=$(gcloud config get-value compute/zone)

2- Créer une VM de déploiement
gcloud compute instances create deployment-vm --zone=$ZONE --machine-type=e2-medium --tags=ansible

3- Se connecter à l'instance en SSH
gcloud compute ssh deployment-vm --zone=$ZONE
