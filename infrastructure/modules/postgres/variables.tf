variable "env" { type = string }
variable "namespace" { type = string }
variable "release_name" { type = string }
variable "chart_version" { type = string }
variable "postgres_password" {
  type      = string
  sensitive = true
  default = "postgres"
}
