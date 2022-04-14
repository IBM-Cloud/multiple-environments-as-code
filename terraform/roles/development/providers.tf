provider "ibm" {
  ibmcloud_api_key = var.ibmcloud_api_key
}

terraform {
  required_providers {
    ibm = {
      source  = "IBM-Cloud/ibm"
      version = ">= 1.40.1"
    }
  }
  required_version = ">= 1.1.8"

}

