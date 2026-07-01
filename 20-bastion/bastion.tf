resource "aws_instance" "this" {
  ami                    = data.aws_ami.expense.id # This is our devops-practice AMI ID
  vpc_security_group_ids = [aws_security_group.allow_tls.id]
  instance_type          = "t3.micro"
  tags = {
        Name = "terraform"
    }
}