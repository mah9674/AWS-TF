provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "demo" {
  bucket = "mah-demo-bucket-130282"

  tags = {
    Name = "mah-demo-bucket"
  }
}

resource "aws_s3_bucket_public_access_block" "block" {
  bucket = aws_s3_bucket.demo.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket" "demo1" {
  bucket = "mah-demo1-bucket-200488"

  tags = {
    Name = "mah-demo-bucket"
  }
}

resource "aws_s3_bucket_public_access_block" "block1" {
  bucket = aws_s3_bucket.demo.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_object" "index" {
  bucket = aws_s3_bucket.demo.id
  key    = "index.html"
  source = "index.html"
  etag   = filemd5("index.html")
  content_type = "text/html"
}
