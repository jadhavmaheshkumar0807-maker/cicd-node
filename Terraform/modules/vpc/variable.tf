
variable "vpc_cidr_block" {
    description = "CIDR block for VPC"
    default = "10.81.0.0/16"
     
}

variable "vpc_name" {
    description = "Name of the VPC"
    default = "chinna_qa_vpc"
  
}

variable "subnet_cidr_block" {
    description = "CIDR block range for subnet"
    default = "10.81.5.0/24"
}

variable "availability_zone" {
    description = "availability zone to launch subnet"
    default = "us-east-1a"
}

variable "subnet_name" {
    description = "NAme of the subnet"
    default = "chinna_qa_subnet"
}

variable "igw_name" {
    description = "name of the Internet Gateway"
    default = "chinna_igw"  
}

    