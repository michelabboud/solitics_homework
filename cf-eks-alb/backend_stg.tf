terraform {
  backend "s3" {
    bucket         = "devops-michel-tf-statefile-eu-central-1"
    key            = "state/michelhomework/stg/terraform.tfstate"
    # region         = "eu-west-1"
    region         = "eu-central-1"
    dynamodb_table = "tf-state-locks-stg"
    encrypt        = true
  }
}
