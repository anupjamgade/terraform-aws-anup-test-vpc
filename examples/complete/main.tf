provider "aws" {
  region = "us-east-1"
}
module "vpc" {
  source = "./module/vpc"

  vpc_config = {
    cidr_block = "10.0.0.0/16"
    name       = "test-vpc"
  }

  subnet_config = {
    #key{cidr.az}
    public_subnet = {
      cidr_block = "10.0.0.0/24"
      az         = "us-east-1a"
      public     = true
    }
    private_subnet = {
      cidr_block = "10.0.1.0/24"
      az         = "us-east-1b"
    }
  }
}