variable "env" { type = string }
variable "namespace" { type = string }
variable "release_name" { type = string }
variable "chart_version" { type = string }
module "postgres" {
  source = "./modules/postgres"
  db_password = var.postgres_password
}

