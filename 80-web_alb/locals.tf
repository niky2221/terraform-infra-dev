locals {
  public_subnet_id = split(",", data.aws_ssm_parameter.public_subnet_ids.value)[0]
  private_subnet_id = split(",", data.aws_ssm_parameter.private_subnet_ids.value)
  web_alb_certificate_arn = data.aws_ssm_parameter.web_alb_certificate.value
}