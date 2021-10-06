# state output to be reused by other terraform scripts
output "resource_group_id" {
  value = ibm_resource_group.group.id
}

output "logdna_instance_id" {
  value = ibm_resource_instance.logging.id
}

output "sysdig_instance_id" {
  value = ibm_resource_instance.monitoring.id
}

#generate a property file suitable for shell scripts with useful variables relating to the environment
resource "local_file" "output" {
  content = <<EOF
  VSI_IP=${ibm_is_floating_ip.vsi1_ip.address}
EOF


  filename = "../outputs/${terraform.workspace}.env"
}

resource "local_file" "ssh-key" {
  content         = tls_private_key.ssh.private_key_pem
  filename        = "../outputs/${var.environment_name}_generated_private_key.pem"
  file_permission = "0600"
}