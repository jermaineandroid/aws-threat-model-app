terraform {
  backend "s3" {
    bucket         = "threat-modeling-app-terraform-state"
    key            = "terraform.tfstate"
    region         = "eu-west-2"
    dynamodb_table = "terraform-state-lock"
    encrypt        = true
  }
}