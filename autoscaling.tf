# autoscaling.tf

resource "aws_launch_configuration" "my_launch_config" {
  name_prefix          = "my-launch-config-"
  image_id             = "ami-xxxxxxxxxxxxx"  # Replace with your desired AMI ID
  instance_type        = "t2.micro"           # Customize the instance type as needed
  security_groups      = [aws_security_group.allow_http.id]
  key_name             = "your-key-pair-name" # Replace with your EC2 key pair name
  user_data            = ""
  associate_public_ip_address = true
}

resource "aws_autoscaling_group" "my_asg" {
  name_prefix         = "my-asg-"
  availability_zones  = [aws_subnet.my_subnet.availability_zone]
  launch_configuration = aws_launch_configuration.my_launch_config.name
  min_size            = 2   # Customize min and max size as needed
  max_size            = 5
  desired_capacity    = 2
  vpc_zone_identifier = [aws_subnet.my_subnet.id]
  target_group_arns   = [aws_lb_target_group.my_target_group.arn]
}

