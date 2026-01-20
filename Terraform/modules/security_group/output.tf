output "aws_security_group_id" {
    description = "ID of the security group"
    value = aws_security_group.qa_sg.id  
}