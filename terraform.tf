terraform {
  backend "s3" {
    bucket               = "ricardoplaza-infrastructure"
    region               = "eu-west-1"
    workspace_key_prefix = "ricardoplaza-infrastructure/eks"
    key                  = "terraform_state"
    encrypt              = "true"
    dynamodb_table       = "ricardoplaza_terraform_eks_lock"
  }
}

data "terraform_remote_state" "infrastructure" {
  backend = "s3"
  config = {
    bucket               = "ricardoplaza-infrastructure"
    region               = "eu-west-1"
    workspace_key_prefix = "ricardoplaza-infrastructure/network"
    key                  = "terraform_state"
    encrypt              = "true"
    dynamodb_table       = "ricardoplaza_terraform_network_lock"
  }
}
