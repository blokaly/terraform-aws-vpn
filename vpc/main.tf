terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }

  backend "s3" {
    bucket  = "<AWS S3 Bucket>"
    key     = "aws-vpn/<AWS Region>/vpc/terraform.tfstate"
    region  = "<AWS Region>"
    encrypt = true
    profile = "<AWS Profile>"
  }
}

provider "aws" {
  region  = "<AWS Region>"
  profile = "<AWS Profile>"
}

resource "aws_vpc" "vpn_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "EC2 VPN VPC"
  }
}

resource "aws_subnet" "vpn_public_subnet" {
  vpc_id            = aws_vpc.vpn_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "ap-southeast-1a"

  tags = {
    Name = "VPN Public Subnet"
  }
}

resource "aws_subnet" "vpn_private_subnet" {
  vpc_id            = aws_vpc.vpn_vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "ap-southeast-1a"

  tags = {
    Name = "VPN Private Subnet"
  }
}

resource "aws_internet_gateway" "vpn_ig" {
  vpc_id = aws_vpc.vpn_vpc.id

  tags = {
    Name = "VPN Internet Gateway"
  }
}

resource "aws_route_table" "vpn_rt" {
  vpc_id = aws_vpc.vpn_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.vpn_ig.id
  }

  route {
    ipv6_cidr_block = "::/0"
    gateway_id      = aws_internet_gateway.vpn_ig.id
  }

  tags = {
    Name = "VPN Route Table"
  }
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.vpn_public_subnet.id
  route_table_id = aws_route_table.vpn_rt.id
}

resource "aws_route_table_association" "private" {
  subnet_id      = aws_subnet.vpn_private_subnet.id
  route_table_id = aws_route_table.vpn_rt.id
}

resource "aws_route" "vpn_internet_route" {
  destination_cidr_block = "0.0.0.0/0"
  route_table_id = aws_route_table.vpn_rt.id
  gateway_id = aws_internet_gateway.vpn_ig.id
}

resource "aws_security_group" "vpn_sg" {
  name   = "HTTPS and SSH"
  vpc_id = aws_vpc.vpn_vpc.id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 1194
    to_port     = 1194
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_eip" "vpn-eip" {
  depends_on = [aws_internet_gateway.vpn_ig]
}

# Outputs

output "subnet" {
  value = aws_subnet.vpn_public_subnet.id
  description = "Subnet ID"
}

output "sg" {
  value = aws_security_group.vpn_sg.id
  description = "Security Group ID"
}

output "eip" {
  value = aws_eip.vpn-eip.id
  description = "EIP ID"
}
