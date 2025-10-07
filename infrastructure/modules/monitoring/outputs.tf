output "prometheus_service" {
  description = "Prometheus internal endpoint for Kafka metrics"
  value       = "${helm_release.prometheus.name}-server.${kubernetes_namespace.monitoring.metadata[0].name}.svc.cluster.local:80"
}
