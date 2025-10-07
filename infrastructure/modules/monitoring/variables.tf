variable "env" { type = string }
variable "namespace" { type = string }
variable "release_name" { type = string }
variable "chart_version" { type = string }
variable "prometheus_settings" { type = map(string) }
