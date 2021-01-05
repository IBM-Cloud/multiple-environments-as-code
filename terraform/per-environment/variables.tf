variable "ibmcloud_api_key" {
}

variable "environment_name" {
}

variable "space_managers" {
  type    = list(string)
  default = []
}

variable "space_auditors" {
  type    = list(string)
  default = []
}

variable "space_developers" {
  type    = list(string)
  default = []
}

variable "region" {
}

variable "cluster_datacenter" {
}


variable "cluster_machine_type" {
}

variable "worker_num" {
}

variable "cloudantnosqldb_plan" {
}

variable "cloudantnosqldb_location" {
}

variable "cloudobjectstorage_plan" {
}

variable "cloudobjectstorage_location" {
}

variable "logdna_plan" {
}

variable "logdna_location" {
}

variable "sysdig_plan" {
}

variable "sysdig_location" {
}

