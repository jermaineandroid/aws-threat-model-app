# Outputs from the root module

# Network outputs
output "network_vpc_id" {
  description = "ID of the Network VPC"
  value       = module.network.vpc_id
}

output "route53_zone_id" {
  description = "Route53 Zone ID"
  value       = module.network.route53_zone_id
}

output "waf_web_acl_id" {
  description = "WAF Web ACL ID"
  value       = module.network.waf_web_acl_id
}

# Transit Gateway outputs
output "transit_gateway_id" {
  description = "ID of the Transit Gateway"
  value       = module.transit_gateway.transit_gateway_id
}

# Security outputs
output "security_vpc_id" {
  description = "ID of the Security VPC"
  value       = module.security.vpc_id
}

output "security_hub_arn" {
  description = "ARN of the Security Hub"
  value       = module.security.security_hub_arn
}

output "guardduty_detector_id" {
  description = "ID of the GuardDuty detector"
  value       = module.security.guardduty_detector_id
}

# Application outputs
output "application_vpc_id" {
  description = "ID of the Application VPC"
  value       = module.application.vpc_id
}

output "alb_dns_name" {
  description = "DNS Name of the Application Load Balancer"
  value       = module.application.alb_dns_name
}

output "ecs_cluster_name" {
  description = "Name of the ECS Cluster"
  value       = module.application.ecs_cluster_name
}

output "ecs_service_name" {
  description = "Name of the ECS Service"
  value       = module.application.ecs_service_name
}

output "application_url" {
  description = "URL of the deployed application"
  value       = "https://${var.subdomain}.${var.domain_name}"
}

# Shared Services outputs
output "shared_services_vpc_id" {
  description = "ID of the Shared Services VPC"
  value       = module.shared_services.vpc_id
}

output "ecr_repository_url" {
  description = "URL of the ECR Repository"
  value       = module.shared_services.ecr_repository_url
}

output "container_pipeline_name" {
  description = "Name of the container CI/CD pipeline"
  value       = module.shared_services.container_pipeline_name
}

output "terraform_pipeline_name" {
  description = "Name of the Terraform CI/CD pipeline"
  value       = module.shared_services.terraform_pipeline_name
}