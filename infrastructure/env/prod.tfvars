# infrastructure/env/prod.tfvars
env = "prod"

# PostgreSQL
postgres_namespace     = "postgresql"
postgres_release_name  = "postgresql"
postgres_chart_version = "15.2.6"

# Kafka
kafka_namespace     = "kafka"
kafka_release_name  = "kafka"
kafka_chart_version = "32.1.3"
kafka_settings = {
  "image.registry"                      = "docker.io"
  "image.repository"                    = "bitnamilegacy/kafka"
  "zookeeper.image.registry"            = "docker.io"
  "zookeeper.image.repository"          = "bitnamilegacy/zookeeper"
  "metrics.jmx.image.repository"        = "bitnamilegacy/jmx-exporter"
  "metrics.jmx.image.tag"               = "1.2.0-debian-12-r1"
  "zookeeper.enabled"                   = "true"
  "zookeeper.replicaCount"              = "3"
  "persistence.enabled"                 = "true"
  "zookeeper.persistence.enabled"       = "true"
  "service.type"                        = "ClusterIP"
  "auth.clientProtocol"                 = "plaintext"
  "allowPlaintextListener"              = "true"
  "listeners.client.protocol"           = "PLAINTEXT"
  "listenerSecurityProtocolMap"         = "PLAINTEXT:PLAINTEXT"
  "auth.enableSasl"                     = "false"
  "auth.enableScram"                    = "false"
  "auth.enablePlain"                    = "false"
  "auth.interBrokerProtocol"            = "plaintext"
  "sasl.enabled"                        = "false"
  "kraft.enabled"                       = "false"
  "metrics.kafka.enabled"               = "true"
  "metrics.jmx.enabled"                 = "true"
  "global.security.allowInsecureImages" = "true"
  "kafka_exporter_enabled"              = "true"
  "replicaCount"                        = "3"
}

# Kafka Exporter
kafka_exporter_enabled       = "true"
kafka_exporter_release_name  = "kafka-exporter"
kafka_exporter_chart_version = "2.0.0"
kafka_exporter_settings = {
  "image.repository"          = "danielqsj/kafka-exporter"
  "image.tag"                 = "v1.7.0"
  "kafkaServer[0]"            = "kafka-prod:9092"
  "resources.limits.memory"   = "256Mi"
  "resources.requests.memory" = "128Mi"
  "logLevel"                  = "info"
  "service.port"              = "9308"
  "service.type"              = "ClusterIP"
}

# Prometheus
prom_namespace     = "monitoring"
prom_release_name  = "prometheus"
prom_chart_version = "25.16.0"
prom_settings = {
  "server.persistentVolume.enabled"       = "true"
  "alertmanager.persistentVolume.enabled" = "true"
  "server.resources.limits.memory"        = "1Gi"
  "alertmanager.resources.limits.memory"  = "512Mi"
  "server.replicaCount"                   = "1"
}

# Applications
app_namespace          = "data-platform"
app_image              = "producer:prod"
stream_consumer_image  = "realtime-consumer:prod"
batch_consumer_image   = "batch-consumer:prod"
producer_replicas      = "2"