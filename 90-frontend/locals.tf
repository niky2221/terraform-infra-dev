locals {
  public_subnet_id = split(",", data.aws_ssm_parameter.public_subnet_ids.value)[0]
  resource_name = "${var.project}-${var.environment}"
  public_subnet_ids = split(",", data.aws_ssm_parameter.public_subnet_ids.value)
  frontend_sg_id = data.aws_ssm_parameter.frontend_sg_id.value
}