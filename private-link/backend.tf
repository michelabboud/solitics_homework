terraform {
  backend "s3" {
    bucket         = "devops-michel-tf-statefile-eu-central-1"
    key            = "state/michelhomework/pvtlnk/terraform.tfstate"
    region         = "eu-central-1"
    dynamodb_table = "tf-state-locks-stg"
    encrypt        = true
  }
}
