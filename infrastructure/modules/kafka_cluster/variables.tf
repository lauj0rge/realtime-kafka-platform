variable "env" { type = string }
variable "namespace" { type = string }
variable "release_name" { type = string }
variable "kafka_settings" { type = map(string) }
variable "kafka_chart_version" {type = string}
# Kafka Exporter
variable "kafka_exporter_enabled" { type = string }
variable "kafka_exporter_release_name" { type = string }
variable "kafka_exporter_chart_version" { type = string }
variable "kafka_exporter_settings" { type = map(string) }