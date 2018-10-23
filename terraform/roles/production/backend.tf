data "terraform_remote_state" "per_environment_prod" {
  backend = "local"

  config {
    path = "${path.module}/../../per-environment/production/terraform.tfstate"
  }
}