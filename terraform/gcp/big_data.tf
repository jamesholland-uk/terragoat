resource "random_pet" "db" {
  keepers = {
    db_id = "${var.db_id}"
  }
}

resource google_sql_database_instance "master_instance" {
  name             = "terragoat-${var.project}-${var.environment}-master-${random_pet.db.db_id}"
  database_version = "POSTGRES_11"
  region           = var.region

  settings {
    tier = "db-f1-micro"
    ip_configuration {
      ipv4_enabled = true
      authorized_networks {
        name  = "WWW"
        value = "0.0.0.0/0"
      }
    }
    backup_configuration {
      enabled = false
    }
  }
}

resource google_bigquery_dataset "dataset" {
  dataset_id = "terragoat_${var.environment}_dataset"
  access {
    special_group = "allAuthenticatedUsers"
    role          = "READER"
  }
  access {
    special_group = "projectOwners"
    role          = "OWNER"
  }
}
