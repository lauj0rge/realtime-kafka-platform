variable "env" { type = string }

# PostgreSQL
variable "postgres_namespace" { type = string }
variable "postgres_release_name" { type = string }
variable "postgres_chart_version" { type = string }
variable "postgres_password" {
  type      = string
  sensitive = true
}

# Kafka
variable "kafka_namespace" { type = string }
variable "kafka_release_name" { type = string }
variable "kafka_settings" { type = map(string) }
variable "kafka_chart_version" {type = string}

# Kafka Exporter
variable "kafka_exporter_enabled" { type = string }
variable "kafka_exporter_release_name" { type = string }
variable "kafka_exporter_chart_version" { type = string }
variable "kafka_exporter_settings" { type = map(string) }

# Prometheus
variable "prom_namespace" { type = string }
variable "prom_release_name" { type = string }
variable "prom_chart_version" { type = string }
variable "prom_settings" { type = map(string) }

# Producer
variable "producer_replicas" {type = string}

# Streaming consumer
variable "app_namespace" { type = string }
variable "stream_consumer_image" { type = string }
variable "batch_consumer_image" { type = string }  

