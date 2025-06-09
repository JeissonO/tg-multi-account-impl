locals {
  aws_account_id      = "222222222222"
  aws_assume_role_arn = "arn:aws:iam::${local.aws_account_id}:role/AWSTFExecution"
  environment         = "networking"
}