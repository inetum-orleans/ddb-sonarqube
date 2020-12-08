gfi-centre-ouest/ddb-sonarqube
===
Ce projet permet de mettre à disposition une instance locale de SonarQube et de s'en servir au sein des différents
projets.

# Installation

Avant de lancer les, il vous faut mettre à jour la configuration de la machine :

```shell script
sudo sed -i -e '/^\(vm.max_map_count=\).*/{s//\1262144/;:a;n;ba;q}' -e '$avm.max_map_count=262144' /etc/sysctl.conf
```

Cette action n'étant prise en compte qu'au prochain redémarrage, voici la commande pour la mettre à jour
temporairement :

```shell script
sudo sysctl -w vm.max_map_count=262144
```

Ensuite, il faut configurer la stack :

```shell script
ddb configure
$(ddb activate)
docker-compose up -d
```

Puis installer un alias sonar-scanner global

```
curl -sLo ~/.docker-devbox/bin/sonar-scanner https://github.com/gfi-centre-ouest/ddb-sonarqube/raw/master/bin/sonar-scanner && chmod +x ~/.docker-devbox/bin/sonar-scanner
```

# Configuration Sonarqube

Si vous le souhaitez, en rajouter un ddb.local.yaml au sein de votre projet, vous pourrez surcharger tout ou partie de
la configuration.

Un exemple est la manière dont démarre sonarqube, soit à la demande, soit à chaque démarrage de la machine :

```yaml
docker:
  restart_policy: 'unless-stopped'
```

# Connexion

Sonarqube sera accessible via son adresse, récupérable grace à la commande `ddb info`

Le compte par défaut est celui de base de SonarQube : admin/admin

À partir de là, vous pouvez créer vos projets, générer vos tokens et utiliser votre instance locale de SonarQube dans
vos projets

# [Configuration projet](configurations/README.md)
