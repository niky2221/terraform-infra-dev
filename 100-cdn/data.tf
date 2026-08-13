data "aws_cloudfront_cache_policy" "no_cache" {
    name = "Managed-CachingDisabled"
}

data "aws_cloudfront_cache_policy" "CacheEnabled" {
    name = "Managed-CachingOptimized"
}

data "aws_ssm_parameter" "web_alb_certificate" {
    name = "/${var.project}/${var.environment}/web_alb_certificate"
  
}