# configured aws provider with proper credentials

# create default vpc if one does not exit
//resource "aws_default_vpc" "default_vpc" {



# use data source to get all avalablility zones in region
data "aws_availability_zones" "available_zones" {}

# create a default subnet in the first az if one does not exit
resource "aws_default_subnet" "subnet_1" {
  availability_zone = data.aws_availability_zones.available_zones.names[0]
}

# create a default subnet in the second az if one does not exit
resource "aws_default_subnet" "subnet_2" {
  availability_zone = data.aws_availability_zones.available_zones.names[1]
}

# create security group for the web server
resource "aws_security_group" "webserver_security_group" {
  name        = "webserver security group"
  description = "enable postgres t0 access port 80"
  vpc_id      = aws_vpc.hr_app_vpc.id

  ingress {
    description = "http access"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "webserver security group"
  }
}

# create security group for the database
resource "aws_security_group" "database_security_group" {
  name        = "database security group"
  description = "enable postgres access on port 5432"
  vpc_id      = aws_vpc.hr_app_vpc.id

  ingress {
    description     = "postgres"
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.webserver_security_group.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "database_security_group"
  }
}


# create the subnet group for the rds instance
resource "aws_db_subnet_group" "database_subnet_group" {
  name        = "database_subnets"
  subnet_ids  = [aws_subnet.subnet_1.id, aws_subnet.subnet_2.id]
  description = "subnet for database instance"

  tags = {
    Name = "database_subnets"
  }
}


# create the rds instance
resource "aws_db_instance" "db_instance" {
  engine                 = "postgres"
  engine_version         = "15.3"
  multi_az               = false
  identifier             = "hr-project"
  username               = "project"
  password               = "marci123"
  instance_class         = "db.t3.micro"
  allocated_storage      = 400
  db_subnet_group_name   = aws_db_subnet_group.database_subnet_group.id
  vpc_security_group_ids = [aws_security_group.database_security_group.id]
  availability_zone      = data.aws_availability_zones.available_zones.names[0]
  db_name                = "projects"
  skip_final_snapshot    = true
}
