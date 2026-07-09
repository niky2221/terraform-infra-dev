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

resource "aws_lb_listener" "http" {
  load_balancer_arn = module.alb.arn
  port              = "80"
  protocol          = "HTTP"

 default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/html"
      message_body = "<h1>Hello, I am from backend APP ALB</h1>"
      status_code  = "200"
    }
  }
}

resource "aws_route53_record" "alb_record" {
  zone_id = var.zone_id
  name    = "*.app-dev.${var.domain_name}"
  type    = "A"

  alias {
    name                   = module.alb.dns_name
    zone_id                = module.alb.zone_id # Use the same hosted zone ID
    evaluate_target_health = false
  }
}