# TP 1 Deploiement Wordpress MariaDB sur GCP avec terraform et ansible

## Composition du repot
<<<<<<< HEAD

Le repot est composé de 2 dossier et 4 scripts shell:

- Le dossier **ansible** est lui meme compose de :
  - un fichier de config (ansible.cfg)
  - un fichier gcp_compute.yml qui est l'inventaire dynamique ansible a l'aide du plugin gcp_compute
  - un playbook qui install Wordpress et MariaDB ainsi que les dependances necessaire et qui parametre le tout
- Le dossier **Terraform** est decoupe en sous dossier, chaque dossier representant un module terraform (Network, Instances, Firewall, Compte de service), ainsi que des fichiers main et variables principaux.
- Le script **creation_cle_ssh.sh** sert comme son nom l'indique a creer les cles SSH necessaire a la connexion de Ansible aux VM.
- Le script **deploiement_cle_ssh.sh** sert quant a lui au deploiement des cles SSH dans les metadata des VM.
- Le script **test_deploiement.sh** est lancer tout a la fin du deploiement afin de verifier que l'ensemble du deploiement s'est bien deroulé et que wordpress est bien accessible.
- Pour finir le scirpt **deployment.sh** est le script qui s'occupe pour vous de lancer l'ensemble de deploiement c'est l'ami des fans de cafe.

## Prerequis

Disposer d'un compte GCP avec facturation, thats it :)

## Deroulement du deploiement

=======
Le repot est composé de 2 dossier et 4 scripts shell:
  - Le dossier **ansible** est lui meme compose de :
    * un fichier de config (ansible.cfg)
    * un fichier gcp_compute.yml qui est l'inventaire dynamique ansible a l'aide du plugin gcp_compute
    * un playbook qui install Wordpress et MariaDB ainsi que les dependances necessaire et qui parametre le tout
  - Le dossier **Terraform** est decoupe en sous dossier, chaque dossier representant un module terraform (Network, Instances, Firewall, Compte de service), ainsi que des fichiers main et variables principaux.
  - Le script **creation_cle_ssh.sh** sert comme son nom l'indique a creer les cles SSH necessaire a la connexion de Ansible aux VM.
  - Le script **deploiement_cle_ssh.sh** sert quant a lui au deploiement des cles SSH dans les metadata des VM.
  - Le script **test_deploiement.sh** est lancer tout a la fin du deploiement afin de verifier que l'ensemble du deploiement s'est bien deroulé et que wordpress est bien accessible.
  - Pour finir le scirpt **deployment.sh** est le script qui s'occupe pour vous de lancer l'ensemble de deploiement c'est l'ami des fans de cafe.

## Prerequis
Disposer d'un compte GCP avec facturation, thats it :)


## Deroulement du deploiement
>>>>>>> 3cb0ae65e7df58a6beaf55ba8ad2c423d7347cc3
1. [ ] Creer un projet GCP
2. [ ] Acceder au projet GCP
3. [ ] Ouvrir Cloud SHell
4. [ ] Cloner l'ensemble du repot `git clone https://github.com/tp1-deployment-wordpress-gcp.git`
5. [ ] Entrer dans le dossier téléchargé `cd tp1-deployment-wordpress-gcp`
6. [ ] Lancer le script de deploiement `sh deployment.sh`
7. [ ] Aller chercher un café et trouver un bon collegue pour patienter :)
8. [ ] Quand l'installation est fini vous pouvez acceder au lien **_< ip-instance-wordpress >/wordpress_**
