output "aws_vpc_id" {
    description = "VPC ID"
    value = aws_vpc.qa_vpc.id
}

output "aws_subnet_id" {
    description = "subnet Id"
    value = aws_subnet.qa_subnet.id  
}