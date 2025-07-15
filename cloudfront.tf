resource "aws_cloudfront_distribution" "resume_site_cdn" {
  origin {
    domain_name = aws_s3_bucket.resume_site.website_endpoint
    origin_id   = "S3-resume-origin"

    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "http-only"
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"

  aliases = ["www.resume4demetrius.com"]  # ← ✅ ADD THIS LINE HERE

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "S3-resume-origin"

    viewer_protocol_policy = "redirect-to-https"

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }
  }

  viewer_certificate {
    acm_certificate_arn = "arn:aws:acm:us-east-1:122610502178:certificate/23826610-35c2-4c20-930f-0c2d03f63038"
    ssl_support_method  = "sni-only"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  tags = {
    Name = "Resume Site CDN"
  }
}
