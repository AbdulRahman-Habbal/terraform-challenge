resource "aws_ssm_parameter" "db_pass" {
  name  = "/app/db_password"
  type  = "SecureString"
  value = "lab-challenge-2026-safe"
}

resource "aws_ssm_parameter" "config" {
  name  = "/app/config_value"
  type  = "String"
  value = "lab007-prod"
}

resource "aws_iam_role" "ec2_role" {
  name = "EC2SSMReadRole"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = { Service = "ec2.amazonaws.com" }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "ssm_read" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMReadOnlyAccess"
}

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "ec2-ssm-instance-profile"
  role = aws_iam_role.ec2_role.name
}