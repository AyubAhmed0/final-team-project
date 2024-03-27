output "vpc_id" {
  description = "The ID of the VPC created"
  value       = module.vpc.vpc_id
}

output "private_subnets" {
  description   = "The IDs of the private subnets created"
  value         = module.vpc.private_subnets
}

output "public_subnets" {
  value = module.vpc.public_subnets
}

output "vpc_security_group_id" {
  description = "The ID of the security group created"
  value       = module.vpc.default_security_group_id
}