resource "aws_ssm_parameter" "web_alb_certificate" {
  name  = "/${var.project}/${var.environment}/web_alb_certificate"
  type  = "String"
  value = aws_acm_certificate.https.arn
}
