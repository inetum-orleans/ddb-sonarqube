local ddb = import 'ddb.docker.libjsonnet';

ddb.Compose(
    ddb.with(import '.docker/postgres/djp.libjsonnet',
    name='db') +
    { services+: {
        sonarqube: ddb.Image("sonarqube:10-community")
            + ddb.VirtualHost("9000", ddb.domain, "sonarqube")
            + {
                depends_on: ['db'],
                environment: {
                  'SONAR_ES_BOOTSTRAP_CHECKS_DISABLE': 'true',
                  'SONAR_JDBC_URL': 'jdbc:postgresql://db:5432/' + ddb.projectName,
                  'SONAR_JDBC_USERNAME': ddb.projectName,
                  'SONAR_JDBC_PASSWORD': ddb.projectName
                },
                volumes: [
                    "sonarqube-db-data:/var/lib/postgresql/data:rw",
                    "sonarqube_conf:/opt/sonarqube/conf",
                    "sonarqube_data:/opt/sonarqube/data",
                    "sonarqube_extensions:/opt/sonarqube/extensions",
                    "sonarqube_bundled-plugins:/opt/sonarqube/lib/bundled-plugins",
                    ddb.path.project + "/.docker/sonarqube/sonar.properties:/opt/sonarqube/conf/sonar.properties",
                    ddb.path.project + "/plugins/sonarqube-community-branch-plugin.jar:/opt/sonarqube/extensions/plugins/sonarqube-community-branch-plugin.jar",
                    ddb.path.project + "/plugins/sonarqube-community-branch-plugin.jar:/opt/sonarqube/lib/common/sonarqube-community-branch-plugin.jar",
                    ddb.path.project + "/plugins/sonar-dependency-check-plugin.jar:/opt/sonarqube/extensions/plugins/sonar-dependency-check-plugin.jar",
                    ddb.path.project + "/plugins/sonar-auth-oidc-plugin.jar:/opt/sonarqube/extensions/plugins/sonar-auth-oidc-plugin.jar"
                ]
            }
        }
    }
)
