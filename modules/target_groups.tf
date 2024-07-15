resource "aws_lb_target_group" "elb-tg" {
  name = "elb-tag"
  port = 80
  protocol = "HTTP"
  vpc_id = aws_vpc.elb-vpc.id
  tags = {
    Name="elb-tag"
  }
  health_check {
    path = "/"
    healthy_threshold = 5
    unhealthy_threshold = 2
    timeout = 5
    interval = 30
    matcher = "200"
  }
}

resource "aws_lb_target_group_attachment" "elb-tg-attaching-ec2" {
  target_group_arn = aws_lb_target_group.elb-tg.arn
  target_id = aws_instance.elb-instances.id
  port = 80
}