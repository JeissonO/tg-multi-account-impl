module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.21.0"

  name = local.vpc_name
  cidr = var.cidr

  azs                          = local.azs
  private_subnets              = local.private_subnets
  public_subnets               = local.public_subnets
  create_database_subnet_group = true
  database_subnets             = local.database_subnets
  intra_subnets                = local.protected_subnets

  create_igw         = var.create_igw
  enable_nat_gateway = var.enable_nat_gateway

  tags                 = var.tags
  vpc_tags             = var.vpc_tags
  public_subnet_tags   = var.public_subnet_tags
  private_subnet_tags  = var.private_subnet_tags
  database_subnet_tags = var.database_subnet_tags
  intra_subnet_tags    = var.intra_subnet_tags

  enable_flow_log                         = var.enable_flow_log
  vpc_flow_log_iam_role_name              = "${var.vpc_flow_log_iam_role_name}-${local.vpc_name}"
  vpc_flow_log_iam_role_use_name_prefix   = var.vpc_flow_log_iam_role_use_name_prefix
  vpc_flow_log_permissions_boundary       = var.vpc_flow_log_permissions_boundary
  vpc_flow_log_iam_policy_name            = var.vpc_flow_log_iam_policy_name
  vpc_flow_log_iam_policy_use_name_prefix = var.vpc_flow_log_iam_policy_use_name_prefix
  flow_log_max_aggregation_interval       = var.flow_log_max_aggregation_interval
  flow_log_traffic_type                   = var.flow_log_traffic_type
  flow_log_destination_type               = var.flow_log_destination_type
  flow_log_log_format                     = var.flow_log_log_format
  flow_log_destination_arn                = var.flow_log_destination_arn
  flow_log_deliver_cross_account_role     = var.flow_log_deliver_cross_account_role
  flow_log_file_format                    = var.flow_log_file_format
  flow_log_hive_compatible_partitions     = var.flow_log_hive_compatible_partitions
  flow_log_per_hour_partition             = var.flow_log_per_hour_partition
  vpc_flow_log_tags                       = var.vpc_flow_log_tags

  create_flow_log_cloudwatch_log_group            = var.create_flow_log_cloudwatch_log_group
  create_flow_log_cloudwatch_iam_role             = var.create_flow_log_cloudwatch_iam_role
  flow_log_cloudwatch_iam_role_conditions         = var.flow_log_cloudwatch_iam_role_conditions
  flow_log_cloudwatch_iam_role_arn                = var.flow_log_cloudwatch_iam_role_arn
  flow_log_cloudwatch_log_group_name_prefix       = var.flow_log_cloudwatch_log_group_name_prefix
  flow_log_cloudwatch_log_group_name_suffix       = local.vpc_name
  flow_log_cloudwatch_log_group_retention_in_days = var.flow_log_cloudwatch_log_group_retention_in_days
  flow_log_cloudwatch_log_group_kms_key_id        = var.flow_log_cloudwatch_log_group_kms_key_id
  flow_log_cloudwatch_log_group_skip_destroy      = var.flow_log_cloudwatch_log_group_skip_destroy
  flow_log_cloudwatch_log_group_class             = var.flow_log_cloudwatch_log_group_class

}
