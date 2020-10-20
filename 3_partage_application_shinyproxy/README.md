# Partager son application via Shinyproxy et l'utilisation de containers Docker

## Création de l’image docker de l’application Shiny à déployer

Je crée l’image docker de l'application Shiny à déployer sur shinyproxy. 

Je fais ça sur un serveur linux sur lequel Docker est installé.

Structure du dossier à partir duquel je vais construire l'image Docker de l'application : 



Pré-requis : avoir docker installé
On crée l’image de l’application hackathon : 
Dans le dossier de l’application Shiny : 
Préparation du dockerfile de son application, qui installe R, les packages dont dépend l’application ainsi que le package contenant l’application, qu’on a créé précédemment : 
 
+ il faut le fichier Rprofile.site
 
+ l’archive hackathon_0.1.0.tar.gz
cd /var/Shinyproxy/partage_application_shinyproxy
docker build -t avelt/hackathon .  -> très long l’installation de R, voir si je peux pas faire un VM où je préinstalle R sur docker
docker login
docker push avelt/hackathon
A présent que l’image existe, on peut la puller sur un serveur ec2 amazon et déployer l’application sur un shinyproxy.
















