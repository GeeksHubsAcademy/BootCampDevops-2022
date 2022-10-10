############
## OUTPUT ##
############
output "lc_id" {
  description = "The ID of the launch configuration"
  value       = aws_launch_configuration.as_conf.id
}

output "lc_name" {
  description = "The name of the launch configuration"
  value       = aws_launch_configuration.as_conf.name
}

output "asg_id" {
  description = "The autoscaling group id"
  value       = aws_autoscaling_group.AutoSG.id
}

output "asg_name" {
  description = "The autoscaling group name"
  value       = aws_autoscaling_group.AutoSG.name
}

output "asg_arn" {
  description = "The ARN for this AutoScaling Group"
  value       = aws_autoscaling_group.AutoSG.arn
}

output "asg_min_size" {
  description = "The minimum size of the autoscale group"
  value       = aws_autoscaling_group.AutoSG.min_size
}

output "asg_max_size" {
  description = "The maximum size of the autoscale group"
  value       = aws_autoscaling_group.AutoSG.max_size
}

output "asg_desired_capacity" {
  description = "The number of Amazon EC2 instances that should be running in the group"
  value       = aws_autoscaling_group.AutoSG.desired_capacity
}

output "asg_default_cooldown" {
  description = "Time between a scaling activity and the succeeding scaling activity"
  value       = aws_autoscaling_group.AutoSG.default_cooldown
}

output "asg_health_check_grace_period" {
  description = "Time after instance comes into service before checking health"
  value       = aws_autoscaling_group.AutoSG.health_check_grace_period
}

output "asg_health_check_type" {
  description = "EC2 or ELB. Controls how health checking is done"
  value       = aws_autoscaling_group.AutoSG.health_check_type
}

output "asg_availability_zones" {
  description = "The availability zones of the autoscale group"
  value       = aws_autoscaling_group.AutoSG.availability_zones
}

output "asg_vpc_zone_identifier" {
  description = "The VPC zone identifier"
  value       = aws_autoscaling_group.AutoSG.vpc_zone_identifier
}

output "asg_load_balancers" {
  description = "The load balancer names associated with the autoscaling group"
  value       = aws_autoscaling_group.AutoSG.load_balancers
}

output "asg_target_group_arns" {
  description = "List of Target Group ARNs that apply to this AutoScaling Group"
  value       = aws_autoscaling_group.AutoSG.target_group_arns
}

############
## OUTPUT ##
############

output "aws_alb" {
  description = "The ALB arn"
  value       = aws_lb.alb.id
}
output "dns_name" {
  description = "The ALB dns_name"
  value       = aws_lb.alb.dns_name
}
output "zone_id" {
  description = "The ALB zone_id"
  value       = aws_lb.alb.zone_id
}
output "aws_lb_target_group" {
  description = "The TargetGroup arn"
  value       = aws_lb_target_group.tg_alb.arn
}
output "aws_alb_target_group_name" {
  value = aws_lb_target_group.tg_alb.name
}
output "alb_name" {
  value = aws_lb.alb.name
}
output "sg_alb" {
  value = aws_security_group.alb.id
}