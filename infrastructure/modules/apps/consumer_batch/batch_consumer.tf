resource "kubernetes_deployment" "batch_consumer" {
  metadata {
    name      = "batch-consumer"
    namespace = "${var.namespace}-${var.env}"
  }

  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "batch-consumer"
      }
    }
    template {
      metadata {
        labels = {
          app = "batch-consumer"
        }
      }
      spec {
        container {
          name              = "batch-consumer"
          image             = var.image
          image_pull_policy = "IfNotPresent"

          env {
            name  = "KAFKA_BROKER"
            value = var.kafka_bootstrap_servers
          }
          env {
            name  = "KAFKA_TOPIC"
            value = var.kafka_topic
          }
          env {
            name  = "KAFKA_GROUP_ID"
            value = "batch-consumer-group"
          }
          env {
            name  = "DB_HOST"
            value = var.db_host
          }
          env {
            name  = "DB_PORT"
            value = var.db_port
          }
          env {
            name  = "DB_NAME"
            value = var.db_name
          }
          env {
            name  = "DB_USER"
            value = var.db_user
          }
          env {
            name  = "DB_PASSWORD"
            value = var.db_password
          }
        }
      }
    }
  }
}
