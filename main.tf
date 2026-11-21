provider "aws" {
  region = "ap-south-2"
}

data "aws_ami" "al2023" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }
}

resource "aws_security_group" "app_sg-1" {
  name        = "cloudshop-app-sg-1"
  description = "Allow SSH and HTTP ports"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "app_server" {
  ami                  = data.aws_ami.al2023.id
  instance_type        = "t3.micro"
  key_name             = "devops-kp" # Update to match your exact AWS key pair name
  security_groups      = [aws_security_group.app_sg-1.name]
  associate_public_ip_address = true

  tags = {
    Name = "CloudShop-App-Server"
  }
}

output "app_server_public_ip" {
  value = aws_instance.app_server.public_ip
}
