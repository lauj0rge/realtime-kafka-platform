output "db_host" {
  description = "Internal hostname for PostgreSQL service"
  value       = "${var.release_name}-${var.env}.${var.namespace}-${var.env}.svc.cluster.local"
}

output "db_user" {
  description = "Default PostgreSQL user"
  value       = "postgres"
}

output "db_name" {
  description = "Default PostgreSQL database"
  value       = "postgres"
}

output "db_password" {
  description = "PostgreSQL password"
  value       = var.postgres_password
  sensitive   = true
}