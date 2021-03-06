# Partager son application via Shinyapps.io

Shinyapps.io est une Plateforme en tant que Service (PaaS) pour héberger des applications Shiny. En créant un compte sur shinyapps.io, il est possible de déployer très facilement son application sur le cloud. 

## Pré-requis :
-	R/Rstudio
-	Le package rsconnect permet de déployer les applications sur le service shinyapps.io. Il faut donc l’installer. 
      ```r
      install.packages('rsconnect')
      ```

## Créer son compte :

https://www.shinyapps.io/admin/#/signup
(Créer son compte ou se connecter via son gmail ou son compte GitHub)

## Paramétrer son compte :

Une fois connecté, il vous est demandé de paramétrer votre compte : 
![alt text](https://github.com/a-velt/Shiny_app_deployment/blob/main/1_partage_application_shinyapps.io/1.png "Paramétrer son compte 1")

Un nom de compte vous est demandé et sera utilisé comme nom de domaine lors du partage de vos applications Shiny. Je mets « hackathon-avelt ».
On arrive ensuite sur une page qui nous montre comment partager son application en 3 étapes : 
![alt text](https://github.com/a-velt/Shiny_app_deployment/blob/main/1_partage_application_shinyapps.io/2.png "Paramétrer son compte 2")

Globalement, il faut autoriser ce compte shinyapps.io en local sur votre ordinateur avec le package rsconnect. Pour cela, il suffit de copier-coller le code proposé, en cliquant d’abord sur le bouton « Show secret » puis en copiant-collant le code sous votre R local.

## Déployer son application :

Enfin, on partage l’application Shiny contenu dans un dossier : 

```r
rsconnect::deployApp(appDir = "/path/to/1_partage_application_shinyapps.io/hackathon/", account = 'hackathon-avelt')
```

## Partager son application :

Une fois l’application déployé, le browser s’ouvre à la bonne adresse :

https://hackathon-avelt.shinyapps.io/hackathon/

Ce lien peut alors être partagé.
















