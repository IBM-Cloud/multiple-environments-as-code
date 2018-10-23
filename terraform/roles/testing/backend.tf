data "terraform_remote_state" "per_environment_test" {
  backend = "local"

  config {
    path = "${path.module}/../../per-environment/testing/terraform.tfstate"
  }
}
