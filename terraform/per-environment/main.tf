# a Cloud Foundry space per environment
resource "ibm_space" "space" {
  name       = "${var.environment_name}"
  org        = "${data.terraform_remote_state.global.org_name}"
  managers   = "${var.space_managers}"
  auditors   = "${var.space_auditors}"
  developers = "${var.space_developers}"
}

# a database
resource "ibm_service_instance" "database" {
  name       = "database"
  space_guid = "${ibm_space.space.id}"
  service    = "cloudantNoSQLDB"
  plan       = "Lite"
}

# a cluster
resource "ibm_container_cluster" "cluster" {
  name            = "${var.environment_name}-cluster"
  datacenter      = "${var.cluster_datacenter}"
  org_guid        = "${data.terraform_remote_state.global.org_guid}"
  space_guid      = "${ibm_space.space.id}"
  account_guid    = "${data.terraform_remote_state.global.account_guid}"
  machine_type    = "${var.cluster_machine_type}"
  worker_num      = "${var.cluster_worker_num}"
  public_vlan_id  = "${var.cluster_public_vlan_id}"
  private_vlan_id = "${var.cluster_private_vlan_id}"
}

# bind the database service to the cluster
resource "ibm_container_bind_service" "bind_database" {
  cluster_name_id             = "${ibm_container_cluster.cluster.id}"
  service_instance_space_guid = "${ibm_space.space.id}"
  service_instance_name_id    = "${ibm_service_instance.database.id}"
  namespace_id                = "default"
  account_guid                = "${data.terraform_remote_state.global.account_guid}"
  org_guid                    = "${data.terraform_remote_state.global.org_guid}"
  space_guid                  = "${ibm_space.space.id}"
}

# a cloud object storage
resource "ibm_service_instance" "objectstorage" {
  name       = "objectstorage"
  space_guid = "${ibm_space.space.id}"
  service    = "cloud-object-storage"

  # you can only have one Lite plan per account so let's use the Premium - it is pay-as-you-go
  plan = "Premium"
}

# bind the cloud object storage service to the cluster
resource "ibm_container_bind_service" "bind_objectstorage" {
  cluster_name_id             = "${ibm_container_cluster.cluster.id}"
  service_instance_space_guid = "${ibm_space.space.id}"
  service_instance_name_id    = "${ibm_service_instance.objectstorage.id}"
  namespace_id                = "default"
  account_guid                = "${data.terraform_remote_state.global.account_guid}"
  org_guid                    = "${data.terraform_remote_state.global.org_guid}"
  space_guid                  = "${ibm_space.space.id}"
}
