locals {
  # Read environment variables from account.hcl file in each account folder
  account_vars = read_terragrunt_config(find_in_parent_folders("account.hcl"))
  region_vars  = read_terragrunt_config(find_in_parent_folders("region.hcl"))

  # Shared services account ID - and provider config
  shared_services_account_id = "111111111111"
  aws_assume_role_arn        = local.account_vars.locals.aws_assume_role_arn
  aws_account_id             = local.account_vars.locals.aws_account_id
  environment                = local.account_vars.locals.environment
  aws_region                 = local.region_vars.locals.aws_region

  # State bucket and DynamoDB table for state locking
  state_bucket        = "ss-tg-state-${local.shared_services_account_id}"
  state_bucket_region = "us-west-2"
  dynamodb_table      = "ss-tg-state-lock"

  common_tags = {
    iac         = "tg-multi-account-impl"
    managed_by  = "terraform"
    environment = local.environment
  }
}

remote_state {
  backend = "s3"
  config = {
    encrypt        = true
    bucket         = local.state_bucket
    key            = "${path_relative_to_include()}/terraform.tfstate"
    region         = local.state_bucket_region
    dynamodb_table = local.dynamodb_table
  }
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
}


generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite"
  contents  = <<EOF
provider "aws" {
  region = "${local.aws_region}"
  default_tags {
    tags = ${jsonencode(local.common_tags)}
  }
  assume_role {
    role_arn     = "${local.aws_assume_role_arn}"
    session_name = "tg-multi-account-impl-session"
  }
}
EOF
}
