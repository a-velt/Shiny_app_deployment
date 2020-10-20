# Partager son application via Shinyproxy et l'utilisation de containers Docker

## Création de l’image docker de l’application Shiny à déployer

Je crée l’image docker de l'application Shiny à déployer sur shinyproxy. 

Je fais ça sur un serveur linux sur lequel Docker est installé.

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

# install great package with great shiny application
COPY hackathon_0.1.0.tar.gz /root/
RUN R CMD INSTALL /root/hackathon_0.1.0.tar.gz
RUN rm /root/hackathon_0.1.0.tar.gz

# set host and port
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

Une fois ces 3 fichiers préparés, il suffit de se placer dans le dossier et d'exécuter la commande suivante : 

```
docker build -t avelt/hackathon .  
```

La construction de l'image étant très longue, dû à l'installation de l'ensemble des packages permettant de faire fonctionner Shiny et ggplot2, je vous conseille de récupérer directement l'image que j'ai généré et rendue disponible sur dockerhub.

Pour mettre votre image construire sur Dockerhub :

```
docker login
docker push avelt/hackathon
```

Pour récupérer l'image pour cet atelier, sans avoir à la construire : 

```
docker pull avelt/hackathon
```


















