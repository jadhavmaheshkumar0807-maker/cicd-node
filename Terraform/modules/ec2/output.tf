output "util_server_public_ip" {
    value = aws_instance.util_server.public_ip  
}

output "util_server_public_dns" {
    value = aws_instance.util_server.public_dns
}

output "util_server_private_ip" {
    value = aws_instance.util_server.private_ip
}
