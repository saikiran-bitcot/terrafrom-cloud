resource "aws_vpc" "elb-vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name="elb-vpc"
  }
}

resource "aws_subnet" "elb-subnet-public1" {
  vpc_id = aws_vpc.elb-vpc.id
  availability_zone = "us-east-1a"
  cidr_block = "10.0.0.0/24"
  map_public_ip_on_launch = true
  tags = {
    Name="elb-public1"
  }
}

resource "aws_subnet" "elb-subnet-public2" {
  vpc_id = aws_vpc.elb-vpc.id
  availability_zone = "us-east-1b"
  map_public_ip_on_launch = true
  cidr_block = "10.0.1.0/24"
  tags = {
    Name="elb-public2"
  }
}

resource "aws_subnet" "elb-subnet-private1" {
  vpc_id = aws_vpc.elb-vpc.id
  availability_zone = "us-east-1c"
  cidr_block = "10.0.2.0/24"
  tags = {
    Name:"elb-private1"
  }
}

resource "aws_subnet" "elb-subnet-private2" {
  vpc_id = aws_vpc.elb-vpc.id
  availability_zone = "us-east-1d"
  cidr_block = "10.0.3.0/24"
  tags = {
    Name:"elb-private2"
  }
}


resource "aws_internet_gateway" "elb-igw" {
  vpc_id = aws_vpc.elb-vpc.id
  tags = {
    Name="elb-igw"
  }
}

resource "aws_route_table" "elb-rtb" {
  vpc_id = aws_vpc.elb-vpc.id
  tags = {
    Name="elb-rtb"
  }
}

resource "aws_route_table_association" "elb-rtb-association" {
  route_table_id = aws_route_table.elb-rtb.id
  subnet_id = aws_subnet.elb-subnet-public1.id
}

resource "aws_route_table_association" "elb-rtb-association-2" {
  route_table_id = aws_route_table.elb-rtb.id
  subnet_id = aws_subnet.elb-subnet-public2.id
}

resource "aws_route" "elb-route" {
  route_table_id = aws_route_table.elb-rtb.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.elb-igw.id

}

resource "aws_security_group" "elb-sg" {
  vpc_id = aws_vpc.elb-vpc.id
  description = "elb security group using terraform"
  tags = {
    Name="elb-sg"
  }
}

resource "aws_security_group_rule" "elb-sg-rule" {
  security_group_id = aws_security_group.elb-sg.id
  type = "ingress"
  protocol = "tcp"
  from_port = 80
  to_port = 80
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "elb-sg-rule-egress" {
  security_group_id = aws_security_group.elb-sg.id
  type = "egress"
  protocol = "-1"
  cidr_blocks = ["0.0.0.0/0"]
  from_port = 0
  to_port = 0
}