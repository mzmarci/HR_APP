# create application load balancer
resource "aws_lb" "hr_app_load_balancer" {
  name                       = "hr-app-alb"
  internal                   = false
  load_balancer_type         = "application"
  security_groups            = [aws_security_group.hr_app_security_group.id]
  subnets                    = [aws_subnet.subnet_1.id, aws_subnet.subnet_2.id]
  enable_deletion_protection = false

  tags = {
    Name = "hr-app-alb"
  }
}

# create target group
resource "aws_lb_target_group" "hr_app_target_group" {
  name        = "hr-app-tg"
  target_type = "ip"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.hr_app_vpc.id

  health_check {
    enabled             = true
    interval            = 300
    path                = "/"
    timeout             = 60
    matcher             = 200
    healthy_threshold   = 5
    unhealthy_threshold = 5
  }

  lifecycle {
    create_before_destroy = true
  }
}

# create a listener on port 80 with redirect action
resource "aws_lb_listener" "hr_app_http_listener" {
  load_balancer_arn = aws_lb.hr_app_load_balancer.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = 443
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

# create a listener on port 443 with forward action
resource "aws_lb_listener" "hr_app_https_listener" {
  load_balancer_arn = aws_lb.hr_app_load_balancer.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.hr_app_target_group.arn
  }
}


# create a listener on port 80 with forward action
resource "aws_lb_listener" "hr_app_https_listener2" {
  load_balancer_arn = aws_lb.hr_app_load_balancer.arn
  port              = 80
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.hr_app_target_group.arn
  }
}