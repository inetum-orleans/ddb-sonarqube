local ddb = import 'ddb.docker.libjsonnet';

local db_user = "drupal";
local db_password = "drupal";

local domain = std.join('.', [std.extVar("core.domain.sub"), std.extVar("core.domain.ext")]);
local port_prefix = std.extVar("docker.port_prefix");

local web_workdir = "/var/www/html";
local app_workdir = "/app";

local prefix_port(port, output_port = null)= [port_prefix + (if output_port == null then std.substr(port, std.length(port) - 2, 2) else output_port) + ":" + port];

ddb.Compose() {
    "services": {
        "sonarqube": ddb.Image("sonarqube:community")
            + ddb.VirtualHost("9000", domain, "sonarqube")
            + {
                depends_on: ['db'],
                environment: {
                  'SONAR_ES_BOOTSTRAP_CHECKS_DISABLE': 'true',
                  'SONAR_JDBC_URL': 'jdbc:postgresql://db:5432/sonarqube',
                  'SONAR_JDBC_USERNAME': 'sonarqube',
                  'SONAR_JDBC_PASSWORD': 'sonarqube',
                }
            },

		"db": ddb.Build("db")
            + ddb.Binary("psql", app_workdir, "psql --dbname=postgres://sonarqube:sonarqube@sonarqube-db/sonarqube")
            + ddb.Binary("pg_dump", app_workdir, "pg_dump --dbname=postgres://sonarqube:sonarqube@sonarqube-db/sonarqube")
            + ddb.Binary("pg_restore", app_workdir, "pg_restore --dbname=postgres://sonarqube:sonarqube@sonarqube-db/sonarqube")
            + {
                environment: {
                  POSTGRES_DB: 'sonarqube',
                  POSTGRES_USER: 'sonarqube',
                  POSTGRES_PASSWORD: 'sonarqube',
                },
                volumes: [
                    "sonarqube-db-data:/var/lib/postgresql/data:rw",
                    ddb.path.project + ":" + app_workdir,
//                    ddb.path.project + "/.docker/db/init/init.sql:/docker-entrypoint-initdb.d/init.sql"
                ]
            },
    }
}
