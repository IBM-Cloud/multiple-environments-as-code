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

variable "cluster_worker_num" {}

variable "cluster_hardware" {}

variable "resource_quota" {}

variable "access_group_name" {}

variable "access_group_description" {
  type = "string"
  default = "used by the multiple-environments-as-code tutorial"
}

variable "iam_access_members"{
  type = "list"
  default = []
}

variable "resource_group_roles"{
  type = "list"
  default = []
}

variable "platform_access_roles"{
  type = "list"
  default = []
}

variable "monitoring_service_roles"{
  type = "list"
  default = []
}