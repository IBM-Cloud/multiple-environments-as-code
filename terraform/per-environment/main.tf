# new resource group for the environment
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
# Create a VPC with a VSI
#############################
resource "ibm_is_vpc" "vpc1" {
  name              = var.environment_name
  resource_group    = ibm_resource_group.group.id
}

resource "ibm_is_subnet" "subnet11" {
  name                     = "${var.environment_name}-1"
  vpc                      = ibm_is_vpc.vpc1.id
  zone                     = var.network_zone
  total_ipv4_address_count = 256
}

# Image type for the VSI
data "ibm_is_image" "vsi_image" {
  name = "ibm-ubuntu-18-04-1-minimal-amd64-2"
}

# Generate a private / public key for ssh access to the VSI.
# See outputs.tf for how the key is exported.
resource "tls_private_key" "ssh" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "ibm_is_ssh_key" "generated_key" {
  name           = "${var.environment_name}-key"
  public_key     = tls_private_key.ssh.public_key_openssh
  resource_group = ibm_resource_group.group.id
}

output "generated_key" {
  value     = ibm_is_ssh_key.generated_key
  sensitive = true
}

# The VSI
resource "ibm_is_instance" "vsi1" {
  name           = "${var.environment_name}-vsi1"
  vpc            = ibm_is_vpc.vpc1.id
  zone           = "${var.region}-1"
  profile        = "cx2-2x4"
  image          = data.ibm_is_image.vsi_image.id
  keys           = [ibm_is_ssh_key.generated_key.id]
  resource_group = ibm_resource_group.group.id
  
  primary_network_interface {
    subnet = ibm_is_subnet.subnet11.id
  }

}

# Add a floating IP address
resource "ibm_is_floating_ip" "vsi1_ip" {
  name           = "${var.environment_name}-vsi1-ip"
  target         = ibm_is_instance.vsi1.primary_network_interface.0.id
  resource_group = ibm_resource_group.group.id
}

# Add a rule to the default security group to allow ssh-based access
resource "ibm_is_security_group_rule" "vsi1_ssh_rule" {
  group     = ibm_is_vpc.vpc1.default_security_group
  direction = "inbound"
  remote    = "0.0.0.0/0"
  tcp {
    port_min = 22
    port_max = 22
  }
}