terraform {
  backend "s3" {
    bucket         = "pttp-global-bootstrap-pttp-infrastructure-tf-remote-state"
    dynamodb_table = "pttp-global-bootstrap-pttp-infrastructure-terrafrom-remote-state-lock-dynamo"
    key            = "terraform/v1/state"
    region         = "eu-west-2"
  }

  required_version = "1.1.7"

  required_providers {
    aws = {
      source                = "hashicorp/aws"
      version               = "~> 5.0"
      configuration_aliases = [aws.env]
    }
  }
}

provider "aws" {
  region = "eu-west-2"
}
