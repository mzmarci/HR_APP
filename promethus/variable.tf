variable "ec2_ami" {
  description = "this is a variable to manage ec2_ami type"
  type        = string
  default     = "ami-0ed752ea0f62749af"
}

variable "ec2_key_name" {
  description = "this is a variable to manage ec2_key_name"
  type        = string
  default     = "test100"
}

variable "ec2_instance_type" {
  description = "this is a variable to manage ec2_instance_type"
  type        = string
  default     = "t2.micro"

}



