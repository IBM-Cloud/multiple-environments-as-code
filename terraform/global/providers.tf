provider "ibm" {
  ibmcloud_api_key = var.ibmcloud_api_key
}

terraform {
  required_providers {
    ibm = {
      source  = "IBM-Cloud/ibm"
      version = ">= 1.13.0"
    }
  }
  required_version = ">= 0.12.24"
}

