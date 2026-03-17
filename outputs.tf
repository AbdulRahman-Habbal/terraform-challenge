output "vpc_id" { value = aws_vpc.main.id } # Requirement [cite: 511]
output "external_alb_dns" { value = aws_lb.external.dns_name } # Requirement [cite: 512]
output "bastion_public_ip" { value = aws_instance.bastion.public_ip } # Requirement [cite: 513]
output "ssm_parameter_paths" { # Requirement [cite: 514]
  value = [aws_ssm_parameter.db_pass.name, aws_ssm_parameter.config.name] 
}