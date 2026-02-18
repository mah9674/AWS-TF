terraform {
  backend "s3" {
    bucket         = "mah-terraform-state-131115"
    key            = "ec2/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-lock"
    encrypt        = true
  }
}
