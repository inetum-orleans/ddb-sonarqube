Configurations
===

Dans ce dossier vous trouverez de multiple configurations d'exemple. Pour les utiliser, il faudra :
* Créer le projet sur votre sonarqube
* Générer le token nécessaire
* Copier la configuration souhaitée dans le dossier de votre projet et renommez-le en `sonar-project.jinja.properties`
* Ajouter la configuration suivante dans votre fichier `ddb.yaml` ou `ddb.local.yaml`:
```yaml
sonar:
  host: http://sonarqube.test # L'adresse de votre SonarQube
  token: XXXXX # Le token généré dans SonarQube
  project_key: XXXXX # La clé projet généré dans SonarQube 
```
* Lancer la commande sonar-scanner 
* Dans les .gitignore au même niveau que le fichier de configuration, pensez à ajouter le dossier `/.scannerwork`

# Templates

* [Basic](basic.jinja.properties)
* [Drupal](drupal.jinja.properties)
* [Symfony](symfony.jinja.properties)