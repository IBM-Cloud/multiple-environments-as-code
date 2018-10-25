data "terraform_remote_state" "per_environment_dev" {
  backend = "local"

  config {
    path = "${path.module}/../../per-environment/terraform.tfstate.d/development/terraform.tfstate"
  }
}
