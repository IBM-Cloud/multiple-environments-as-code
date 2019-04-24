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
}

#######################################
# Create services in the resource group
#######################################
# a database
resource "ibm_resource_instance" "database" {
    name              = "database"
    service           = "cloudantnosqldb"
    plan              = "${var.cloudantnosqldb_plan}"
    location          = "${var.cloudantnosqldb_location}"
    resource_group_id = "${ibm_resource_group.group.id}"
}
# a cloud object storage
resource "ibm_resource_instance" "objectstorage" {
    name              = "objectstorage"
    service           = "cloud-object-storage"
    plan              = "${var.cloudobjectstorage_plan}"
    location          = "${var.cloudobjectstorage_location}"
    resource_group_id = "${ibm_resource_group.group.id}"
}

# a LogDNA service
resource "ibm_resource_instance" "logging" {
    name              = "logging"
    service           = "logdna"
    plan              = "${var.logdna_plan}"
    location          = "${var.logdna_location}"
    resource_group_id = "${ibm_resource_group.group.id}"
}

resource "ibm_resource_instance" "monitoring" {
    name              = "monitoring"
    service           = "sysdig-monitor"
    plan              = "${var.sysdig_plan}"
    location          = "${var.sysdig_location}"
    resource_group_id = "${ibm_resource_group.group.id}"
}

#############################
# Create a kubernetes cluster
#############################
# a cluster
resource "ibm_container_cluster" "cluster" {
  name              = "${var.environment_name}-cluster"
  datacenter        = "${var.cluster_datacenter}"
  org_guid          = "${data.terraform_remote_state.global.org_guid}"
  space_guid        = "${ibm_space.space.id}"
  account_guid      = "${data.terraform_remote_state.global.account_guid}"
  hardware          = "${var.cluster_hardware}"
  machine_type      = "${var.cluster_machine_type}"
  public_vlan_id    = "${var.cluster_public_vlan_id}"
  private_vlan_id   = "${var.cluster_private_vlan_id}"
  resource_group_id = "${ibm_resource_group.group.id}"
}

resource "ibm_container_worker_pool" "cluster_workerpool" {
  worker_pool_name  = "${var.environment_name}-pool"
  machine_type      = "${var.cluster_machine_type}"
  cluster           = "${ibm_container_cluster.cluster.id}"
  size_per_zone     = "${var.worker_num}"
  hardware          = "${var.cluster_hardware}"
  resource_group_id = "${ibm_resource_group.group.id}"
}

resource "ibm_container_worker_pool_zone_attachment" "cluster_zone" {
  cluster           = "${ibm_container_cluster.cluster.id}"
  worker_pool       = "${element(split("/",ibm_container_worker_pool.cluster_workerpool.id),1)}"
  zone              = "${var.cluster_datacenter}"
  public_vlan_id    = "${var.cluster_public_vlan_id}"
  private_vlan_id   = "${var.cluster_private_vlan_id}"
  resource_group_id = "${ibm_resource_group.group.id}"
}

##############################
# Bind services to the cluster
##############################
# bind the database service to the cluster
resource "ibm_container_bind_service" "bind_database" {
  cluster_name_id             = "${ibm_container_cluster.cluster.id}"
  service_instance_name       = "${ibm_resource_instance.database.name}"
  namespace_id                = "default"
  account_guid                = "${data.terraform_remote_state.global.account_guid}"
  org_guid                    = "${data.terraform_remote_state.global.org_guid}"
  space_guid                  = "${ibm_space.space.id}"
  resource_group_id           = "${ibm_resource_group.group.id}"
  role                        = "manager"
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
  role                        = "writer"
}
