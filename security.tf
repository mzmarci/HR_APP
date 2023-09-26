resource "aws_security_group" "hr_app_security_group" {
  name        = "hr_app_security_group"
  description = "Allow SSH and HTTP Connection"
  vpc_id      = aws_vpc.hr_app_vpc.id

  ingress {
    description = "Allow inbound and outbound connection"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }

  ingress {
    description = "Allow inbound and outbound connection"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }

  ingress {
    description = "Allow SSH inbound and outbound connection"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]

  }

  tags = {
    Name = "hr_app"
  }
}
