variable "ibmcloud_api_key" {
}

variable "org_name" {
}

variable "org_managers" {
  type    = list(string)
  default = []
}

variable "org_users" {
  type    = list(string)
  default = []
}

variable "org_auditors" {
  type    = list(string)
  default = []
}

variable "org_billing_managers" {
  type    = list(string)
  default = []
}

