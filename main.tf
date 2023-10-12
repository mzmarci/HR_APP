
resource "aws_instance" "Hr_App" {
  ami                    = var.ec2_ami
  instance_type          = var.ec2_instance_type
  key_name               = var.ec2_key_name
  vpc_security_group_ids = [aws_security_group.hr_app_security_group.id]
  //database_security_group = [aws_security_group.database_security_group.id]
  subnet_id                   = aws_subnet.subnet_1.id
  associate_public_ip_address = true
 // user_data =   file("proxy.sh")

  tags = {
    Name = "HrApp_Server1"
  }
}



resource "aws_instance" "Hr_App2" {
  ami                    = var.ec2_ami
  instance_type          = var.ec2_instance_type
  key_name               = var.ec2_key_name
  vpc_security_group_ids = [aws_security_group.hr_app_security_group.id]
 // database_security_group = var.database_security_group.id
  subnet_id                   = aws_subnet.subnet_1.id
  associate_public_ip_address = true
 // user_data =   file("proxy.sh")

  tags = {
    Name = "HrApp_Server2"
  }
}

resource "aws_instance" "Hr_App3" {
  ami                    = var.ec2_ami
  instance_type          = var.ec2_instance_type
  key_name               = var.ec2_key_name
  vpc_security_group_ids = [aws_security_group.hr_app_security_group.id]
  //database_security_group = var.database_security_group.id
  subnet_id                   = aws_subnet.subnet_1.id
  associate_public_ip_address = true
  tags = {
    Name = "Monitoring"
  }
}

