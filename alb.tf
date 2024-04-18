#Create target group
resource "aws_lb_target_group" "alb_tg" {
  name     = "ALBtg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.dev_vpc.id
  
  # health_check {
  #   enabled             = true
  #   healthy_threshold   = 2
  #   unhealthy_threshold = 2
  #   interval            = 250
  #   matcher             = "302"
  #   path                = "/"
  #   port                = "traffic-port"
  #   protocol            = "HTTP"
  # }

}

#Creating ALB
resource "aws_lb" "alb" {
  name               = "ALB"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.dev_sg.id]
  subnets            = [aws_subnet.dev_subnet.id,aws_subnet.dev_subnet2.id]
  ip_address_type = "ipv4"

  tags = {
    Name = "awsRestartALB"

  }

}


#Create target group attachment
resource "aws_lb_target_group_attachment" "ec2_attach" {
  count =   length(aws_instance.instance)
 
  target_group_arn = aws_lb_target_group.alb_tg.arn
  #target_id        = data.aws_instance.instance.id[count.index]
  target_id        = aws_instance.instance[count.index].id
  port             = 80

}

#Create listener
resource "aws_lb_listener" "alb_listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_tg.arn
  }
}



