resource "aws_instance" "elb-instances" {
  subnet_id = aws_subnet.elb-subnet-private2.id
  ami = "ami-06c68f701d8090592"
  instance_type = "t2.micro"
  iam_instance_profile = "ecsInstanceRole"
  security_groups = [aws_security_group.elb-sg.id]
  user_data = <<-EOF
              #!/bin/bash
              sudo yum update -y
              sudo yum install nginx -y
              sudo systemctl start nginx
              sudo systemctl enable nginx
              EOF
  tags = {
    Name="terraform"
  }
}

