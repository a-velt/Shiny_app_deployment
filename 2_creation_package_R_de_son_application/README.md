# Partager son application sous forme de package R

Une autre solution est de packager son application Shiny et de permettre ainsi aux utilisateurs d'installer l'application Shiny via ce package R et de la lancer avec une fonction pré-définie.

## Créer un package R "vide"

Sous Rstudio, créer un nouveau projet …

<img src="https://github.com/a-velt/Shiny_app_deployment/blob/main/2_creation_package_R_de_son_application/images/1.png" height="450">

Créer un nouveau répertoire …

<img src="https://github.com/a-velt/Shiny_app_deployment/blob/main/2_creation_package_R_de_son_application/images/2.png" height="350">

Créer un package R …

<img src="https://github.com/a-velt/Shiny_app_deployment/blob/main/2_creation_package_R_de_son_application/images/3.png" height="350">

Choisir le nom et la localisation de son package et le créer ...

<img src="https://github.com/a-velt/Shiny_app_deployment/blob/main/2_creation_package_R_de_son_application/images/4.png" height="350">

Le dossier créé ressemble à ça dans la localisation choisi :

<img src="https://github.com/a-velt/Shiny_app_deployment/blob/main/2_creation_package_R_de_son_application/images/5.png" height="200">

## Mettre en place l'application Shiny dans ce package

Créer un dossier inst, qui contiendra les fichiers externes et les fichiers de l’application Shiny : 

<img src="https://github.com/a-velt/Shiny_app_deployment/blob/main/2_creation_package_R_de_son_application/images/6.png" height="200">

Dans le dossier « inst », créer un sous-dossier « extdata » qui contiendra les données externes et un sous-dossier « hackathon_application » qui contiendra l'application  :

<img src="https://github.com/a-velt/Shiny_app_deployment/blob/main/2_creation_package_R_de_son_application/images/7.png" height="150">

Dans le dossier « hackathon_application », copier-coller le script  « app.R »

<img src="https://github.com/a-velt/Shiny_app_deployment/blob/main/2_creation_package_R_de_son_application/images/8.png" height="150">

Dans « extdata », copier-coller les fichiers « euros.tsv », « forbes.csv » et « newcomb.csv »

<img src="https://github.com/a-velt/Shiny_app_deployment/blob/main/2_creation_package_R_de_son_application/images/9.png" height="150">

Modifier le fichier app.R pour qu’il aille chercher les 3 fichiers externes dans le bon dossier : 

![alt text](https://github.com/a-velt/Shiny_app_deployment/blob/main/2_creation_package_R_de_son_application/images/10.png)

La fonction « system.file() » permet de recréer le chemin absolu vers le fichier contenu dans le dossier « extdata » du package hackathon.

Revenir dans le dossier « inst », créer un sous-dossier « www » et copier-coller le fichier « styles.css »

![alt text](https://github.com/a-velt/Shiny_app_deployment/blob/main/2_creation_package_R_de_son_application/images/11.png)

Puis modifier le fichier app.R pour donner le chemin vers styles.css : 

![alt text](https://github.com/a-velt/Shiny_app_deployment/blob/main/2_creation_package_R_de_son_application/images/12.png)

## Ajouter des métadonnées de description au package R

Modifier le fichier « DESCRIPTION » pour ajouter des informations sur votre application Shiny et notamment les packages R dont elle dépend et qui doivent être importés : 

![alt text](https://github.com/a-velt/Shiny_app_deployment/blob/main/2_creation_package_R_de_son_application/images/13.png)

Le but du fichier DESCRIPTION est de stocker les métadonnées importantes du package et notamment quels packages sont nécessaires pour exécuter ce package. Lorsque ce package sera installé, si les packages dépendants ne sont pas installés, ils seront installés d’office. Cela permet de régler le problème des dépendances.

## Créer une fonction pour lancer l'application Shiny

Pour finir, retourner à la racine du package « hackathon », aller dans le dossier « R » et créer une fonction qui permettra de lancer l’application Shiny une fois le package installé.

Renommer le fichier créé par défaut « hello.R » en « shiny_application.R ».

Créer une fonction qui permet de lancer l’application Shiny sur le port 3838 du localhost (nécessaire pour le fonctionnement de Shinyproxy ensuite) : 

![alt text](https://github.com/a-velt/Shiny_app_deployment/blob/main/2_creation_package_R_de_son_application/images/14.png)

## Créer la source du package R

L’application Shiny est maintenant packagée, il faut créer la source de ce package (tar.gz) pour pouvoir le partager et l’installer.

### Spécificité Windows

Sous Windows, il faut tout d’abord installer RTools : 
https://cran.rstudio.com/bin/windows/Rtools/

Définir le chemin vers RTools : 

```r
writeLines('PATH="${RTOOLS40_HOME}\\usr\\bin;${PATH}"', con = "~/.Renviron")
```

Re-démarrer R et tester que RTools est dans les chemins : 

```r
Sys.which("make")
```

Si make est trouvé, c'est ok, on va pouvoir compiler et créer la source de notre package.

### Installation du package devtools

Ensuite il faut installer le package devtools et le charger :

```r
install.packages(‘devtools’)
library(‘devtools’)
```

Se placer dans le dossier du package : 

```r
setwd("/path/to/2_creation_package_R_de_son_application/hackathon")
```

Et lancer le build du package :

```r
build()
```

Le fichier source est créé : "/path/to/2_creation_package_R_de_son_application/hackathon_0.1.0.tar.gz"

## Partage de la source du package

Par exemple, partager ce fichier via Github. Une fois la source disponible sur votre dépôt git, tout le monde peut installer le package via ce lien.

### Pour installer le package via ce dépôt Git :

```r
install.packages("https://github.com/a-velt/Shiny_app_deployment/raw/main/2_creation_package_R_de_son_application/hackathon_0.1.0.tar.gz", repos = NULL, type="source")
```

### Puis pour lancer l’application shiny :

```r
library("hackathon")
shiny_application()
```

















