variable "ibmcloud_api_key" {}

variable "environment_name" {}

variable "space_managers" {
  type    = "list"
  default = []
}

variable "space_auditors" {
  type    = "list"
  default = []
}

variable "space_developers" {
  type    = "list"
  default = []
}

variable "cluster_datacenter" {}

variable "cluster_public_vlan_id" {}

variable "cluster_private_vlan_id" {}

variable "cluster_machine_type" {}

variable "cluster_workers" {
  type = "list"
}
