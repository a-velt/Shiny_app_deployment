# Partager son application via Shinyproxy et l'utilisation de containers Docker

## Création de l’image docker de l’application Shiny à déployer

Je crée l’image docker de l'application Shiny à déployer sur shinyproxy. 

Je fais ça sur un serveur linux sur lequel Docker est installé. Note : je le fais la construction en avance car l'installation de R et de ses packages est longue, donc la construction de l'image est longue.

**Structure du dossier à partir duquel je vais construire l'image Docker de l'application :**

<img src="https://github.com/a-velt/Shiny_app_deployment/blob/main/3_partage_application_shinyproxy/images/1.png" height="100">

Il y a un Dockerfile pour construire l'image, la source de notre package contenant l'application Shiny et un fichier Rprofile.site.

**Contenu du Dockerfile :**

```
FROM rocker/r-ver

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update

## packages needed for basic shiny functionality
RUN Rscript -e "install.packages(c('shiny', 'ggplot2'),repos='https://cloud.r-project.org')"

# install the shiny application
COPY hackathon_0.1.0.tar.gz /root/
RUN R CMD INSTALL /root/hackathon_0.1.0.tar.gz
RUN rm /root/hackathon_0.1.0.tar.gz

# set host & port
COPY Rprofile.site /usr/lib/R/etc/
EXPOSE 3838

CMD ["R", "-e hackathon::shiny_application()"]
```

**Contenu du Rprofile.site :**

```
local({
   old <- getOption("defaultPackages")
   options(defaultPackages = c(old, "hackathon"), shiny.port = 3838, shiny.host = "0.0.0.0")
})
```

Note : Le Dockerfile permet d'installer R dans un environnement Linux, puis d'installer les packages "shiny" et "ggplot2" nécessaires au fonctionnement de notre application Shiny. Ensuite, il va copier la source de notre package R contenant l'application et va l'installer dans l'instance R disponible. Il copie le fichier Rprofile.site au bon endroit pour s'assurer que l'application Shiny sera lancée sur le port attendu par Shinyproxy, ici le port 3838. Il expose le port 3838 et enfin, il exécute la fonction permettant de lancer l'application Shiny.

**Construction de l'image Docker :**

Une fois ces 3 fichiers préparés, il suffit de se placer dans le dossier et d'exécuter la commande suivante : 

```
docker build -t avelt/hackathon .  
```

La construction de l'image étant très longue, dû à l'installation de l'ensemble des packages permettant de faire fonctionner Shiny et ggplot2, je vous conseille de récupérer directement l'image que j'ai généré et rendue disponible sur dockerhub.

**Partage de l'image sur Dockerhub :**

```
docker login
docker push avelt/hackathon
```

**Récupérer l'image via Dockerhub :** 

```
docker pull avelt/hackathon
```

## Déploiement de l'application Shiny avec Shinyproxy

### Lancement/configuration d'une instance EC2 AWS

Pour cet atelier, je vais installer et configurer Shinyproxy sur une instance EC2 d'AWS.

https://eu-west-3.console.aws.amazon.com/ec2/v2/home?region=eu-west-3#Home

Je choisi une instance Ubuntu 20.04 :

<img src="https://github.com/a-velt/Shiny_app_deployment/blob/main/3_partage_application_shinyproxy/images/2.png" height="100">

Je prends la version micro, gratuite, avec 1Go de RAM :

<img src="https://github.com/a-velt/Shiny_app_deployment/blob/main/3_partage_application_shinyproxy/images/3.png" height="100">

Et dans la configuration des groupes de sécurité, j'ouvre le port 80, 443 et 8080 :

<img src="https://github.com/a-velt/Shiny_app_deployment/blob/main/3_partage_application_shinyproxy/images/4.png" height="100">

Je me connecte en ssh sur l'instance EC2 avec le fichier .pem contenant la clé publique et avec l'utilisateur ubuntu :

```
ssh -i fichier.pem ubuntu@15.*.*.* 
```

### Installation de Docker sur l'instance EC2 AWS

J'installe Docker et docker-compose sur cette instance en suivant le mode op' proposé par Docker (https://docs.docker.com/engine/install/ubuntu/ et https://docs.docker.com/compose/install/ ) : 

```
sudo apt-get update
sudo apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo apt-key fingerprint 0EBFCD88
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
sudo apt-get install docker-ce docker-ce-cli containerd.io
sudo curl -L "https://github.com/docker/compose/releases/download/1.27.4/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
```

J'ajoute le user ubuntu au groupe docker pour ne pas avoir à lancer les commandes docker en root :

```
sudo usermod -a -G docker ubuntu
```

J'installe Java, qui est nécessaire pour faire fonctionner Shinyproxy : 

```
sudo apt install default-jdk
```

### Installation de Shinyproxy sur l'instance EC2 AWS

Je récupère le Dockerfile et le fichier application.yml.

```
mkdir shinyproxy
cd shinyproxy
wget https://raw.githubusercontent.com/a-velt/Shiny_app_deployment/main/3_partage_application_shinyproxy/shinyproxy/Dockerfile
wget https://raw.githubusercontent.com/a-velt/Shiny_app_deployment/main/3_partage_application_shinyproxy/shinyproxy/application.yml
```

Créer un réseau docker que Shinyproxy va utiliser pour communiquer avec les containers Shiny :

```
docker network create sp-example-net
```

Je construit l'image Shinproxy :

```
docker build -t shinyproxy .
```

Je récupère l'image de mon application Shiny et des deux applications Shiny exemple proposées par Shinyproxy :

```
docker pull avelt/hackathon
docker pull openanalytics/shinyproxy-demo
```

### Lancement de Shinyproxy sur l'instance EC2 AWS

Je lance Shinyproxy sur le port 8080

```
sudo docker run -d -v /var/run/docker.sock:/var/run/docker.sock --net sp-example-net -p 8080:8080 shinyproxy
```

Maintenant, pour se connecter à Shinyproxy : 

http://15.*.*.*:8080/login


Avec exemple user1/user1_pass.












