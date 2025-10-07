variable "env" { type = string }
variable "namespace" { type = string }
variable "release_name" { type = string }
variable "chart_version" { type = string }
variable "db_password" {
  description = "Database password for stream consumer"
  type        = string

}
