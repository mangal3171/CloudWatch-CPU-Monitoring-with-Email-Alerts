/*output "instance_name_1" {
  value = aws_instance.this[0].tags.Name
}

output "instance_name_2" {
  value = aws_instance.this[1].tags.Name
}
*/

output "instance_name_1" {
  value = aws_instance.this.tags.Name
}


/*output "dashboard_id" {
  value = aws_cloudwatch_dashboard.dashboard.id
}*/

output "public_ip" {
  value = aws_instance.this.public_ip
}

