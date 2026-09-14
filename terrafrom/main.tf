variable "key_name" {
  description = "The name of the key pair to use for the instances"
  type        = string
}

provider "aws" {
  region = "ap-southeast-1"
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "main" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.1.0/24"
}

resource "aws_security_group" "main" {
  name        = "main_sg"
  description = "Main security group"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    }
  ingress {
    from_port   = 81
    to_port     = 81
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/24"]
  }
  ingress {
    from_port   = 8081
    to_port     = 8081
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/24"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "Apache_and_Docker" {
  ami           = "ami-01a00762f46d584a1" # Replace with a valid AMI ID for your region
  instance_type = "t3.micro"
    key_name = var.key_name
  subnet_id     = aws_subnet.main.id
  security_groups = [aws_security_group.main.name]

  tags = {
    description = "Apache on port 81 and Docker Application on port 8081"
    Name = "Apache_and_Docker_Application_Live"
  }
}

resource "aws_instance" "Jenkins_Worker_Node" {
  ami           = "ami-01a00762f46d584a1" # Replace with a valid AMI ID for your region
  instance_type = "t3.micro"
  key_name = var.key_name
  subnet_id     = aws_subnet.main.id
  security_groups = [aws_security_group.main.name]

  tags = {
    Name = "Jenkins_Worker_Node"
  }
}

output "public_ip_apache_docker" {
  value = aws_instance.Apache_and_Docker.public_ip
}
output "public_ip_jenkins_worker" {
  value = aws_instance.Jenkins_Worker_Node.public_ip
}

