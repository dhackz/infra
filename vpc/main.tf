terraform {
  backend "s3" {
    bucket = "vassast-tfstate"
    key    = "zuul/vpc"
    region = "eu-north-1"
  }
}

provider "aws" {
  region = "eu-north-1"
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "zuul-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["eu-north-1a", "eu-north-1b", "eu-north-1c"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  tags = {
    Terraform = "true"
    Environment = "prod"
  }
}

resource "aws_security_group" "nodepool_instance" {
  name        = "nodepool-instance"
  description = "Allow ssh inbound anything outbound"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "ssh from anything"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] 
  }

  ingress {
    description = "zuul console streamer"
    from_port   = 19885
    to_port     = 19885
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] 
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "nodepool-instance"
  }
}

