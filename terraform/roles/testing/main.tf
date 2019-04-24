################################################
# Developer role access group and access policies
################################################
resource "ibm_iam_access_group" "developer_role" {
  name        = "${var.access_group_name_developer_role}"
  description = "${var.access_group_description}"
}

resource "ibm_iam_access_group_policy" "resourcepolicy_developer" {
  access_group_id = "${ibm_iam_access_group.developer_role.id}"
  roles           = ["Viewer"]

  resources = [{
    resource_type = "resource-group"
    resource      = "${data.terraform_remote_state.per_environment_test.resource_group_id}"
  }]
}

resource "ibm_iam_access_group_policy" "developer_logging_policy" {
  access_group_id = "${ibm_iam_access_group.developer_role.id}"
  roles           = ["Writer"]

  resources = [{
    service           = "logdna"
    resource_instance_id = "${data.terraform_remote_state.per_environment_dev.logdna_instance_id}"
  }]
}
resource "ibm_iam_access_group_policy" "developer_monitoring_policy" {
  access_group_id = "${ibm_iam_access_group.developer_role.id}"
  roles           = ["Writer"]

  resources = [{
    service           = "sysdig-monitor"
    resource_instance_id = "${data.terraform_remote_state.per_environment_dev.sysdig_instance_id}"
  }]
}

resource "ibm_iam_access_group_members" "developers" {
  access_group_id = "${ibm_iam_access_group.developer_role.id}"
  ibm_ids         = "${var.iam_access_members_developers}"
}

################################################
# Tester role access group and access policies
################################################

resource "ibm_iam_access_group" "tester_role" {
  name        = "${var.access_group_name_tester_role}"
  description = "${var.access_group_description}"
}

resource "ibm_iam_access_group_members" "testers" {
  access_group_id = "${ibm_iam_access_group.tester_role.id}"
  ibm_ids         = "${var.iam_access_members_testers}"
}

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
    resource      = "${data.terraform_remote_state.per_environment_test.resource_group_id}"
  }]
}

resource "ibm_iam_access_group_policy" "operator_logging_policy" {
  access_group_id = "${ibm_iam_access_group.operator_role.id}"
  roles           = ["Writer"]

  resources = [{
    service           = "logdna"
    resource_instance_id = "${data.terraform_remote_state.per_environment_prod.logdna_instance_id}"
  }]
}
resource "ibm_iam_access_group_policy" "operator_monitoring_policy" {
  access_group_id = "${ibm_iam_access_group.operator_role.id}"
  roles           = ["Writer"]

  resources = [{
    service           = "sysdig-monitor"
    resource_instance_id = "${data.terraform_remote_state.per_environment_prod.sysdig_instance_id}"
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
    resource      = "${data.terraform_remote_state.per_environment_test.resource_group_id}"
  }]
}

resource "ibm_iam_access_group_members" "pipeline" {
  access_group_id = "${ibm_iam_access_group.pipeline_role.id}"
  ibm_ids         = "${var.iam_access_members_pipeline}"
}