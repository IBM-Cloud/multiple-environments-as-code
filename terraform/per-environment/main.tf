# a Cloud Foundry space per environment
resource "ibm_space" "space" {
  name       = var.environment_name
  org        = data.terraform_remote_state.global.outputs.org_name
  managers   = var.space_managers
  auditors   = var.space_auditors
  developers = var.space_developers
}

resource "ibm_resource_group" "group" {
  name = var.environment_name
}

#######################################
# Create services in the resource group
#######################################
# a database
resource "ibm_resource_instance" "database" {
  name              = "database"
  service           = "cloudantnosqldb"
  plan              = var.cloudantnosqldb_plan
  location          = var.cloudantnosqldb_location
  resource_group_id = ibm_resource_group.group.id
}

# a cloud object storage
resource "ibm_resource_instance" "objectstorage" {
  name              = "objectstorage"
  service           = "cloud-object-storage"
  plan              = var.cloudobjectstorage_plan
  location          = var.cloudobjectstorage_location
  resource_group_id = ibm_resource_group.group.id
}

# a LogDNA service
resource "ibm_resource_instance" "logging" {
  name              = "logging"
  service           = "logdna"
  plan              = var.logdna_plan
  location          = var.logdna_location
  resource_group_id = ibm_resource_group.group.id
}

# a metrics service
resource "ibm_resource_instance" "monitoring" {
  name              = "monitoring"
  service           = "sysdig-monitor"
  plan              = var.sysdig_plan
  location          = var.sysdig_location
  resource_group_id = ibm_resource_group.group.id
}

#############################
# Create a kubernetes cluster
#############################
resource "ibm_is_vpc" "vpc1" {
  name = var.environment_name
}

resource "ibm_is_subnet" "subnet11" {
  name                     = "${var.environment_name}-1"
  vpc                      = ibm_is_vpc.vpc1.id
  zone                     = var.cluster_datacenter
  total_ipv4_address_count = 256
}

resource "ibm_container_vpc_cluster" "cluster" {
  name              = "${var.environment_name}-cluster"
  vpc_id            = ibm_is_vpc.vpc1.id
  kube_version      = "1.19"
  flavor            = var.cluster_machine_type
  worker_count      = var.worker_num
  resource_group_id = ibm_resource_group.group.id

  zones {
    subnet_id = ibm_is_subnet.subnet11.id
    name      = var.cluster_datacenter
  }
}

##############################
# Bind services to the cluster
##############################
# bind the database service to the cluster
resource "ibm_container_bind_service" "bind_database" {
  cluster_name_id       = ibm_container_vpc_cluster.cluster.id
  service_instance_name = ibm_resource_instance.database.name
  namespace_id          = "default"
  resource_group_id     = ibm_resource_group.group.id
  role                  = "manager"
}

# bind the cloud object storage service to the cluster
resource "ibm_container_bind_service" "bind_objectstorage" {
  cluster_name_id = ibm_container_vpc_cluster.cluster.id
  service_instance_id = ibm_resource_instance.objectstorage.guid
  namespace_id        = "default"
  resource_group_id   = ibm_resource_group.group.id
  role = "manager"
}
