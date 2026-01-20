variable "public_key" {
    description = "Public key to connect to server"
    default = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCch749Fa4nU3GhxL4/toJ/+0p4baBuSF2BSGrKmKqyYSyoXoqAllUshCmwCxgfVSb//v/mmdX/46ONdMLQspOXQtpcAEYLdEnbWPCwS9+6Gu9oxIacH74vgwJLq/2ckcDpB4enoN1lNKFncdgAMekX5LivW8TnTm/GFNZ5URPKn3b4tfdbmBw3M96PNsKak6r7ujcI0cuQ5/eJZk8LwhZ4tEWSRb1awRi2IFnB4MKEtTSc0Z3sylOML92T/1yeb0QtEY4yLZ51ok/SY33zVC1w5ILG5yZGf2JRz0qLrOEFAFAAM0yl07+jxUScPEVSJiQAuBoZP9a/SKMxHlID0tn/i21CinimB7bdR6a9gCuFkmxTygN+yV5gESVd615qY468rX18+katOF6eTAnnMXV9RZ0Gy+IRX7rjUmtI9P3otn62yRkkH/ZQjU+UgMnYpVq763vO6ZrCob85j93eRkvydZ9AG6BS2f9N8DGMQMYRr4CAdHeh3dZVZiNBUxnf1p0= AzureAD+AravindJadhav@Mahesh-Jadhav"  
}

variable "key_name" {
    description = "Key-Pair name for ec2 connection"
    default = "mahi-key"
    type = string  
}

variable "ami" {
    description = "AMI for EC2 instance is AMAZON LINUX"
    default = "ami-07ff62358b87c7116"
    type = string
}

variable "instance_type" {
    description = "Instance type for ec2"
    default = "c7i-flex.large"
    type = string
}


variable "util_name" {
    description = "Name of the ec2"
    default = "util_srv"  
}

variable "subnet_id" {
    description = "subnet id"
    type = string 
}

variable "vpc_security_group_ids" {
    description = "Security Group id"
    type = list(string)
}
