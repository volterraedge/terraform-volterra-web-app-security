# terraform-volterra-web-app-security

[![Lint Status](https://github.com/volterraedge/terraform-volterra-web-app-security/workflows/Lint/badge.svg)](https://github.com/volterraedge/terraform-volterra-web-app-security/actions)
[![LICENSE](https://img.shields.io/github/license/volterraedge/terraform-volterra-web-app-security)](https://github.com/volterraedge/terraform-volterra-web-app-security/blob/main/LICENSE)

This is a terraform module to create Volterra's Web Application Security usecase. Read the [Web Appplication Security usecase guide](https://volterra.io/docs/quick-start/web-app-security-performance) to learn more.

---

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

* Download Volterra API credentials file

  Follow the steps under section `Generate API Certificate` from [how to manage credentials doc](https://volterra.io/docs/how-to/user-mgmt/credentials)


* Export the API certificate password as environment variable

  ```bash
  export VES_P12_PASSWORD=<your credential password>
  ```

* Setup domain delegation

  Follow steps from this [link](https://volterra.io/docs/how-to/app-networking/domain-delegation) to create domain delegation.

---

## Usage Example

```hcl
terraform {
  required_providers {
    volterra = {
      source = "volterraedge/volterra"
      version = "0.0.6"
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
  version            = "0.0.3"
  web_app_name       = var.name
  volterra_namespace = var.name
  app_domain         = var.domain_name
}

output "web_app_url" {
  value = module.web-app-security.app_url
}
```
---
## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.12.9, != 0.13.0 |
| volterra | 0.0.6 |

## Providers

| Name | Version |
|------|---------|
| volterra | 0.0.6 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| app\_domain | FQDN for the app. If you have delegated domain `prod.example.com`, then your app\_domain can be `<app_name>.prod.example.com` | `string` | n/a | yes |
| enable\_hsts | Flag to enable hsts for HTTPS loadbalancer | `bool` | `false` | no |
| enable\_redirect | Flag to enable http redirect to HTTPS loadbalancer | `bool` | `true` | no |
| js\_cookie\_expiry | Javascript cookie expiry time in seconds | `number` | `3600` | no |
| js\_script\_delay | Javascript challenge delay in miliseconds | `number` | `5000` | no |
| origin\_server\_dns\_name | Origin server's publicly resolvable dns name | `string` | `"www.f5.com"` | no |
| origin\_server\_sni | Origin server's SNI value | `string` | `""` | no |
| volterra\_namespace | Volterra app namespace where the object will be created. This cannot be system or shared ns. | `string` | n/a | yes |
| volterra\_namespace\_exists | Flag to create or use existing volterra namespace | `string` | `false` | no |
| web\_app\_name | Web App Name. Also used as a prefix in names of related resources. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| app\_url | Domain VIP to access the web app |

