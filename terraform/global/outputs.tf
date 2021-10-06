output "account_id" {
  value = data.ibm_iam_account_settings.iam_account_settings.account_id
}

# generate a property file suitable for shell scripts with useful variables relating to the environment
resource "local_file" "output" {
  content = <<EOF
ACCOUNT_ID=${data.ibm_iam_account_settings.iam_account_settings.account_id}
REGION=${var.region}
EOF

  filename = "../outputs/global.env"
}

