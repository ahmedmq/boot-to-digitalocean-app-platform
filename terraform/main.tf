locals {
  environment = terraform.workspace
}

terraform {
  required_providers {
    digitalocean = {
      source = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}

provider "digitalocean" {
  token = var.do_token
  spaces_access_id  = var.do_spaces_access_key
  spaces_secret_key = var.do_spaces_secret
}

terraform {
  required_version = ">= 1.1.6"
  backend "s3" {
    skip_requesting_account_id = true
    skip_credentials_validation = true
    skip_get_ec2_platforms = true
    skip_metadata_api_check = true
    endpoint = "https://sgp1.digitaloceanspaces.com"
    region = "ap-southeast-1"
    bucket = "demo-terraform-state-config"
    key = "production/terraform.tfstate"
  }
}