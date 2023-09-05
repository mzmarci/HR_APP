output "Hr_App_ip" {
  value = aws_instance.Hr_App.public_ip
}

output "hr_app_security_group_id" {
  value = aws_security_group.hr_app_security_group.id
}

output "vpc_id" {
  value = aws_vpc.hr_app_vpc.id
}


output "subnet_1" {
  value       = aws_subnet.subnet_1.id
  description = "This is first public subnet id."
}
output "subnet_2" {
  value       = aws_subnet.subnet_2.id
  description = "This is first second subnet id."
}


output "route_1" {
  value       = aws_route_table.route_1.id
  description = "public route table id."
}


output "route_2" {
  value       = aws_route_table.route_2.id
  description = "public route table id."
}


