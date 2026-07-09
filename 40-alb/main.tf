module "alb" {
  source = "terraform-aws-modules/alb/aws"
  internal = true

  name    = "${var.project}-${var.environment}-alb"
  vpc_id  = data.aws_ssm_parameter.vpc_id.value
  subnets = local.private_subnet_id
  create_security_group = false
  security_groups =  [data.aws_ssm_parameter.alb_sg_id.value]
  enable_deletion_protection = false

  tags = merge(
    var.common_tags,
    {
        Name = "${var.project}-${var.environment}-alb"
    }
  )
}