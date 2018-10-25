################################################
# Operator role access group and access policies
################################################
resource "ibm_iam_access_group" "operator_role" {
  name        = "${var.access_group_name_operator_role}"
  description = "${var.access_group_description}"
}

resource "ibm_iam_access_group_policy" "resourcepolicy_operator" {
  access_group_id = "${ibm_iam_access_group.operator_role.id}"
  roles           = ["Viewer"]

  resources = [{
    resource_type = "resource-group"
    resource      = "${data.terraform_remote_state.per_environment_prod.resource_group_id}"
  }]
}

resource "ibm_iam_access_group_policy" "operator_platform_accesspolicy" {
  access_group_id = "${ibm_iam_access_group.operator_role.id}"
  roles        = ["Operator","Viewer"]

  resources = [{
    resource_group_id = "${data.terraform_remote_state.per_environment_prod.resource_group_id}"
  }]
}

resource "ibm_iam_access_group_policy" "operator_monitoring_policy" {
  access_group_id = "${ibm_iam_access_group.operator_role.id}"
  roles        =  ["Administrator","Operator","Viewer"]

  resources = [{
    service           = "monitoring"
    resource_group_id = "${data.terraform_remote_state.per_environment_prod.resource_group_id}"
  }]
}

resource "ibm_iam_access_group_members" "operators" {
  access_group_id = "${ibm_iam_access_group.operator_role.id}"
  ibm_ids         = "${var.iam_access_members_operators}"
}


################################################
# Pipeline role access group and access policies
################################################

resource "ibm_iam_access_group" "pipeline_role" {
  name        = "${var.access_group_name_pipeline_role}"
  description = "${var.access_group_description}"
}


resource "ibm_iam_access_group_policy" "resourcepolicy_pipeline" {
  access_group_id = "${ibm_iam_access_group.pipeline_role.id}"
  roles           = ["Viewer"]

  resources = [{
    resource_type = "resource-group"
    resource      = "${data.terraform_remote_state.per_environment_prod.resource_group_id}"
  }]
}

resource "ibm_iam_access_group_members" "pipeline" {
  access_group_id = "${ibm_iam_access_group.pipeline_role.id}"
  ibm_ids         = "${var.iam_access_members_pipeline}"
}