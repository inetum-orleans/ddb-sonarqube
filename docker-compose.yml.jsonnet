local ddb = import 'ddb.docker.libjsonnet';

local db_user = "drupal";
local db_password = "drupal";

local sonarqube_oauth = std.extVar("sonarqube.plugin.oauth");

local web_workdir = "/var/www/html";
local app_workdir = "/app";

ddb.Compose(
    ddb.with(import '.docker/postgres/djp.libjsonnet',
    name='db') +
    { services+: {
        sonarqube: ddb.Image("sonarqube:community")
            + ddb.VirtualHost("9000", ddb.domain, "sonarqube")
            + {
                depends_on: ['db'],
                environment: {
                  'SONAR_ES_BOOTSTRAP_CHECKS_DISABLE': 'true',
                  'SONAR_JDBC_URL': 'jdbc:postgresql://db:5432/sonarqube',
                  'SONAR_JDBC_USERNAME': 'sonarqube',
                  'SONAR_JDBC_PASSWORD': 'sonarqube'
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
