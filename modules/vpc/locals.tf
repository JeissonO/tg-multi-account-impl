locals {
  azs = slice([for az in data.aws_availability_zones.available.names : az if can(regex("^[a-z]+-[a-z]+-[0-9][a-z]$", az))], 0, 3)

  vpc_name = var.name != null ? var.name : "jo-${data.aws_region.current.name}"

  # Base CIDR block with /16 mask
  base_cidr = var.cidr

  # Private subnets (/18) - First half of the VPC
  private_subnets = [
    for i in range(3) : cidrsubnet(local.base_cidr, 2, i)
  ]

  # Public subnets (/21) - Second half, first quarter
  public_subnets = [
    for i in range(3) : cidrsubnet(local.base_cidr, 5, i + 24)
  ]

  # Database subnets (/21) - Second half, second quarter
  database_subnets = [
    for i in range(3) : cidrsubnet(local.base_cidr, 5, i + 27)
  ]

  # Protected subnets (/24) - Second half, third quarter
  protected_subnets = [
    for i in range(3) : cidrsubnet(local.base_cidr, 8, i + 240)
  ]
}