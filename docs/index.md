DDB Sonarqube
===

This project is a ready to use Sonarqube instance for [docker-devbox-ddb] environments.

# Requirement
First and foremost, you need to have an environment where [docker-devbox-ddb] is installed.

## Configuration for Linux based environment
You will need to update some system variables, as follows: 
```shell
sudo sed -i -e '/^\(vm.max_map_count=\).*/{s//\1262144/;:a;n;ba;q}' -e '$avm.max_map_count=262144' /etc/sysctl.conf
```

As it is taken into account after a reboot, you can execute the following before rebooting:
```shell
sudo sysctl -w vm.max_map_count=262144
```
It will update the same configuration but local to your session.

# Installation
First, you need to clone the [repository of the project](https://github.com/inetum-orleans/ddb-sonarqube/)

Then, you need to configure the project with ddb configuration. For more detail, please refer to [docker-devbox-ddb] 
official documentation.

To do so, you need to run the following command : 
```shell
ddb configure
```

Now you can run the project:
```shell
docker compose up -d
```

That's it! Sonarqube is now running in your environement with ddb!

If you want to check the URL to access it, simply run `ddb info`.

# Default plugins

By default, the project contains the following plugins:

1. [dependency-check/dependency-check-sonar-plugin](https://github.com/dependency-check/dependency-check-sonar-plugin)
2. [mc1arke/sonarqube-community-branch-plugin](https://github.com/mc1arke/sonarqube-community-branch-plugin)
3. [vaulttec/sonar-auth-oidc](https://github.com/vaulttec/sonar-auth-oidc)
4. [cnescatlab/sonar-cnes-report](https://github.com/cnescatlab/sonar-cnes-report)

# Configuration

Out of the box, Sonarqube will be accessible and work as expected with default installation.

For some part of the application or for some plugins, you may want to update Sonarqube configuration.

To do so, you just need to create a `ddb.local.yaml` in the project. 
In this file, you will need to add configuration as follows: 
```shell
sonarqube:
  config:
    "<config-key>": "<config-value>"
```

For each config key, you will need to add a line in the file. For instance, if you want to enable the OIDC plugin :
```yaml
sonarqube:
  config:
    "sonar.auth.oidc.enabled": true
```

Once everything is configure as wanted, just run `ddb configure` and restart your containers using `docker compose down`
and `docker compose up -d` 

[docker-devbox-ddb]: https://inetum-orleans.github.io/docker-devbox-ddb/
