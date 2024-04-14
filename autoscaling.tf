#Launch Template for Autoscaling
resource "aws_launch_template" "launch_template" {
  name_prefix   = "awsRestartlt"
  image_id      = data.aws_ami.latest_linux_ami.id
  instance_type = "t2.micro"
  key_name      = "vockey"
  #user_data     = filebase64("${path.module}/userdata.sh")
  user_data     = filebase64("${path.module}/userdata.tpl")

  vpc_security_group_ids = [aws_security_group.dev_sg.id]

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "AutoScalingEc2"
    }
  }
}
#AutoScaling Group
resource "aws_autoscaling_group" "asg" {
  name                = "awsRestartasg"
  vpc_zone_identifier = [aws_subnet.dev_subnet.id,aws_subnet.dev_subnet2.id]
  desired_capacity    = 2
  max_size            = 4
  min_size            = 1

  launch_template {
    id      = aws_launch_template.launch_template.id
    version = "$Latest"
  }
}
#AutoScaling Policy
resource "aws_autoscaling_policy" "asg_policy" {
  name                   = "CPUPolicy"
  autoscaling_group_name = aws_autoscaling_group.asg.name
  policy_type            = "TargetTrackingScaling"

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }

    target_value = 40.0
  }
}


