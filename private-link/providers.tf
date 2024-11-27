provider "aws" {
  region     = "eu-central-1"
  alias      = "eu-central-1"
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

provider "aws" {
  region     = "eu-west-3"
  alias      = "eu-west-3"
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}
