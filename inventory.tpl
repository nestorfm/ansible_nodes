[rundeck_nodes]
%{ for instance in instances ~}
${instance.tags.Name} ansible_host=${instance.public_ip} ansible_user=${ssh_user} ansible_ssh_private_key_file=${private_key_path} ansible_python_interpreter=auto_silent
%{ endfor ~}

[rundeck_nodes:vars]
ansible_ssh_common_args='-o StrictHostKeyChecking=no'