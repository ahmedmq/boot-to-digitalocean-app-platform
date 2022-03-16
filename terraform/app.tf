locals {
  app-instance-type = lookup(var.app_instance_type, local.environment)
}

variable "app_instance_type" {
  type = map(string)

  default = {
    dev  = "basic-xs"
    qa   = "basic-xs"
    prod = "professional-s"
  }
}


resource "digitalocean_app" "demo-app" {
  spec {
    name   = "demo-${local.environment}-app"
    region = var.do_region
    domain {
      name = "${local.environment}.demo.com"
      type = "PRIMARY"
      zone = "demo.com"
    }
    service {
      name               = "demo-${local.environment}-app-svc"
      instance_size_slug = local.app-instance-type
      instance_count     = local.environment == "prod" ? 2 : 1
      http_port          = 8080
      image {
        registry_type = "DOCR"
        repository    = var.docker-repo
        tag           = var.docker-tag
      }
      env {
        key   = "SPRING_DATASOURCE_USERNAME"
        value = "$${demo-db.USERNAME}"
        scope = "RUN_TIME"
        type  = "GENERAL"
      }
      env {
        key   = "SPRING_DATASOURCE_PASSWORD"
        value = "$${demo-db.PASSWORD}"
        scope = "RUN_TIME"
        type  = "SECRET"
      }
      env {
        key   = "SPRING_DATASOURCE_URL"
        value = "$${demo-db.JDBC_DATABASE_URL}"
        scope = "RUN_TIME"
        type  = "GENERAL"
      }
      env {
        key   = "SPRING_PROFILES_ACTIVE"
        value = "cloud,${local.environment}"
        scope = "RUN_TIME"
        type  = "GENERAL"
      }
      health_check {
        http_path             = "/actuator/health/liveness"
        initial_delay_seconds = 30
        period_seconds        = 20
      }
    }

    database {
      name         = "demo-db"
      engine       = "PG"
      version      = "12"
      production   = local.environment == "dev" ? false : true
      cluster_name = local.environment == "dev" ? "" : digitalocean_database_cluster.demo-db-cluster[0].name
      db_name      = local.environment == "dev" ? "" : digitalocean_database_db.demo-db[0].name
      db_user      = local.environment == "dev" ? "" : digitalocean_database_user.demo-user[0].name
    }
  }
}
