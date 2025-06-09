locals {
  azs = slice(data.aws_availability_zones.available.names, 0, 3)

  vpc_name = var.name != null ? var.name : "jo-${data.aws_region.current.name}"

  # Base CIDR block with /16 mask
  base_cidr = var.cidr
  private_subnets = [
    for i in range(3) : cidrsubnet(local.base_cidr, 2, i)
  ]
  public_subnets = [
    for i in range(3) : cidrsubnet(local.base_cidr, 5, i)
  ]
  database_subnets = [
    for i in range(3) : cidrsubnet(local.base_cidr, 5, i + 3)
  ]
  protected_subnets = [
    for i in range(3) : cidrsubnet(local.base_cidr, 8, i)
  ]

}