terraform {
  backend "s3" {
    bucket               = "stylesage-infrastructure"
    region               = "eu-west-1"
    workspace_key_prefix = "stylesage-infrastructure/eks"
    key                  = "terraform_state"
    encrypt              = "true"
    dynamodb_table       = "stylesage_terraform_eks_lock"
  }
}

data "terraform_remote_state" "infrastructure" {
  backend = "s3"
  config = {
    bucket               = "stylesage-infrastructure"
    region               = "eu-west-1"
    workspace_key_prefix = "stylesage-infrastructure/network"
    key                  = "terraform_state"
    encrypt              = "true"
    dynamodb_table       = "stylesage_terraform_network_lock"
  }
}
