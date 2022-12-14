provider "aws" {
  region = "eu-west-2"
}

terraform {
  backend "s3" {
    bucket = "436158765452-terraform-state"
    key    = "states/chizography-aws-infra"
    region = "eu-west-2"
  }

  required_version = "~> 1.2"
}
