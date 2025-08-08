output "instance_ips" {
  description = "Public IP addresses of created instances"
  value       = aws_instance.rundeck_nodes[*].public_ip
}

output "instance_ids" {
  description = "Instance IDs"
  value       = aws_instance.rundeck_nodes[*].id
}

output "ansible_inventory" {
  description = "Ansible inventory format"
  value = templatefile("${path.module}/inventory.tpl", {
    instances = aws_instance.rundeck_nodes
    private_key_path = var.private_key_path
    ssh_user = var.ssh_user
  })
}