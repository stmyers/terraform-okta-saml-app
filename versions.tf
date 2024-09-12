terraform {
  required_providers {
    okta = {
      source  = "okta/okta"
      version = "~> 4.0"
    }
  }
  required_version = ">= 0.14.7"
}
