output "vpc_id" {
    value = aws_vpc.eks.id
    description = "VPC iD"
}

output "private_subnet_id" {
    description = "Private Subnet id"
    value = aws_subnet.private[*].id  
}

output "public_subnet_id" {
    description = "Public Subnet ID"
    value = aws_subnet.public[*].id  
}

output "cluster_endpoint" {
    description = "EKS cluster endpoint"
    value = aws_eks_cluster.eks-cluster.endpoint  
}

output "cluster_name" {
    description = "EKS Cluster Name"
    value = aws_eks_cluster.eks-cluster.name
}
