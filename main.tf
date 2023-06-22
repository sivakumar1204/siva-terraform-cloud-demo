provider "aws" {
  region = "ap-south-1"
}

data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
}

output "amazon-ami" {
  value = data.aws_ami.amazon_linux_2.id
}

resource "aws_instance" "test-server" {
  ami           = data.aws_ami.amazon_linux_2.id
  instance_type = "t2.micro"
  tags = {
    Name = "siva-test-server-terraform-cloud"
  }
  security_groups = ["${aws_security_group.terrafrom-cloud-sg.name}"]
}

resource "aws_security_group" "terrafrom-cloud-sg" {
  name        = "terrafrom-cloud-sg-siva"
  description = "SSH access"
  
  dynamic "ingress" {
    for_each = var.sg_ports
    iterator = port
    content {
      from_port   = port.value
      to_port     = port.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  } 

}
