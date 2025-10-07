# POSTGRESQL
output "db_host" {
  value       = module.postgres.db_host
  description = "Internal hostname for PostgreSQL"
}

output "db_user" {
  value       = module.postgres.db_user
  description = "PostgreSQL user"
}

output "db_name" {
  value       = module.postgres.db_name
  description = "PostgreSQL database name"
}

# Kafka
output "kafka_bootstrap_server" {
  description = "Kafka internal bootstrap server address"
  value       = module.kafka_cluster.bootstrap_server
}

# Prometheus
output "prometheus_service" {
  description = "Prometheus internal endpoint for Kafka metrics"
  value       = module.prometheus.prometheus_service
}
