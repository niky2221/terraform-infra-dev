resource "aws_instance" "vpn" {
  ami                    = data.aws_ami.openvpn.id # This is our openvpn AMI ID
  vpc_security_group_ids = [data.aws_ssm_parameter.vpn_sg_id.value]
  instance_type          = "t3.micro"
  subnet_id = local.public_subnet_id
  tags = merge(
    var.common_tags,
    {
        Name = "${var.project}-${var.environment}-vpn"
    }
  ) 
}