# Example values for terraform.tfvars

region = "eu-west-2"
environment = "prod"

# AWS profiles for different accounts
network_profile        = "aws-network"
security_profile       = "aws-security"
application_profile    = "aws-application"
shared_services_profile = "aws-shared-services"

# VPC CIDR blocks
network_vpc_cidr        = "10.0.0.0/16"
security_vpc_cidr       = "10.1.0.0/16"
application_vpc_cidr    = "10.2.0.0/16"
shared_services_vpc_cidr = "10.3.0.0/16"

# Application subnets
application_public_subnet_cidrs  = ["10.2.0.0/24", "10.2.2.0/24"]
application_private_subnet_cidrs = ["10.2.1.0/24", "10.2.3.0/24"]

# Domain configuration
domain_name = "example.com"
subdomain   = "tm"

# Repository URLs
app_repository       = "https://github.com/example/threat-composer-app.git"
terraform_repository = "https://github.com/example/threat-composer-terraform.git"

# Default tags
default_tags = {
  Project     = "threat-modeling-app"
  ManagedBy   = "terraform"
  Environment = "prod"
  Owner       = "security-team"
}