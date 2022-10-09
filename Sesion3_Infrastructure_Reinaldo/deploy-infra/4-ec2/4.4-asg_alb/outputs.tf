############
## OUTPUT ##
############
output "this_launch_configuration_id" {
  description = "The ID of the launch configuration"
  value       = aws_launch_configuration.as_conf.id
}

output "this_launch_configuration_name" {
  description = "The name of the launch configuration"
  value       = aws_launch_configuration.as_conf.name
}

output "this_autoscaling_group_id" {
  description = "The autoscaling group id"
  value       = aws_autoscaling_group.AutoSG.id
}

output "this_autoscaling_group_name" {
  description = "The autoscaling group name"
  value       = aws_autoscaling_group.AutoSG.name
}

output "this_autoscaling_group_arn" {
  description = "The ARN for this AutoScaling Group"
  value       = aws_autoscaling_group.AutoSG.arn
}

output "this_autoscaling_group_min_size" {
  description = "The minimum size of the autoscale group"
  value       = aws_autoscaling_group.AutoSG.min_size
}

output "this_autoscaling_group_max_size" {
  description = "The maximum size of the autoscale group"
  value       = aws_autoscaling_group.AutoSG.max_size
}

output "this_autoscaling_group_desired_capacity" {
  description = "The number of Amazon EC2 instances that should be running in the group"
  value       = aws_autoscaling_group.AutoSG.desired_capacity
}

output "this_autoscaling_group_default_cooldown" {
  description = "Time between a scaling activity and the succeeding scaling activity"
  value       = aws_autoscaling_group.AutoSG.default_cooldown
}

output "this_autoscaling_group_health_check_grace_period" {
  description = "Time after instance comes into service before checking health"
  value       = aws_autoscaling_group.AutoSG.health_check_grace_period
}

output "this_autoscaling_group_health_check_type" {
  description = "EC2 or ELB. Controls how health checking is done"
  value       = aws_autoscaling_group.AutoSG.health_check_type
}

output "this_autoscaling_group_availability_zones" {
  description = "The availability zones of the autoscale group"
  value       = aws_autoscaling_group.AutoSG.availability_zones
}

output "this_autoscaling_group_vpc_zone_identifier" {
  description = "The VPC zone identifier"
  value       = aws_autoscaling_group.AutoSG.vpc_zone_identifier
}

output "this_autoscaling_group_load_balancers" {
  description = "The load balancer names associated with the autoscaling group"
  value       = aws_autoscaling_group.AutoSG.load_balancers
}

output "this_autoscaling_group_target_group_arns" {
  description = "List of Target Group ARNs that apply to this AutoScaling Group"
  value       = aws_autoscaling_group.AutoSG.target_group_arns
}
