# terraform-volterra-web-app-security

[![Lint Status](https://github.com/volterraedge/terraform-volterra-web-app-security/workflows/Lint/badge.svg)](https://github.com/volterraedge/terraform-volterra-web-app-security/actions)
[![LICENSE](https://img.shields.io/github/license/volterraedge/terraform-volterra-web-app-security)](https://github.com/volterraedge/terraform-volterra-web-app-security/blob/main/LICENSE)

This is a terraform module to create Volterra's Web Application Security usecase. Read the [Web Appplication Security usecase guide](https://volterra.io/docs/quick-start/web-app-security-performance) to learn more.


## Assumptions:

* You already have signed up for Volterra account. If not, use this link to [signup](https://console.ves.volterra.io/signup/)

---

## Prerequisites

* Install terraform

  For homebrew installed on macos, run below command to install terraform. For rest of the os follow the instructions from [this link](https://learn.hashicorp.com/tutorials/terraform/install-cli) to install terraform

  ```bash
  $ brew tap hashicorp/tap
  $ brew install hashicorp/tap/terraform

  # to update
  $ brew upgrade hashicorp/tap/terraform
  ```

* Download Volterra API credential file

  Follow the steps under section `Generate API Certificate` from [how to manage crecredentials doc](https://volterra.io/docs/how-to/user-mgmt/credentials)


* Export the API certificate password as environment variable

  ```bash
  export VES_P12_PASSWORD=<your credential password>
  ```


## Usage Example

```hcl
terraform {
  required_providers {
    volterra = {
      source = "volterraedge/volterra"
      version = "0.0.5"
    }
  }
}

variable "api_url" {
  default = "https://acmecorp.console.ves.volterra.io/api"
}

variable "api_p12_file" {
  default = "acmecorp.console.api-creds.p12"
}

provider "volterra" {
  api_p12_file = var.api_p12_file
  url          = var.api_url
}

module "web-app-security" {
  source             = "volterraedge/web-app-security/volterra"
  version            = "0.0.2"
  web_app_name       = var.name
  volterra_namespace = var.name
  app_domain         = var.domain_name
}

output "web_app_url" {
  value = module.web-app-security.web_app_url
}
```

