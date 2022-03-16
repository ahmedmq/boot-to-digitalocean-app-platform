locals {
  db-cluster-instance-type = lookup(var.database_type, local.environment)
}

resource "digitalocean_database_cluster" "demo-db-cluster" {
  count      = local.environment == "dev" ? 0 : 1
  name       = "demo-${local.environment}-db-cluster"
  engine     = "pg"
  version    = "12"
  size       = local.db-cluster-instance-type
  region     = var.do_region
  node_count = local.environment == "prod" ? 2 : 1
}

resource "digitalocean_database_db" "demo-db" {
  count      = local.environment == "dev" ? 0 : 1
  cluster_id = digitalocean_database_cluster.demo-db-cluster[0].id
  name       = "demo-${local.environment}-db"
}

resource "digitalocean_database_user" "demo-user" {
  count      = local.environment == "dev" ? 0 : 1
  cluster_id = digitalocean_database_cluster.demo-db-cluster[0].id
  name       = "demo"
}

resource "digitalocean_database_firewall" "demo-db-firewall" {
  count      = local.environment == "dev" ? 0 : 1
  cluster_id = digitalocean_database_cluster.demo-db-cluster[0].id

  rule {
    type  = "app"
    value = digitalocean_app.demo-app.id
  }

}

variable "database_type" {
  type = map(string)

  default = {
    dev  = "db-s-1vcpu-1gb" #Not actually used
    qa   = "db-s-1vcpu-1gb"
    prod = "db-s-4vcpu-8gb" #General purpose not available in BLR
  }

}