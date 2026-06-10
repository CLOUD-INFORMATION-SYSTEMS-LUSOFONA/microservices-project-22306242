output "gateway_ip"  { value = aws_instance.gateway.public_ip }
output "user_ip"     { value = aws_instance.user.public_ip }
output "product_ip"  { value = aws_instance.product.public_ip }
output "order_ip"    { value = aws_instance.order.public_ip }
output "app_sg_id"   { value = aws_security_group.app.id }
