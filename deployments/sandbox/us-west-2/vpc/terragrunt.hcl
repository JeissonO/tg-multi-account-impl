terraform {
  source = "../../../../modules/vpc"
}

include {
  path = find_in_parent_folders("root.hcl")
}

locals {
  cidr = "100.0.0.0/16"
}

inputs = {
  cidr = local.cidr
} 