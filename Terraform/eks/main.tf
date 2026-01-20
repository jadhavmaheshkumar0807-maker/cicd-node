provider "aws" {
    region = "us-east-1"
    profile = "default"  
}

resource "aws_vpc" "eks" {
    cidr_block = var.vpc_cidr_block
    instance_tenancy = "default"
    enable_dns_hostnames = true
    enable_dns_support = true
    tags = {
      Name = "${var.cluster_name}-vpc"
      "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    }
}

resource "aws_subnet" "private" {
    vpc_id = aws_vpc.eks.id
    count = length(var.private_subnet_cidr)
    cidr_block = var.private_subnet_cidr[count.index]
    availability_zone = var.availability_zone[count.index]
    tags = {
      Name = "${var.cluster_name}-private-${count.index + 1}"
      "kubernetes.io/cluster/${var.cluster_name}" = "shared"
      "kubernetes.io/role/internal-elb" = "1"
    }   
}

resource "aws_subnet" "public" {
    vpc_id = aws_vpc.eks.id
    count = length(var.public_subnet_cidr)
    cidr_block = var.public_subnet_cidr[count.index]
    availability_zone = var.availability_zone[count.index]
    tags = {
      Name = "${var.cluster_name}-public-${count.index + 1}"
      "kubernetes.io/cluster/${var.cluster_name}" = "shared"
      "kubernetes.io/role/elb" = "1"
    }   
}

resource "aws_internet_gateway" "eks" {
    vpc_id = aws_vpc.eks.id
    tags = {
      Name = "${var.cluster_name}-igw"
    }
}

resource "aws_eip" "nat" {
    count = length(var.public_subnet_cidr)
    domain = "vpc"
    tags = {
      Name = "${var.cluster_name}-nat-${count.index + 1}"
    }
}

resource "aws_nat_gateway" "eks" {
    count = length(var.public_subnet_cidr)
    allocation_id = aws_eip.nat[count.index].id
    subnet_id = aws_subnet.public[count.index].id
    tags = {
      Name = "${var.cluster_name}-nat-${count.index + 1}"
    }
    depends_on = [ aws_internet_gateway.eks ]
}

resource "aws_route_table" "public-rt" {
    vpc_id = aws_vpc.eks.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.eks.id
    }
    tags = {
      Name = "${var.cluster_name}-public-rt"
    }
}

resource "aws_route_table" "private-rt" {
    count = length(var.private_subnet_cidr)
    vpc_id = aws_vpc.eks.id
    route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = aws_nat_gateway.eks[count.index].id
    }
    tags = {
      Name = "${var.cluster_name}-private-rt-${count.index + 1}"
    }
}

resource "aws_route_table_association" "public-rta" {
    count = length(var.public_subnet_cidr)
    subnet_id = aws_subnet.public[count.index].id 
    route_table_id = aws_route_table.public-rt.id  
}

resource "aws_route_table_association" "private-rta" {
    count = length(var.private_subnet_cidr)
    subnet_id = aws_subnet.private[count.index].id 
    route_table_id = aws_route_table.private-rt[count.index].id  
}

resource "aws_iam_role" "eks-cluster" {
    name = "${var.cluster_name}-cluster-role"
    assume_role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [{
            Action = "sts:AssumeRole"
            Effect = "Allow"
            Principal = {
                Service = "eks.amazonaws.com"
            }
        }]
    })
}

resource "aws_iam_role_policy_attachment" "cluster_policy" {
    policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
    role = aws_iam_role.eks-cluster.name
}

resource "aws_eks_cluster" "eks-cluster" {
    name = var.cluster_name
    role_arn = aws_iam_role.eks-cluster.arn
    vpc_config {
      subnet_ids = concat(
        aws_subnet.private[*].id,
        aws_subnet.public[*].id
      )
      endpoint_private_access = true
      endpoint_public_access = true
    }
    depends_on = [ 
        aws_iam_role_policy_attachment.cluster_policy
     ]
}

resource "aws_eks_addon" "vpc_cni" {
    cluster_name = aws_eks_cluster.eks-cluster.name
    addon_name = "vpc-cni"
}

resource "aws_eks_addon" "coredns" {
    cluster_name = aws_eks_cluster.eks-cluster.name
    addon_name = "coredns"
}

resource "aws_eks_addon" "kube_proxy" {
    cluster_name = aws_eks_cluster.eks-cluster.name
    addon_name = "kube-proxy"
}

resource "aws_eks_addon" "ebs_csi" {
    cluster_name = aws_eks_cluster.eks-cluster.name
    addon_name = "aws-ebs-csi-driver"
}

resource "aws_iam_role" "eks-node" {
    name = "${var.cluster_name}-node-role"
    assume_role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [{
            Action = "sts:AssumeRole"
            Effect = "Allow"
            Principal = {
                Service = "ec2.amazonaws.com"
            }
        }]
    })
}

resource "aws_iam_role_policy_attachment" "node_policy" {
    for_each = toset([
        "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",
        "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy",
        "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly",
        "arn:aws:iam::aws:policy/AmazonEBSCSIDriverPolicy"
    ])
    policy_arn = each.value
    role = aws_iam_role.eks-node.name
}

resource "aws_eks_node_group" "eks-cluster" {
    for_each = var.node_groups
    cluster_name = aws_eks_cluster.eks-cluster.name
    node_group_name = each.key
    node_role_arn = aws_iam_role.eks-node.arn
    subnet_ids = aws_subnet.private[*].id
    instance_types = each.value.instance_types
    scaling_config {
      desired_size = each.value.scaling_config.desired_size
      max_size = each.value.scaling_config.max_size
      min_size = each.value.scaling_config.min_size
    }
    depends_on = [ 
        aws_iam_role_policy_attachment.node_policy
     ]
}