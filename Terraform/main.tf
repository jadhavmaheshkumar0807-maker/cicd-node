provider "aws" {
    region = "us-east-1"
    profile = "default"
}

# VPC Network Creation
module "vpc" {
    source = "./modules/VPC"
}
output "vpc_id_from_module" {
    value = module.vpc.aws_vpc_id
}
output "subnet_id" {
    value = module.vpc.aws_subnet_id
}

# Security Group Creation
module "security_group" {
    source = "./modules/security_group"
    vpc_id = module.vpc.aws_vpc_id
}
output "security_group_id" {
    value = module.security_group.aws_security_group_id
}

# Server setup
module "ec2" {
    source = "./modules/ec2"
    subnet_id = module.vpc.aws_subnet_id
    vpc_security_group_ids = [ module.security_group.aws_security_group_id ]
}
output "ec2_public_ip" {
  value = module.ec2.util_server_public_ip
}
output "ec2_dns" {
    value = module.ec2.util_server_public_dns
}
output "ec2_private_ip" {
    value = module.ec2.util_server_private_ip
}