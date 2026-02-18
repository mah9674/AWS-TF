provider "aws" {
  region = "us-east-1"
}

resource "random_id" "bucket" {
  byte_length = 4
}

resource "aws_s3_bucket" "state" {
  bucket = "mah-terraform-state-131115"

  tags = {
    Name = "terraform-state"
  }
}

resource "aws_dynamodb_table" "lock" {
  name         = "terraform-lock"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Name = "terraform-lock"
  }
}
