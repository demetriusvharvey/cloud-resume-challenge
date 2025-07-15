resource "aws_s3_bucket" "resume_site" {
  bucket         = "tf-resume-website-bucket"
  force_destroy  = true

  tags = {
    Name        = "Cloud Resume Bucket"
    Environment = "Dev"
  }
}

resource "aws_s3_bucket_website_configuration" "resume_site_website" {
  bucket = aws_s3_bucket.resume_site.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "index.html"
  }
}

resource "aws_s3_bucket_public_access_block" "resume_site_block" {
  bucket                  = aws_s3_bucket.resume_site.id
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "public_read_policy" {
  bucket = aws_s3_bucket.resume_site.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid       = "PublicReadGetObject",
        Effect    = "Allow",
        Principal = "*",
        Action    = "s3:GetObject",
        Resource  = "${aws_s3_bucket.resume_site.arn}/*"
      }
    ]
  })
}
