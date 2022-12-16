terraform {
  required_providers {
    citrixadc = {
      source = "citrix/citrixadc"
    }
  }
}
provider "citrixadc" {
  endpoint = "http://172.21.14.224"
}