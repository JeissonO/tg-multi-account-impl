locals {
  aws_account_id      = "333333333333"
  aws_assume_role_arn = "arn:aws:iam::${local.aws_account_id}:role/AWSTFExecution"
  environment         = "sandbox"
}