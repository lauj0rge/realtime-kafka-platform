resource "kubernetes_namespace" "app_namespace" {
  metadata {
    name = "${var.namespace}-${var.env}"
  }
}

resource "kubernetes_deployment" "producer" {
  metadata {
    name      = "event-producer"
    namespace = "${var.namespace}-${var.env}"
  }

  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "event-producer"
      }
    }
    template {
      metadata {
        labels = {
          app = "event-producer"
        }
      }
      spec {
        container {
          name  = "producer"
          image = var.image
          image_pull_policy = "IfNotPresent"

          env {
            name  = "KAFKA_BROKER"
            value = var.kafka_bootstrap_servers
          }
          env {
            name  = "KAFKA_TOPIC"
            value = var.kafka_topic
          }
        }
      }
    }
  }
}