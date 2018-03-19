# state outputs to be reused by other terraform scripts
output "org_name" {
  value = "${var.org_name}"
}

output "org_guid" {
  value = "${ibm_org.organization.id}"
}

output "account_guid" {
  value = "${data.ibm_account.account.id}"
}

# generate a property file suitable for shell scripts with useful variables relating to the environment
resource "local_file" "output" {
  content = <<EOF
ACCOUNT_GUID=${data.ibm_account.account.id}
ORG_GUID=${ibm_org.organization.id}
ORG_NAME=${var.org_name}
EOF

  filename = "../outputs/global.env"
}
