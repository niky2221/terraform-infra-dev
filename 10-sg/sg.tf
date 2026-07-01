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