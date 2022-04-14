variable "ibmcloud_api_key" {}
variable "access_group_name_developer_role" {}

variable "access_group_name_tester_role" {}

variable "access_group_name_operator_role" {}

variable "access_group_name_pipeline_role" {}

variable "access_group_description" {
  type    = string
  default = "used by the multiple-environments-as-code tutorial"
}

variable "iam_access_members_developers" {
  type    = list(any)
  default = []
}

variable "iam_access_members_testers" {
  type    = list(any)
  default = []
}

variable "iam_access_members_operators" {
  type    = list(any)
  default = []
}

variable "iam_access_members_pipeline" {
  type    = list(any)
  default = []
}

variable "resource_group_roles_developer" {
  type    = list(any)
  default = []
}

variable "resource_group_roles_operator" {
  type    = list(any)
  default = []
}

variable "resource_group_roles_tester" {
  type    = list(any)
  default = []
}

variable "resource_group_roles_pipeline" {
  type    = list(any)
  default = []
}

variable "platform_access_roles" {
  type    = list(any)
  default = []
}

variable "monitoring_service_roles" {
  type    = list(any)
  default = []
}
