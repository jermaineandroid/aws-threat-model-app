# Variables for the root module

variable "region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "eu-west-2"
}

variable "environment" {
  description = "Environment name (e.g., dev, test, prod)"
  type        = string
  default     = "prod"
}

# Network Account Variables
variable "network_profile" {
  description = "AWS profile for Network account"
  type        = string
}

variable "network_vpc_cidr" {
  description = "CIDR block for Network VPC"
  type        = string
  default     = "10.0.0.0/16"
}

# Security Account Variables
variable "security_profile" {
  description = "AWS profile for Security account"
  type        = string
}

variable "security_vpc_cidr" {
  description = "CIDR block for Security VPC"
  type        = string
  default     = "10.1.0.0/16"
}

# Application Account Variables
variable "application_profile" {
  description = "AWS profile for Application account"
  type        = string
}

variable "application_vpc_cidr" {
  description = "CIDR block for Application VPC"
  type        = string
  default     = "10.2.0.0/16"
}

variable "application_public_subnet_cidrs" {
  description = "CIDR blocks for Application public subnets"
  type        = list(string)
  default     = ["10.2.0.0/24", "10.2.2.0/24"]
}

variable "application_private_subnet_cidrs" {
  description = "CIDR blocks for Application private subnets"
  type        = list(string)
  default     = ["10.2.1.0/24", "10.2.3.0/24"]
}

# Shared Services Account Variables
variable "shared_services_profile" {
  description = "AWS profile for Shared Services account"
  type        = string
}

variable "shared_services_vpc_cidr" {
  description = "CIDR block for Shared Services VPC"
  type        = string
  default     = "10.3.0.0/16"
}

# Domain and Application Variables
variable "domain_name" {
  description = "Domain name for the application"
  type        = string
}

variable "subdomain" {
  description = "Subdomain for the application (tm.domain.com)"
  type        = string
  default     = "tm"
}

# Repository Variables
variable "app_repository" {
  description = "GitHub repository URL for application code"
  type        = string
}

variable "terraform_repository" {
  description = "GitHub repository URL for Terraform code"
  type        = string
}

variable "default_tags" {
  description = "Default tags for all resources"
  type        = map(string)
  default = {
    Project     = "threat-modeling-app"
    ManagedBy   = "terraform"
  }
}