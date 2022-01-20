terraform {
  backend "s3" {
    bucket = "stylesage-infrastructure"
    key    = "stylesage-eks.tfstate"
    region = "eu-west-1"
  }
}

data "terraform_remote_state" "infrastructure" {
  backend = "s3"
  config = {
    bucket = "stylesage-infrastructure"
    key    = "stylesage-network.tfstate"
    region = "eu-west-1"
  }
}
