terraform {
  backend "remote" {
    organization = var.organization

    workspaces {
      name = var.app_name
    }
  }
}

provider "aws" {
  region = var.region
  default_tags {
    tags = local.common_tags
  }
}

data "aws_ssm_parameter" "root_domain_hosted_zone_id" {
  name = "root-domain-hosted-zone-id"
}

data "aws_ssm_parameter" "root_domain_name" {
  name = "root-domain-name"
}

locals {
  description = "Serverless lambda that returns your public IP"
  domain_name = "${var.app_name}.${data.aws_ssm_parameter.root_domain_name.value}"
  common_tags = {
    Project     = var.app_name,
    Environment = var.env
  }
}

module "certificate" {
  source = "./certificate"

  region         = "us-east-1"
  domain_name    = local.domain_name
  hosted_zone_id = data.aws_ssm_parameter.root_domain_hosted_zone_id.value
  common_tags    = local.common_tags
}

module "api_gateway" {
  source = "./api_gateway"

  env             = var.env
  app_name        = var.app_name
  description     = local.description
  domain_name     = local.domain_name
  certificate_arn = module.certificate.arn
  hosted_zone_id  = data.aws_ssm_parameter.root_domain_hosted_zone_id.value
}
