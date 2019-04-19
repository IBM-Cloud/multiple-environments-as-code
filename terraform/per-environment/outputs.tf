# state output to be reused by other terraform scripts
output "resource_group_id" {
  value = "${ibm_resource_group.group.id}"
}

output "logdna_instance_id" {
  value = "${ibm_resource_instance.logging.id}"
}

output "sysdig_instance_id" {
  value = "${ibm_resource_instance.monitoring.id}"
}
#generate a property file suitable for shell scripts with useful variables relating to the environment
resource "local_file" "output" {
  content = <<EOF
CLUSTER_NAME=${ibm_container_cluster.cluster.name}
CLUSTER_ID=${ibm_container_cluster.cluster.id}
CLUSTER_INGRESS_HOSTNAME=${ibm_container_cluster.cluster.ingress_hostname}
EOF

  filename = "../outputs/${terraform.workspace}.env"
}
