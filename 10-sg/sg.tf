module "mysql_sg" {
    source = "git::https://github.com/niky2221/terraform-sg_.git?ref=main"
    project = var.project
    environment = var.environment
    sg_name  =  "mysql"
    sg_description = "mysql instance security group"
    vpc_id = data.aws_ssm_parameter.vpc_id.value
    common_tags = var.common_tags
}

module "backend_sg" {
    source = "git::https://github.com/niky2221/terraform-sg_.git?ref=main"
    project = var.project
    environment = var.environment
    sg_name  =  "backend"
    sg_description = "backend instance security group"
    vpc_id = data.aws_ssm_parameter.vpc_id.value
    common_tags = var.common_tags
}

module "frontend_sg" {
    source = "git::https://github.com/niky2221/terraform-sg_.git?ref=main"
    project = var.project
    environment = var.environment
    sg_name  =  "frontend"
    sg_description = "frontend instance security group"
    vpc_id = data.aws_ssm_parameter.vpc_id.value
    common_tags = var.common_tags
}

module "bastion_sg" {
    source = "git::https://github.com/niky2221/terraform-sg_.git?ref=main"
    project = var.project
    environment = var.environment
    sg_name  =  "bastion"
    sg_description = "bastion instance security group"
    vpc_id = data.aws_ssm_parameter.vpc_id.value
    common_tags = var.common_tags
}

module "alb_sg" {
    source = "git::https://github.com/niky2221/terraform-sg_.git?ref=main"
    project = var.project
    environment = var.environment
    sg_name  =  "alb"
    sg_description = "alb security group"
    vpc_id = data.aws_ssm_parameter.vpc_id.value
    common_tags = var.common_tags
}

# APP ALB accepting traffic from bastion
resource "aws_security_group_rule" "app_alb_bastion" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  source_security_group_id       = module.bastion_sg.sg_id
  security_group_id = module.alb_sg.sg_id
}

# JDOPS-32, Bastion host should be accessed from office n/w
resource "aws_security_group_rule" "bastion_public" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"] # it must be our system public ip
  security_group_id = module.bastion_sg.sg_id
}