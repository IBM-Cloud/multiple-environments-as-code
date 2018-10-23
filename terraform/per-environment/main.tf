# a Cloud Foundry space per environment
resource "ibm_space" "space" {
  name       = "${var.environment_name}"
  org        = "${data.terraform_remote_state.global.org_name}"
  managers   = "${var.space_managers}"
  auditors   = "${var.space_auditors}"
  developers = "${var.space_developers}"
}

resource "ibm_resource_group" "group" {
  name     = "${var.environment_name}"
  quota_id = "${data.ibm_resource_quota.quota.id}"
}

# a database
resource "ibm_resource_instance" "database" {
    name              = "database"
    service           = "cloudantnosqldb"
    plan              = "${var.cloudantnosqldb_plan}"
    location          = "${var.cloudantnosqldb_location}"
    resource_group_id = "${ibm_resource_group.group.id}"
}

# a cluster
resource "ibm_container_cluster" "cluster" {
  name              = "${var.environment_name}-cluster"
  datacenter        = "${var.cluster_datacenter}"
  org_guid          = "${data.terraform_remote_state.global.org_guid}"
  space_guid        = "${ibm_space.space.id}"
  account_guid      = "${data.terraform_remote_state.global.account_guid}"
  machine_type      = "${var.cluster_machine_type}"
  worker_num        = "${var.cluster_worker_num}"
  public_vlan_id    = "${var.cluster_public_vlan_id}"
  private_vlan_id   = "${var.cluster_private_vlan_id}"
  hardware          = "${var.cluster_hardware}"
  resource_group_id = "${ibm_resource_group.group.id}"
}

# bind the database service to the cluster
resource "ibm_container_bind_service" "bind_database" {
  cluster_name_id             = "${ibm_container_cluster.cluster.id}"
  service_instance_name       = "${ibm_resource_instance.database.name}"
  namespace_id                = "default"
  account_guid                = "${data.terraform_remote_state.global.account_guid}"
  org_guid                    = "${data.terraform_remote_state.global.org_guid}"
  space_guid                  = "${ibm_space.space.id}"
  resource_group_id           = "${ibm_resource_group.group.id}"
}

# a cloud object storage

resource "ibm_resource_instance" "objectstorage" {
    name              = "objectstorage"
    service           = "cloud-object-storage"
    plan              = "${var.cloudobjectstorage_plan}"
    location          = "${var.cloudobjectstorage_location}"
    resource_group_id = "${ibm_resource_group.group.id}"
}
# bind the cloud object storage service to the cluster
resource "ibm_container_bind_service" "bind_objectstorage" {
  cluster_name_id             = "${ibm_container_cluster.cluster.id}"
  space_guid                  = "${ibm_space.space.id}"
  service_instance_id         = "${ibm_resource_instance.objectstorage.name}"
  namespace_id                = "default"
  account_guid                = "${data.terraform_remote_state.global.account_guid}"
  org_guid                    = "${data.terraform_remote_state.global.org_guid}"
  space_guid                  = "${ibm_space.space.id}"
  resource_group_id           = "${ibm_resource_group.group.id}"
}

data "ibm_resource_quota" "quota" {
name = "${var.resource_quota}"
}