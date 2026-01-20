resource "aws_vpc" "qa_vpc" {
  cidr_block = var.vpc_cidr_block
  instance_tenancy = "default"
  enable_dns_hostnames = true
  tags = {
    name = var.vpc_name
  }
}

resource "aws_subnet" "qa_subnet" {
    vpc_id = aws_vpc.qa_vpc.id
    cidr_block = var.subnet_cidr_block
    availability_zone = var.availability_zone
    map_public_ip_on_launch = true
    tags = {
        name = var.subnet_name
    } 
}

resource "aws_internet_gateway" "qa_igw" {
    vpc_id = aws_vpc.qa_vpc.id
    tags = {
        name = var.igw_name
    }
}

resource "aws_route_table" "qa_rt" {
    vpc_id = aws_vpc.qa_vpc.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.qa_igw.id
    }
}

resource "aws_route_table_association" "qa_rta" {
    route_table_id = aws_route_table.qa_rt.id
    subnet_id = aws_subnet.qa_subnet.id
}

