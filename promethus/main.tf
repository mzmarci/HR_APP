#Create aws_iam_role resource

resource "aws_iam_role" "prometheus_aws_iam_role" {
  name = "prometheus_aws_iam_role"

  assume_role_policy = <<EOF
{
   "Version": "2012-10-17",
   "Statement": [
     {
       "Action": "sts:AssumeRole",
       "Principal": {
         "Service": "ec2.amazonaws.com"
       },
       "Effect": "Allow",
       "Sid": ""
     }
   ]
 }
 EOF
}

#Create aws_iam_instance_profile resource

resource "aws_iam_instance_profile" "prometheus_iam_instance_profile" {
  name = "prometheus_iam_instance_profile"
  role = aws_iam_role.prometheus_aws_iam_role.name
}

#Create aws_iam_role_policy resource

resource "aws_iam_role_policy" "prometheus_iam_role_policy" {
  name = "prometheus_iam_role_policy"
  role = aws_iam_role.prometheus_aws_iam_role.id

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "ec2:Describe*",
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": "elasticloadbalancing:Describe*",
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "cloudwatch:ListMetrics",
                "cloudwatch:GetMetricStatistics",
                "cloudwatch:Describe*"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": "autoscaling:Describe*",
            "Resource": "*"
        }
    ]
}
 EOF
}

# Create EC2 Instance

resource "aws_instance" "Hr_App3" {
  ami                    = var.ec2_ami
  instance_type          = var.ec2_instance_type
  key_name               = var.ec2_key_name
  //vpc_security_group_ids = [aws_security_group.prometheus.id]
  vpc_security_group_ids = [aws_security_group.hr_app_security_group.id]

  //database_security_group = var.database_security_group.id
  subnet_id            = aws_subnet.subnet_1.id
  //iam_instance_profile = aws_iam_instance_profile.prometheus_iam_instance_profile.name
  //user_data                   = templatefile("${path.module}/prometheus.yml")

  # Copy the prometheus file to instance
  //provisioner "file" {
  // source      = "./upload"
  // destination = "/tmp"
  //}

  provisioner "file" {
    connection {
      host        = self.public_ip
      type        = "ssh"
      user        = "ec2-user"
      private_key = file("${path.module}/test100.pem")
    }
    source      = "./upload"
    destination = "/tmp"
  }

  associate_public_ip_address = true
  tags = {
    Name = "Montoring server"
  }
}