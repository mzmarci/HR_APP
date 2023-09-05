resource "aws_vpc" "hr_app_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "hr_app_vpc"
  }
}

resource "aws_subnet" "subnet_1" {
  vpc_id            = aws_vpc.hr_app_vpc.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "eu-west-1a"
  tags = {
    Name = "Public subnet1"
  }
}

resource "aws_subnet" "subnet_2" {
  vpc_id            = aws_vpc.hr_app_vpc.id
  cidr_block        = "10.0.4.0/24"
  availability_zone = "eu-west-1b"
  tags = {
    Name = "Public subnet2"
  }
}



resource "aws_internet_gateway" "HR_APP_IGW" {
  vpc_id = aws_vpc.hr_app_vpc.id

  tags = {
    Name = "HR_APP igw"
  }
}

resource "aws_route_table" "route_1" {
  vpc_id = aws_vpc.hr_app_vpc.id

  tags = {

    Name = "RouteTable"
  }
}

resource "aws_route_table" "route_2" {
  vpc_id = aws_vpc.hr_app_vpc.id

  tags = {

    Name = "RouteTable2"
  }
}

resource "aws_route_table_association" "sub_route" {
  subnet_id      = aws_subnet.subnet_1.id
  route_table_id = aws_route_table.route_1.id
}

resource "aws_route_table_association" "sub_route_2" {
  subnet_id      = aws_subnet.subnet_2.id
  route_table_id = aws_route_table.route_2.id
}
