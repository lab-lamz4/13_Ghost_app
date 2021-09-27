
terraform {
  required_version = "~> 0.13"
  backend "s3" {
    bucket = "learninig-state-lamz4-02"
    key    = "state/13_ghost_app.tfstate"
    region = "us-east-1"
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region                  = "us-east-1"
  shared_credentials_file = pathexpand("~/.aws/credentials")
}
