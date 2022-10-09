# output "aurora-endpoint" {
#   value = "${module.aurora.this_rds_cluster_instance_endpoints[0]}"
# }
output "rds_cluster_id" {
  value = module.aurora.rds_cluster_id
}