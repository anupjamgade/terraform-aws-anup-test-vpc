output "vpc_id" {
  value = aws_vpc.my-vpc.id
}

locals {
  #to format the subnet IDS which may be multiples in format of subnet_name = {id=, az=}
  public_subnet_output = {
    for key, config in local.public_subnet : key => {
        subnet_id = aws_subnet.my-subnet[key].id
        az = aws_subnet.my-subnet[key].availability_zone
    }
  }

  private_subnet_output = {
    for key, config in local.private_subnet : key => {
        subnet_id = aws_subnet.my-subnet[key].id
        az = aws_subnet.my-subnet[key].availability_zone
    }
  }
}

output "public_subnet" {
  value = local.public_subnet_output
}

output "private_subnet" {
  value = local.private_subnet_output
}