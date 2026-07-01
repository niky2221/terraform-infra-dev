module "aws_vpc" {
    source = "git::https://github.com/niky2221/terraform-vpc.git?ref=main"
    cidr_block = var.cidr_block
    project = var.project
    environment = var.environment
    common_tags = var.common_tags
    public_subnet_cidrs = var.public_subnet_cidrs
    private_subnet_cidrs = var.private_subnet_cidrs
    database_subnet_cidrs = var.database_subnet_cidrs
    is_peering_required = true
}