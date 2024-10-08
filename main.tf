# 1 Create VPC
resource "aws_vpc" "tco_vpc" {
  cidr_block       = var.vpc_cidr_block
  instance_tenancy = "default"

  tags = {
    name = "devops-group-10"
  }
}

# 2 Create a Public Subnet
resource "aws_subnet" "group10_public_subnet" {
  vpc_id     = aws_vpc.tco_vpc.id
  cidr_block =  var.subnet_cidr_block
  availability_zone = "${var.aws_region}a"

  tags = {
    name = "devops-group-10"
  }
}

# 3 Create an Internet Gateway for the VPC
resource "aws_internet_gateway" "tco_igw" {
  vpc_id = aws_vpc.tco_vpc.id

  tags = {
    name = "devops-group-10"
  }
}

# 4 Create Route Table
resource "aws_route_table" "tco_rt" {
  vpc_id = aws_vpc.tco_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.tco_igw.id
  }

  tags = {
    name = "devops-group-10"
  }
}

# 5 Associate subnet with route table
resource "aws_route_table_association" "tco-rt-association" {
  subnet_id      = aws_subnet.group10_public_subnet.id
  route_table_id = aws_route_table.tco_rt.id

  
}

# 6 Create security group
resource "aws_security_group" "tco_vpc_sg" {
  vpc_id      = aws_vpc.tco_vpc.id


ingress {

  from_port       = 22
  to_port         = 22
  protocol        = "tcp"
  cidr_blocks     = ["0.0.0.0/0"]

}

ingress {

  from_port       = 80
  to_port         = 80
  protocol        = "tcp"
  cidr_blocks     = ["0.0.0.0/0"]
  
}

egress {
from_port         = 0
  to_port         = 0
  protocol        = "-1"
  cidr_blocks     = ["0.0.0.0/0"]
  
}
}

# 7 Launch an EC2 Instance
resource "aws_instance" "group10_nginx_server" {
  ami           = var.ami_id
  instance_type = var.instance_type
  subnet_id = aws_subnet.group10_public_subnet.id
  security_groups = [aws_security_group.tco_vpc_sg.id]
  associate_public_ip_address = true

  # User data script to install nginx
  user_data = <<-EOF
  #!/bin/bash
  sudo apt update -y
  sudo apt install nginx -y
  sudo systemctl start nginx
  sudo systemctl enable nginx
  EOF

  tags = {
    name = "devops-group-10"
  }
}


