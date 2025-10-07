resource "kubernetes_namespace" "monitoring" {
  metadata {
    name = "${var.namespace}-${var.env}"
  }
}

resource "helm_release" "prometheus" {
  name       = "${var.release_name}-${var.env}"
  namespace  = kubernetes_namespace.monitoring.metadata[0].name
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "prometheus"
  version    = var.chart_version
  create_namespace  = false

  dynamic "set" {
    for_each = var.prometheus_settings
    content {
      name  = set.key
      value = set.value
    }
  }
}
