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

module "web_alb_sg" {
    source = "git::https://github.com/niky2221/terraform-sg_.git?ref=main"
    project = var.project
    environment = var.environment
    sg_name  =  "web"
    sg_description = "web instance security group"
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

module "vpn_sg" {
    source = "git::https://github.com/niky2221/terraform-sg_.git?ref=main"
    project = var.project
    environment = var.environment
    sg_name  =  "vpn"
    sg_description = "vpn security group"
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

# ports 22, 443, 1194, 943 --> VPN ports
resource "aws_security_group_rule" "vpn_ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"] 
  security_group_id = module.vpn_sg.sg_id
}

resource "aws_security_group_rule" "vpn_443" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"] 
  security_group_id = module.vpn_sg.sg_id
}

resource "aws_security_group_rule" "vpn_1194" {
  type              = "ingress"
  from_port         = 1194
  to_port           = 1194
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"] 
  security_group_id = module.vpn_sg.sg_id
}

resource "aws_security_group_rule" "vpn_943" {
  type              = "ingress"
  from_port         = 943
  to_port           = 943
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"] 
  security_group_id = module.vpn_sg.sg_id
}

resource "aws_security_group_rule" "web_alb_https" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"] 
  security_group_id = module.web_alb_sg.sg_id
}

resource "aws_security_group_rule" "vpn_alb" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  source_security_group_id = module.vpn_sg.sg_id
  security_group_id = module.alb_sg.sg_id
}
# APP mysql accepting traffic from vpn
resource "aws_security_group_rule" "mysql_vpn" {
  type              = "ingress"
  from_port         = 3306
  to_port           = 3306
  protocol          = "tcp"
  source_security_group_id = module.vpn_sg.sg_id
  security_group_id = module.mysql_sg.sg_id
}
# APP mysql db connected through from bastion
resource "aws_security_group_rule" "mysql_bastion" {
  type              = "ingress"
  from_port         = 3306
  to_port           = 3306
  protocol          = "tcp"
  source_security_group_id = module.bastion_sg.sg_id
  security_group_id = module.mysql_sg.sg_id
}

# APP backend accepting traffic from vpn
resource "aws_security_group_rule" "backend_vpn" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.vpn_sg.sg_id
  security_group_id = module.backend_sg.sg_id
}


# APP backend accepting traffic from app_alb
resource "aws_security_group_rule" "backend_app_alb" {
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  source_security_group_id = module.alb_sg.sg_id
  security_group_id = module.backend_sg.sg_id
}

# APP backend accepting traffic from vpn
resource "aws_security_group_rule" "backend_vpn_http" {
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  source_security_group_id = module.vpn_sg.sg_id
  security_group_id = module.backend_sg.sg_id

}
# APP mysql accepting traffic from backend
resource "aws_security_group_rule" "mysql_backend" {
  type              = "ingress"
  from_port         = 3306
  to_port           = 3306
  protocol          = "tcp"
  source_security_group_id = module.backend_sg.sg_id
  security_group_id = module.mysql_sg.sg_id
}