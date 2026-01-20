############################################
############################################
##SECURITY GROUP FOR UTILITY SERVER
############################################
############################################

resource "aws_security_group" "qa_sg" {
    name = var.util_sg_name
    description = "InBound and OutBound traffic rules for chinna_qa_sg"
    vpc_id = var.vpc_id
    ingress {
        description = "jenkins"
        from_port = 8080
        to_port = 8080
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        description = "sonarqube"
        from_port = 9000
        to_port = 9000
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        description = "ping"
        from_port = -1
        to_port =  -1
        protocol = "icmp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        description = "ssh"
        from_port = 22
        to_port =  22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        description = "httpd"
        from_port = 5044
        to_port =  5044
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        description = "OutBound traffic rules"
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        name = var.util_sg_name
    }
}
