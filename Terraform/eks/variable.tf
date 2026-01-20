variable "vpc_cidr_block" {
    description = "CIDR block for VPC"
    default = "11.91.0.0/16"
    type = string
}

variable "cluster_name" {
    description = "Name of the VPC for EKS"
    default = "ammu"  
    type = string
}

variable "private_subnet_cidr" {
    description = "CIDR blocks for private subnet"
    default = ["11.91.6.0/24"]
    type = list(string)
}

variable "public_subnet_cidr" {
    description = "CIDR blocks for private subnet"
    default = ["11.91.7.0/24"]
    type = list(string)
}

variable "availability_zone" {
    description = "availability zone for the subnet"
    type = list(string)  
    validation {
      condition = length(var.availability_zone) >= length(var.public_subnet_cidr)
      error_message = "availability_zone list must match subnet count"
    }
    default = [ "us-east-1a" ]
}

variable "node_groups" {
    description = "EKS nodegroup configuration"
    type = map(object({
      instance_types = list(string)
      scaling_config = object({
        desired_size = number
        max_size = number
        min_size = number
      })
    }))

    default = {
      main = {
        instance_types = [ "t3.small" ]
        scaling_config = {
            desired_size = 5
            max_size = 8
            min_size = 3
        }
      }
    }
}
