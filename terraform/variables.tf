variable "do_token" {
  description = "Your digital ocean API token"
}

variable "do_region" {
  description = "Digital Ocean Region where the resources should exist"
  default = "blr1"
}

variable "docker-tag" {
  default = "latest"
}
variable "docker-repo" {
  default = "demo"
}

variable "do_spaces_access_key" {
  description = "Digital Ocean Spaces Access ID"
  default = null
}

variable "do_spaces_secret" {
  description = "Digital Ocean Spaces Secret Key"
  default = null
}
