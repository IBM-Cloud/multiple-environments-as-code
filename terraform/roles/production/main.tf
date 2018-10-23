
resource "ibm_iam_access_group" "operator_role" {
  name        = "${var.access_group_name_operator_role}"
  description = "${var.access_group_description}"
}

resource "ibm_iam_access_group" "pipeline_role" {
  name        = "${var.access_group_name_pipeline_role}"
  description = "${var.access_group_description}"
}
resource "ibm_iam_access_group_policy" "resourcepolicy_operator" {
  access_group_id = "${ibm_iam_access_group.operator_role.id}"
  roles           = "${var.resource_group_roles_operator}"

  resources = [{
    resource_type = "resource-group"
    resource      = "${data.terraform_remote_state.per_environment_prod.resource_group_id}"
  }]
}

resource "ibm_iam_access_group_policy" "resourcepolicy_pipeline" {
  access_group_id = "${ibm_iam_access_group.pipeline_role.id}"
  roles           = "${var.resource_group_roles_pipeline}"

  resources = [{
    resource_type = "resource-group"
    resource      = "${data.terraform_remote_state.per_environment_prod.resource_group_id}"
  }]
}

resource "ibm_iam_access_group_policy" "platformaccesspolicy" {
  access_group_id = "${ibm_iam_access_group.operator_role.id}"
  roles        = "${var.platform_access_roles}"

  resources = [{
    resource_group_id = "${data.terraform_remote_state.per_environment_prod.resource_group_id}"
  }]
}

resource "ibm_iam_access_group_policy" "monitoringpolicy" {
  access_group_id = "${ibm_iam_access_group.operator_role.id}"
  roles        = "${var.monitoring_service_roles}"

  resources = [{
    service           = "monitoring"
    resource_group_id = "${data.terraform_remote_state.per_environment_prod.resource_group_id}"
  }]
}
resource "ibm_iam_access_group_members" "operators" {
  access_group_id = "${ibm_iam_access_group.operator_role.id}"
  ibm_ids         = "${var.iam_access_members_operators}"
}

resource "ibm_iam_access_group_members" "pipeline" {
  access_group_id = "${ibm_iam_access_group.pipeline_role.id}"
  ibm_ids         = "${var.iam_access_members_pipeline}"
}