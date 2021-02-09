ddb-sonarqube
===
Ce projet permet de mettre à disposition une instance locale de SonarQube.

# Installation

Il vous faut mettre à jour la configuration de la machine :

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

Il est possible de créer un fichier `.docker/sonarqube/sonar.custom.properties` pour ajouter des propriétés de 
configuration Sonarqube, ou bien de passer par l'objet de configuration ddb `sonarqube.config`.

# Connexion

Sonarqube sera accessible via son adresse, récupérable grace à la commande `ddb info`

Le compte par défaut est celui de base de SonarQube : admin/admin

À partir de là, vous pouvez créer vos projets, générer vos tokens et utiliser votre instance locale de SonarQube dans
vos projets

# Exécuter un scan sur un projet

Pour exécuter un scan, voir [inetum-orleans/ddb-sonarqube-scanner](https://github.com/inetum-orleans/ddb-sonarqube-scanner).
