# Provision the VPC network
module "networking" {
    source        = "./modules/networking"
    vpc_name      = var.vpc_name
    cluster_name  = var.cluster_name
}

module "security_groups" {
    source = "./modules/security-group"
    vpc_id = module.networking.vpc_id
}

# Provision cluster
module "eks_cluster" {
    source          = "./modules/containerisation"
    vpc_id          = module.networking.vpc_id
    private_subnets = module.networking.private_subnets
    cluster_name    = var.cluster_name
}


module "db" {
    source = "./modules/database" 
    subnet_ids             = module.networking.private_subnets
    vpc_security_group_ids = [module.security_groups.security-group-id]
}








