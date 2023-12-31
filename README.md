# TP 1 Deploiement Wordpress MariaDB sur GCP avec terraform et ansible

## Composition du repot

L'ensemble du repot permet le deploiement de Wordpress et de MariaDB sur GCP, l'ensemble du déploiement repose sur des instances tournant sous debian-11, si vous souhaitez utiliser un autre OS vous pourriez donc avoir besoin de procéder à des modifications dont on ne parlera pas ici.

Le repot est composé de 2 dossier et 4 scripts shell:

- Le dossier **ansible** est lui meme compose de :
  - un fichier de config (ansible.cfg)
  - un fichier gcp_compute.yml qui est l'inventaire dynamique ansible a l'aide du plugin gcp_compute
  - un playbook qui install Wordpress et MariaDB ainsi que les dependances necessaire et qui parametre le tout
  - un fichier myvarsfile.yml composé de l'ensemble des variables pour les id de connexion de MariaDB
- Le dossier **Terraform** est decoupe en sous dossier, chaque dossier representant un module terraform (Network, Instances, Firewall, Compte de service), ainsi que des fichiers main et variables principaux.
- Le script **creation_cle_ssh.sh** sert comme son nom l'indique a creer les cles SSH necessaire a la connexion de Ansible aux VM.
- Le script **deploiement_cle_ssh.sh** sert quant a lui au deploiement des cles SSH dans les metadata des VM.
- Le script **test_deploiement.sh** est lancer tout a la fin du deploiement afin de verifier que l'ensemble du deploiement s'est bien deroulé et que wordpress est bien accessible.
- Pour finir le scirpt **deployment.sh** est le script qui s'occupe pour vous de lancer l'ensemble de deploiement c'est l'ami des fans de cafe.

## Prerequis

Disposer d'un compte GCP avec facturation, thats it :)

## Deroulement du deploiement

1. [ ] Creer un projet GCP
2. [ ] Acceder au projet GCP
3. [ ] Ouvrir Cloud SHell
4. [ ] Cloner l'ensemble du repot `git clone https://github.com/khagou/tp1-deployment-wordpress-gcp.git`
5. [ ] Entrer dans le dossier téléchargé `cd tp1-deployment-wordpress-gcp`
6. [ ] Modification des variables:
   - Dans cloud shell, cliquer le bouton **ouvrir l'editeur**
   - accedez au dossier **terraform** et changez les variables du fichier _variables.tf_ et changez la variable gcp_project, vous pouvez aussi changer les autres en fonction de vos besoins.
   - accedez ensuite au dossier _ansible_ et ouvrez le **myvarsfile.yml** et changez l'ensemble des variables ainsi qu'au fichier **gcp_compute.yml** pour changer le projet et le nom du fichier du compte de service si vous l'avez change dans le fichier variables de terraform.
   - dans le scirpt **creation_cle_ssh.sh** modifier la variable user par votre nom d'utilisateur
   - dans le script **deploiement_cle_ssh.sh** modifier le nom du projet par l'id de votre projet
   - dans le script **deployment.sh** modifier la variable projet par votre id de projet
   - dans **test_deploiement.sh** modifier la zone si necessaire
7. [ ] Retourner dans cloud shell et lancer le script de deploiement `sh deployment.sh`
8. [ ] Aller chercher un café et trouver un bon collegue pour patienter :)
9. [ ] Quand l'installation est fini vous pouvez acceder au lien **_< ip-instance-wordpress >/wordpress_**
