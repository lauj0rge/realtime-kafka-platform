variable "postgres_password" {
  description = "Postgres password"
  type        = string
  default     = "postgres"
}

module "postgres" {
  source            = "./postgres"
  env               = var.env
  namespace         = var.postgres_namespace
  release_name      = var.postgres_release_name
  chart_version     = var.postgres_chart_version
  # pass it only if module supports it
  # postgres_password = var.postgres_password
}

module "stream_consumer" {
  source                  = "./apps/consumer_stream"
  env                     = var.env
  namespace               = var.app_namespace
  kafka_bootstrap_servers = module.kafka_cluster.bootstrap_server
  kafka_topic             = "events"
  image                   = var.stream_consumer_image
  db_host                 = module.postgres.db_host
  db_port                 = "5432"
  db_name                 = module.postgres.db_name
  db_user                 = module.postgres.db_user
  # only include this if consumer_stream/variables.tf defines db_password
  # db_password             = var.postgres_password
  depends_on              = [module.postgres, module.producer]
}

module "batch_consumer" {
  source                  = "./apps/consumer_batch"
  namespace               = var.app_namespace
  kafka_bootstrap_servers = module.kafka_cluster.bootstrap_server
  kafka_topic             = "events"
  env                     = var.env
  image                   = var.batch_consumer_image
  db_host                 = module.postgres.db_host
  db_port                 = "5432"
  db_name                 = module.postgres.db_name
  db_user                 = module.postgres.db_user
  # same — only if defined
  # db_password             = var.postgres_password
  depends_on              = [module.postgres, module.producer]
}

