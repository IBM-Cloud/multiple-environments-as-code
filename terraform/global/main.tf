# create a new organization for the project
resource "ibm_org" "organization" {
  name             = "${var.org_name}"
  managers         = "${var.org_managers}"
  users            = "${var.org_users}"
  auditors         = "${var.org_auditors}"
  billing_managers = "${var.org_billing_managers}"
}

# retrieve the account where the org was created
data "ibm_account" "account" {
  org_guid = "${ibm_org.organization.id}"
}
