output "deployment_name" {
  description = "Name of the producer deployment"
  value       = kubernetes_deployment.producer.metadata[0].name
}

output "namespace" {
  description = "Namespace where producer is deployed"
  value       = var.namespace
}

output "kafka_topic" {
  description = "Kafka topic being used"
  value       = var.kafka_topic
}