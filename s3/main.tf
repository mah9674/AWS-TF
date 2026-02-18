provider "aws" {
  region = "us-east-1"
}

# ---------------- S3 bucket ----------------
resource "aws_s3_bucket" "demo" {
  bucket = "mah-demo-bucket-130282"

  tags = {
    Name = "mah-demo-bucket"
  }
}

resource "aws_s3_bucket_public_access_block" "block" {
  bucket = aws_s3_bucket.demo.id

  block_public_acls       = true
  block_public_policy     = false
  ignore_public_acls      = true
  restrict_public_buckets = false
}

# Bucket policy to allow public read
resource "aws_s3_bucket_policy" "public_read" {
  bucket = aws_s3_bucket.demo.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = "*"
        Action = "s3:GetObject"
        Resource = "${aws_s3_bucket.demo.arn}/*"
      }
    ]
  })
}

# ---------------- Second bucket ----------------
resource "aws_s3_bucket" "demo1" {
  bucket = "mah-demo1-bucket-200488"

  tags = {
    Name = "mah-demo1-bucket"
  }
}

resource "aws_s3_bucket_public_access_block" "block1" {
  bucket = aws_s3_bucket.demo1.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# ---------------- index.html upload ----------------
resource "aws_s3_object" "index" {
  bucket       = aws_s3_bucket.demo.id
  key          = "index.html"
  source       = "index.html"
  etag         = filemd5("index.html")
  content_type = "text/html"
}

# ---------------- CloudFront ----------------
resource "aws_cloudfront_distribution" "cdn" {
  origin {
    domain_name = aws_s3_bucket.demo.bucket_regional_domain_name
    origin_id   = "s3-origin"

    s3_origin_config {
      origin_access_identity = ""
    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "S3 CloudFront CDN"
  default_root_object = "index.html"

  default_cache_behavior {
    target_origin_id       = "s3-origin"
    viewer_protocol_policy = "redirect-to-https"

    allowed_methods = ["GET", "HEAD"]
    cached_methods  = ["GET", "HEAD"]

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}

