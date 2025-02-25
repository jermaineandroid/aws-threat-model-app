# Main Terraform configuration for AWS Security Architecture

# Network Account Resources
provider "aws" {
  alias   = "network"
  region  = var.region
  profile = var.network_profile
  
  default_tags {
    tags = var.default_tags
  }
}

# Security Account Resources
provider "aws" {
  alias   = "security"
  region  = var.region
  profile = var.security_profile
  
  default_tags {
    tags = var.default_tags
  }
}

# Application Account Resources
provider "aws" {
  alias   = "application"
  region  = var.region
  profile = var.application_profile
  
  default_tags {
    tags = var.default_tags
  }
}

# Shared Service Account Resources
provider "aws" {
  alias   = "shared_services"
  region  = var.region
  profile = var.shared_services_profile
  
  default_tags {
    tags = var.default_tags
  }
}

# Network Account Module
module "network" {
  source = "./modules/network"
  
  providers = {
    aws = aws.network
  }
  
  vpc_cidr           = var.network_vpc_cidr
  domain_name        = var.domain_name
  transit_gateway_id = module.transit_gateway.transit_gateway_id
  environment        = var.environment
}

# Security Account Module
module "security" {
  source = "./modules/security"
  
  providers = {
    aws = aws.security
  }
  
  vpc_cidr           = var.security_vpc_cidr
  transit_gateway_id = module.transit_gateway.transit_gateway_id
  environment        = var.environment
}

# Application Account Module
module "application" {
  source = "./modules/application"
  
  providers = {
    aws = aws.application
  }
  
  vpc_cidr             = var.application_vpc_cidr
  public_subnet_cidrs  = var.application_public_subnet_cidrs
  private_subnet_cidrs = var.application_private_subnet_cidrs
  transit_gateway_id   = module.transit_gateway.transit_gateway_id
  
  domain_name          = var.domain_name
  subdomain            = var.subdomain
  acm_certificate_arn  = module.network.acm_certificate_arn
  container_image      = "${module.shared_services.ecr_repository_url}:latest"
  environment          = var.environment
  waf_arn              = module.network.waf_arn
}

# Shared Services Account Module
module "shared_services" {
  source = "./modules/shared-services"
  
  providers = {
    aws = aws.shared_services
  }
  
  vpc_cidr           = var.shared_services_vpc_cidr
  transit_gateway_id = module.transit_gateway.transit_gateway_id
  environment        = var.environment
  app_repository     = var.app_repository
  terraform_repository = var.terraform_repository
}

# Transit Gateway Module (deployed in Network account)
module "transit_gateway" {
  source = "./modules/transit-gateway"
  
  providers = {
    aws = aws.network
  }
  
  transit_gateway_name = "${var.environment}-transit-gateway"
}