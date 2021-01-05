data "terraform_remote_state" "per_environment_test" {
  backend = "local"

  config = {
    path = "${path.module}/../../per-environment/terraform.tfstate.d/testing/terraform.tfstate"
  }
}
