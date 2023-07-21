export ZONE=us-east1-b # A modifier
export WORDPRESS_INSTANCE=wordpress-instance # A modifier

wordpress_ip=$(gcloud compute instances describe $WORDPRESS_INSTANCE --zone $ZONE --format='get(networkInterfaces[0].accessConfigs[0].natIP)')

url_to_check="$wordpress_ip/wordpress"  # Remplacez cette URL par l'URL que vous souhaitez vérifier

# Effectuer une requête GET à l'URL spécifiée et stocker le code de statut dans une variable
status_code=$(curl -s -o /dev/null -w "%{http_code}" $url_to_check)

if [ $status_code -eq 200 ] || [ $status_code -eq 301 ] || [ $status_code -eq 302 ]; then
  echo "La page $url_to_check renvoie le code 200. Code : $status_code"
else
  echo "La page $url_to_check ne renvoie pas le code 200. Code : $status_code"
fi