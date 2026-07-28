module "web_alb" {
  source = "terraform-aws-modules/alb/aws"
  internal = false

  name    = "${var.project}-${var.environment}-web-alb"
  vpc_id  = data.aws_ssm_parameter.vpc_id.value
  subnets = local.public_subnet_ids
  create_security_group = false
  security_groups =  [data.aws_ssm_parameter.web_alb_sg_id.value]
  enable_deletion_protection = false

  tags = merge(
    var.common_tags,
    {
        Name = "${var.project}-${var.environment}-web-alb"
    }
  )
}

resource "aws_lb_listener" "https" {
  load_balancer_arn = module.web_alb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = local.web_alb_certificate_arn

 default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/html"
      message_body = "<h1>Hello, I am from frontend APP ALB</h1>"
      status_code  = "200"
    }
  }
}

resource "aws_route53_record" "web_alb_record" {
  zone_id = var.zone_id
  name    = "expense-${var.environment}.${var.domain_name}"
  type    = "A"

  alias {
    name                   = module.web_alb.dns_name
    zone_id                = module.web_alb.zone_id # Use the same hosted zone ID
    evaluate_target_health = false
  }
}