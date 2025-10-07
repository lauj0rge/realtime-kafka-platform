# Namespace
resource "kubernetes_namespace" "kafka_namespace" {
  metadata {
    name = "${var.namespace}-${var.env}"
  }
}

# Kafka Helm release
resource "helm_release" "kafka" {
  name             = "${var.release_name}-${var.env}"
  namespace        = kubernetes_namespace.kafka_namespace.metadata[0].name
  chart            = "bitnami/kafka"
  version          = var.kafka_chart_version
  create_namespace = false
  wait             = true

  dynamic "set" {
    for_each = var.kafka_settings
    content {
      name  = set.key
      value = set.value
    }
  }
}

# Kafka Exporter
resource "helm_release" "kafka_exporter" {
  depends_on = [helm_release.kafka]
  count      = var.kafka_exporter_enabled == "true" ? 1 : 0
  name       = "${var.kafka_exporter_release_name}-${var.env}"
  namespace  = kubernetes_namespace.kafka_namespace.metadata[0].name
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "prometheus-kafka-exporter"
  version    = var.kafka_exporter_chart_version
  wait       = true

  dynamic "set" {
    for_each = var.kafka_exporter_settings
    content {
      name  = set.key
      value = set.value
    }
  }
}

resource "null_resource" "kafka_exporter_annotations" {
  count = var.kafka_exporter_enabled == "true" ? 1 : 0

  triggers = {
    kafka_exporter = helm_release.kafka_exporter[0].id
  }

  provisioner "local-exec" {
    command = <<EOT
      kubectl annotate service ${var.kafka_exporter_release_name}-${var.env}-prometheus-kafka-exporter \
        -n ${kubernetes_namespace.kafka_namespace.metadata[0].name} \
        prometheus.io/scrape=true \
        prometheus.io/port=9308 \
        prometheus.io/path=/metrics \
        --overwrite
    EOT
  }

  depends_on = [helm_release.kafka_exporter]
}
