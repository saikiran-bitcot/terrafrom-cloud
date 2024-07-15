resource "aws_lb" "elb" {
  load_balancer_type = "application"
  name = "elb-terraform"
  internal = false
  subnets = [aws_subnet.elb-subnet-public1.id,aws_subnet.elb-subnet-public2.id]
  security_groups = [aws_security_group.elb-sg.id]
  tags = {
    Name="elb-terraform"
  }
}

resource "aws_lb_listener" "elb" {
  load_balancer_arn = aws_lb.elb.arn
  protocol = "HTTP"
  port = 80
  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.elb-tg.arn
  }
}