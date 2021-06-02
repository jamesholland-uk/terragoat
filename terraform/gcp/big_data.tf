resource "random_id" "db" {
  keepers = {
    db_id = "${var.project}"
  }
  byte_length = 6
}

resource google_sql_database_instance "master_instance" {
  name                = lower("terragoat-${var.environment}-master-${random_id.db.id}")
  database_version    = "POSTGRES_11"
  region              = var.region
  deletion_protection = false

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
