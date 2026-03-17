# Bastion Host [cite: 496]
resource "aws_instance" "bastion" {
  ami                         = var.ami_id
  instance_type               = "t3.micro"
  subnet_id                   = aws_subnet.public[0].id
  vpc_security_group_ids      = [aws_security_group.bastion_sg.id]
  key_name                    = var.key_name
  associate_public_ip_address = true
  tags                        = { Name = "Bastion-Host" }
}

# Web Tier ASG [cite: 496]
resource "aws_launch_template" "web" {
  name_prefix   = "web-lt-"
  image_id      = var.ami_id
  instance_type = "t3.micro"
  key_name      = var.key_name
  vpc_security_group_ids = [aws_security_group.web_sg.id]
  iam_instance_profile { name = aws_iam_instance_profile.ec2_profile.name }
  # User data with base64 encoding [cite: 556]
  user_data = base64encode(templatefile("userdata/web.sh", {
    backend_dns = aws_lb.internal.dns_name # Passing Internal ALB DNS to Nginx
  }))
}

resource "aws_autoscaling_group" "web_asg" {
  vpc_zone_identifier = aws_subnet.public[*].id
  target_group_arns   = [aws_lb_target_group.web_tg.arn] # Link ASG to ALB [cite: 553]
  min_size            = 1
  max_size            = 4
  desired_capacity    = 2
  launch_template {
  id      = aws_launch_template.web.id
  version = "$Latest"
}
}

# Backend Tier ASG [cite: 496]
resource "aws_launch_template" "backend" {
  name_prefix   = "backend-lt-"
  image_id      = var.ami_id
  instance_type = "t3.micro"
  key_name      = var.key_name
  vpc_security_group_ids = [aws_security_group.backend_sg.id]
  iam_instance_profile { name = aws_iam_instance_profile.ec2_profile.name }
  user_data = base64encode(file("userdata/backend.sh")) # [cite: 556]
}

resource "aws_autoscaling_group" "backend_asg" {
  vpc_zone_identifier = aws_subnet.private[*].id # Placed in Private Subnets [cite: 554]
  target_group_arns   = [aws_lb_target_group.backend_tg.arn]
  min_size            = 1
  max_size            = 3
  desired_capacity    = 2
  launch_template {
  id      = aws_launch_template.backend.id
  version = "$Latest"
}
}
