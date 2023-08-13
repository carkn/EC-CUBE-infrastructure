############################################################
# VPC
############################################################
resource "aws_vpc" "vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
}

############################################################
# Public Subnet
############################################################
resource "aws_subnet" "subnet" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "ap-northeast-1a"
  map_public_ip_on_launch = true
}

############################################################
# Internet gateway
############################################################
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
}

############################################################
# Route table
############################################################
resource "aws_route_table" "rtb" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

############################################################
# Attach route table to subnet
############################################################
resource "aws_route_table_association" "rt_assoc" {
  subnet_id      = aws_subnet.subnet.id
  route_table_id = aws_route_table.rtb.id
}

############################################################
# Security group
############################################################
resource "aws_security_group" "sg" {
  name   = "sg"
  vpc_id = aws_vpc.vpc.id
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 22
    to_port     = 22 
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