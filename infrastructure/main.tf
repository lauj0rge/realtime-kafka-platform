module "postgres" {
  source            = "./modules/postgres"
  env               = var.env
  namespace         = var.postgres_namespace
  release_name      = var.postgres_release_name
  chart_version     = var.postgres_chart_version
  postgres_password = "postgres"
}

module "kafka_cluster" {
  source                       = "./modules/kafka_cluster"
  env                          = var.env
  namespace                    = var.kafka_namespace
  release_name                 = var.kafka_release_name
  kafka_chart_version          = var.kafka_chart_version
  kafka_settings               = var.kafka_settings
  kafka_exporter_enabled       = var.kafka_exporter_enabled
  kafka_exporter_settings      = var.kafka_exporter_settings
  kafka_exporter_chart_version = var.kafka_exporter_chart_version
  kafka_exporter_release_name  = var.kafka_exporter_release_name
}

module "prometheus" {
  source              = "./modules/monitoring"
  env                 = var.env
  namespace           = var.prom_namespace
  release_name        = var.prom_release_name
  chart_version       = var.prom_chart_version
  prometheus_settings = var.prom_settings
  depends_on = [
    module.kafka_cluster
  ]
}

module "producer" {
  source                  = "./modules/apps/producer"
  env                     = var.env
  namespace               = var.app_namespace
  kafka_bootstrap_servers = module.kafka_cluster.bootstrap_server
  image                   = "producer:latest"
  kafka_topic             = "events"
  replicas                = var.producer_replicas
  depends_on              = [module.kafka_cluster]
}

module "stream_consumer" {
  source                  = "./modules/apps/consumer_stream"
  env                     = var.env
  namespace               = var.app_namespace
  kafka_bootstrap_servers = module.kafka_cluster.bootstrap_server
  kafka_topic             = "events"
  image                   = var.stream_consumer_image
  db_host                 = module.postgres.db_host
  db_port                 = "5432"
  db_name                 = module.postgres.db_name
  db_user                 = module.postgres.db_user
  db_password             = "postgres"
  depends_on              = [module.postgres, module.producer]
}

module "batch_consumer" {
  source                  = "./modules/apps/consumer_batch"
  namespace               = var.app_namespace
  kafka_bootstrap_servers = module.kafka_cluster.bootstrap_server
  kafka_topic             = "events"
  env                     = var.env
  image                   = var.batch_consumer_image
  db_host                 = module.postgres.db_host
  db_port                 = "5432"
  db_name                 = module.postgres.db_name
  db_user                 = module.postgres.db_user
  db_password             = "postgres"
  depends_on              = [module.postgres, module.producer]
}
