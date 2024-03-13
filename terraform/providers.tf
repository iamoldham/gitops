terraform {
  backend "s3" {
    # region = "us-east-1"
    # encrypt = true
    # bucket = "timeapp-infra"
    # key    = "terraform.tfstate"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.14.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.5.1"
    }

    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0.4"
    }
  }
}

provider "aws" {
  region = "us-east-1"
  access_key=var.aws_access_key
  secret_key=var.aws_secret_key
}
