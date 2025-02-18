variable "vpc_config" {
    description = "To get the CIDR and name of vpc from user"
  type = object({
    cidr_block = string
    name = string
  })
  validation {
    condition = can(cidrnetmask(var.vpc_config.cidr_block))

    #cidrnetmask is a function which is used to validate the cidr block, cidrnetmask converts an ipv4 address prefix given in CIDR notation into a subnet mask address.
    
    error_message = "Enter valid format - ${var.vpc_config.cidr_block}"
  }
}

variable "subnet_config" {
  #sub1={cidr=... az=...} sub2={cidr=... az=...}
  description = "To get the CIDR and az for subnets"
  type = map(object({
    cidr_block = string
    az = string

    #we are considering public as variable and this variable is optional and default value is false if user didnt provide 
    
    public = optional(bool, false)
  }))

  validation {

    #sub1={cidr=... az=...} sub2={cidr=... az=...} [True, False]
    #alltrue is a list of boolean values [True, True], it check if all value in list are true or not if not it will not consider, bu default it is private
    
    condition = alltrue([for config in var.subnet_config : can(cidrnetmask(config.cidr_block))])
    error_message = "Enter valid value"
}
}