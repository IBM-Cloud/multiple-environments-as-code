data "terraform_remote_state" "per_environment_prod" {
  backend = "local"

  config = {
    path = "${path.module}/../../per-environment/terraform.tfstate.d/production/terraform.tfstate"
  }
}
