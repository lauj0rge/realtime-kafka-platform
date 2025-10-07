output "bootstrap_server" {
  description = "Kafka bootstrap server address"
  value = "${var.release_name}-${var.env}.${var.namespace}-${var.env}.svc.cluster.local:9092"
}

