local ddb = import 'ddb.docker.libjsonnet';

ddb.Compose(
    ddb.with(import '.docker/postgres/djp.libjsonnet',
    name='db') +
    { services+: {
        sonarqube: ddb.Build("sonarqube")
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
                    "sonarqube_conf:/opt/sonarqube/conf",
                    "sonarqube_data:/opt/sonarqube/data",
                    "sonarqube_bundled-plugins:/opt/sonarqube/lib/bundled-plugins",
                ]
            }
        }
    }
)
