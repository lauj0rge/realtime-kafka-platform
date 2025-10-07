resource "kubernetes_namespace" "postgresql" {
  metadata {
    name = "${var.namespace}-${var.env}"
  }
}

# ConfigMap to initialize consumer tables
resource "kubernetes_config_map" "init_sql" {
  metadata {
    name      = "${var.release_name}-init-sql"
    namespace = kubernetes_namespace.postgresql.metadata[0].name
  }

  data = {
    "init.sql" = <<-EOT
      CREATE TABLE IF NOT EXISTS events_realtime (
        id SERIAL PRIMARY KEY,
        event_type TEXT NOT NULL,
        user_id INTEGER NOT NULL,
        timestamp TIMESTAMPTZ NOT NULL,
        consumed_at_ts BIGINT NOT NULL
      );

      CREATE TABLE IF NOT EXISTS events_batch (
        id SERIAL PRIMARY KEY,
        event_type TEXT NOT NULL,
        user_id INTEGER NOT NULL,
        timestamp TIMESTAMPTZ NOT NULL,
        consumed_at_ts BIGINT NOT NULL
      );
    EOT
  }
}

resource "helm_release" "postgresql" {
  name       = var.release_name
  namespace  = kubernetes_namespace.postgresql.metadata[0].name
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "postgresql"
  version    = var.chart_version
  create_namespace  = false

  set {
    name  = "image.registry"
    value = "docker.io"
  }

  set {
    name  = "image.repository"
    value = "bitnami/postgresql"
  }

  set {
    name  = "image.tag"
    value = "latest"
  }

  set {
    name  = "auth.postgresPassword"
    value = var.db_password
  }

  set {
    name  = "primary.persistence.enabled"
    value = "false"
  }

  set {
    name  = "global.security.allowInsecureImages"
    value = "true"
  }

  set {
    name  = "fullnameOverride"
    value = "${var.release_name}-${var.env}"
  }

  set {
    name  = "primary.initdb.scriptsConfigMap"
    value = kubernetes_config_map.init_sql.metadata[0].name
  }
}
