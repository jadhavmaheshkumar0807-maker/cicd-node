resource "aws_key_pair" "chinna_key" {
  key_name = var.key_name
  public_key = var.public_key
}

resource "aws_instance" "util_server" {
    ami = var.ami
    instance_type = var.instance_type
    key_name = var.key_name
    subnet_id = var.subnet_id
    vpc_security_group_ids = var.vpc_security_group_ids

    root_block_device {
      volume_size = 27
      volume_type = "gp3"
      delete_on_termination = true
    }    

    connection {
      type = "ssh"
      user = "ec2-user"
      private_key = file("~/.ssh/id_rsa")
      host = self.public_ip
    }

    provisioner "remote-exec" {
      inline = [ 
        "set -e",
        "sudo yum update -y",
        "sudo yum install maven git ansible wget docker -y",
        "sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo",
        "sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key",
        "sudo yum upgrade -y",
        "sudo yum install java-21-amazon-corretto -y",
        "sudo yum install jenkins -y",
        "sudo systemctl enable jenkins && sudo systemctl start jenkins",
        "sudo systemctl enable docker && sudo systemctl start docker",
        "sudo usermod -aG docker ec2-user",
        "sudo usermod -aG docker jenkins",
        "sudo chmod 666 /var/run/docker.sock",
        "sudo docker run -d --name sonar -p 9000:9000 sonarqube",
        "sudo rpm -ivh https://github.com/aquasecurity/trivy/releases/download/v0.68.2/trivy_0.68.2_Linux-64bit.rpm"
       ]
    }

    tags = {
      Name = var.util_name
    }
  
}
