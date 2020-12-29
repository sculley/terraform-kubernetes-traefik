variable "namespace" {
  description = "Namespace to install traefik chart into"
  type        = string
  default     = "traefik"
}

variable "replica_count" {
  description = "Number of replica pods to create"
  type        = number
  default     = 1
}

variable "default_values" {
  description = "Specifies whether to use the traefik default values.yaml, or if set to anything else then to use your own custom values"
  type = string
  default = ""
}

variable "values_file" {
  description = "The name of the traefik helmchart values file to use"
  type = string
  default = "values.yaml"
}