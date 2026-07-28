resource "aws_ssm_parameter" "lb_listener_arn" {
  name  = "/${var.project}/${var.environment}/lb_listener_arn"
  type  = "String"
  value = aws_lb_listener.http.arn
}
