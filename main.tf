
resource "aws_vpc" "my-vpc" {
  cidr_block = var.vpc_config.cidr_block
  
  tags={
    name = var.vpc_config.name
  }
}


resource "aws_subnet" "my-subnet" {
  vpc_id     = aws_vpc.my-vpc.id
  for_each = var.subnet_config #key={cidr, az}, each.key each.value key will be provided by user in module

  cidr_block = each.value.cidr_block
  availability_zone = each.value.az

  tags = {
    name = each.key
  }
}

locals {
  public_subnet = {
    #key = {} if public is true in subnet_config 
    for key, config in var.subnet_config : key => config if config.public
  }
}

locals {
  private_subnet = {
    for key, config in var.subnet_config : key => config if !config.public
  }
}

#Internet gateway, if there is atleast one public subnet
resource "aws_internet_gateway" "my-igw" {
  vpc_id = aws_vpc.my-vpc.id
#this is turnary operator it will create only one igw if public subnet is more than one if 0 it will not create 
  count = length(local.public_subnet) > 0 ? 1 : 0
}

resource "aws_route_table" "my-rt" {
  count = length(local.public_subnet) > 0 ? 1 : 0
  vpc_id = aws_vpc.my-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my-igw[0].id
  }
}

resource "aws_route_table_association" "rt-ass" {
  for_each = local.public_subnet

  subnet_id          = aws_subnet.my-subnet[each.key].id
  route_table_id     = aws_route_table.my-rt[0].id
}