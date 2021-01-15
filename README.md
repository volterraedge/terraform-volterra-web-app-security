# terraform-volterra-web-app-security

Sample usage

```
variable "api_url" {
  default = "https://acmecorp.console.ves.volterra.io/api"
}

variable "api_p12_file" {
  default = "acmecorp.console.api-creds.p12"
}

variable "api_cert" {
  default = ""
}

variable "api_key" {
  default = ""
}

provider "volterra" {
  api_p12_file = var.api_p12_file
  api_cert     = var.api_p12_file != "" ? "" : var.api_cert
  api_key      = var.api_p12_file != "" ? "" : var.api_key
  api_ca_cert  = var.api_ca_cert
  url          = var.api_url
}

module "wasp" {
  source = "../web-app-security"
  web_app_name = "module-wasp-test"
  volterra_namespace = "module-wasp-test"
  app_domain = "module-wasp-test.adn.helloclouds.app"
}
```