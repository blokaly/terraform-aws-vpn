terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }

  backend "s3" {
    bucket  = "<AWS S3 Bucket>"
    key     = "aws-vpn/<AWS Region>/ec2/terraform.tfstate"
    region  = "<AWS Region>"
    encrypt = true
    profile = "<AWS Profile>"
  }
}

provider "aws" {
  region  = "<AWS Region>"
  profile = "<AWS Profile>"
}

locals {
  key_name              = "<AWS SSH Key>"
  ami                   = "<AWS AMI ID>"
  instance_type         = "<AWS EC2 Type>"
  eip_allocation_id     = "<VPC Elastic IP>"
  vpc_security_group_id = "<VPC Security Group ID>"
  subnet_id             = "<VPC Public Subnet ID>"
}

resource "aws_instance" "vpn_instance" {
  ami           = local.ami
  instance_type = local.instance_type
  key_name      = local.key_name

  subnet_id                   = local.subnet_id
  vpc_security_group_ids      = [local.vpc_security_group_id]
  associate_public_ip_address = true

  user_data = file("../scripts/ec2-init.sh")

  tags = {
    "Name" : "VPN EC2"
  }
}

resource "aws_eip_association" "vpn-eip-association" {
  instance_id   = aws_instance.vpn_instance.id
  allocation_id = local.eip_allocation_id
}

output "instances" {
  value       = aws_eip_association.vpn-eip-association.public_ip
  description = "EC2 public IP"
}
