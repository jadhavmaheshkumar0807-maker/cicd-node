!#/bin/bash 
sudo yum update -y
sudo yum install jenkins maven git ansible wget docker -y
sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
sudo yum upgrade
sudo yum install java-21-amazon-corretto -y
sudo systemctl enable jenkins && sudo systemctl start jenkins
sudo systemctl enable docker && sudo systemctl start docker
sudo usermod -aG docker ec2-user
sudo usermod -aG docker jenkins
sudo chmod 666 /var/run/docker.sock
sudo docker run -d --name sonar -p 9000:9000 sonarqube
rpm -ivh https://github.com/aquasecurity/trivy/releases/download/v0.68.2/trivy_0.68.2_Linux-64bit.rpm