output "gateway_ip"   { value = module.compute.gateway_ip }
output "user_ip"      { value = module.compute.user_ip }
output "product_ip"   { value = module.compute.product_ip }
output "order_ip"     { value = module.compute.order_ip }
output "rds_endpoint" { value = module.db.rds_endpoint }
output "sqs_queue_url" { value = module.queue.queue_url }
output "sqs_dlq_url"  { value = module.queue.dlq_url }