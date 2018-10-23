
variable "access_group_name_operator_role" {}

variable "access_group_name_pipeline_role" {}

variable "access_group_description" {
  type = "string"
  default = "used by the multiple-environments-as-code tutorial"
}

variable "iam_access_members_operators"{
  type = "list"
  default = []
}

variable "iam_access_members_pipeline"{
  type = "list"
  default = []
}

variable "resource_group_roles_operator"{
  type = "list"
  default = []
}

variable "resource_group_roles_pipeline"{
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