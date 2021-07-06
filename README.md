# terraform-volterra-web-app-security

[![Lint Status](https://github.com/volterraedge/terraform-volterra-web-app-security/workflows/Lint/badge.svg)](https://github.com/volterraedge/terraform-volterra-web-app-security/actions)
[![LICENSE](https://img.shields.io/github/license/volterraedge/terraform-volterra-web-app-security)](https://github.com/volterraedge/terraform-volterra-web-app-security/blob/main/LICENSE)

This is a terraform module to create Volterra's Web Application Security usecase. Read the [Web Appplication Security usecase guide](https://volterra.io/docs/quick-start/web-app-security-performance) to learn more.

---

## Overview

![Image of WAS Usecase](https://volterra.io/static/b1b58dbfa0234c06ffab28c64d38629b/5acad/top-wasp-new.webp)

---

## Prerequisites

### Volterra Account

* Signup For Volterra Account

  If you don't have a Volterra account. Please follow this link to [signup](https://console.ves.volterra.io/signup/)

* Download Volterra API credentials file

  Follow [how to generate API Certificate](https://volterra.io/docs/how-to/user-mgmt/credentials) to create API credentials

* Setup domain delegation

  Follow steps from this [link](https://volterra.io/docs/how-to/app-networking/domain-delegation) to create domain delegation

### Command Line Tools

* Install terraform

  For homebrew installed on macos, run below command to install terraform. For rest of the os follow the instructions from [this link](https://learn.hashicorp.com/tutorials/terraform/install-cli) to install terraform

  ```bash
  $ brew tap hashicorp/tap
  $ brew install hashicorp/tap/terraform

  # to update
  $ brew upgrade hashicorp/tap/terraform
  ```

* Export the API certificate password as environment variable

  ```bash
  export VES_P12_PASSWORD=<your credential password>
  ```

---

## Usage Example

```hcl
terraform {
  required_providers {
    volterra = {
      source = "volterraedge/volterra"
      version = "0.3.0"
    }
  }
}

variable "api_url" {
  #--- UNCOMMENT FOR TEAM OR ORG TENANTS
  # default = "https://<TENANT-NAME>.console.ves.volterra.io/api"
  #--- UNCOMMENT FOR INDIVIDUAL/FREEMIUM
  # default = "https://console.ves.volterra.io/api"
}

# This points the absolute path of the api credentials file you downloaded from Volterra
variable "api_p12_file" {
  default = "path/to/your/api-creds.p12"
}

variable "app_fqdn" {}

variable "namespace" {
  default = ""
}

variable "disable_js_challenge" {
  default = false
}

variable "name" {}

locals{
  namespace = var.namespace != "" ? var.namespace : var.name
}

provider "volterra" {
  api_p12_file = var.api_p12_file
  url          = var.api_url
}

module "web-app-security" {
  source               = "volterraedge/web-app-security/volterra"
  web_app_name         = var.name
  volterra_namespace   = local.namespace
  app_domain           = var.app_fqdn
  disable_js_challenge = var.disable_js_challenge
}

output "web_app_url" {
  value = module.web-app-security.app_url
}
```
---

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13.1 |
| <a name="requirement_volterra"></a> [volterra](#requirement\_volterra) | 0.3.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_volterra"></a> [volterra](#provider\_volterra) | 0.3.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [volterra_http_loadbalancer.this](https://registry.terraform.io/providers/volterraedge/volterra/0.3.0/docs/resources/http_loadbalancer) | resource |
| [volterra_namespace.this](https://registry.terraform.io/providers/volterraedge/volterra/0.3.0/docs/resources/namespace) | resource |
| [volterra_origin_pool.this](https://registry.terraform.io/providers/volterraedge/volterra/0.3.0/docs/resources/origin_pool) | resource |
| [volterra_waf.this](https://registry.terraform.io/providers/volterraedge/volterra/0.3.0/docs/resources/waf) | resource |
| [volterra_namespace.this](https://registry.terraform.io/providers/volterraedge/volterra/0.3.0/docs/data-sources/namespace) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_app_domain"></a> [app\_domain](#input\_app\_domain) | FQDN for the app. If you have delegated domain `prod.example.com`, then your app\_domain can be `<app_name>.prod.example.com` | `string` | n/a | yes |
| <a name="input_disable_js_challenge"></a> [disable\_js\_challenge](#input\_disable\_js\_challenge) | disable javascript challenge | `bool` | `false` | no |
| <a name="input_enable_hsts"></a> [enable\_hsts](#input\_enable\_hsts) | Flag to enable hsts for HTTPS loadbalancer | `bool` | `false` | no |
| <a name="input_enable_redirect"></a> [enable\_redirect](#input\_enable\_redirect) | Flag to enable http redirect to HTTPS loadbalancer | `bool` | `true` | no |
| <a name="input_js_cookie_expiry"></a> [js\_cookie\_expiry](#input\_js\_cookie\_expiry) | Javascript cookie expiry time in seconds | `number` | `3600` | no |
| <a name="input_js_script_delay"></a> [js\_script\_delay](#input\_js\_script\_delay) | Javascript challenge delay in miliseconds | `number` | `5000` | no |
| <a name="input_origin_server_dns_name"></a> [origin\_server\_dns\_name](#input\_origin\_server\_dns\_name) | Origin server's publicly resolvable dns name | `string` | `"www.f5.com"` | no |
| <a name="input_origin_server_sni"></a> [origin\_server\_sni](#input\_origin\_server\_sni) | Origin server's SNI value | `string` | `""` | no |
| <a name="input_volterra_namespace"></a> [volterra\_namespace](#input\_volterra\_namespace) | Volterra app namespace where the object will be created. This cannot be system or shared ns. | `string` | n/a | yes |
| <a name="input_volterra_namespace_exists"></a> [volterra\_namespace\_exists](#input\_volterra\_namespace\_exists) | Flag to create or use existing volterra namespace | `string` | `false` | no |
| <a name="input_web_app_name"></a> [web\_app\_name](#input\_web\_app\_name) | Web App Name. Also used as a prefix in names of related resources. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_app_url"></a> [app\_url](#output\_app\_url) | Domain VIP to access the web app |
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13.1 |
| <a name="requirement_volterra"></a> [volterra](#requirement\_volterra) | 0.3.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_volterra"></a> [volterra](#provider\_volterra) | 0.3.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [volterra_http_loadbalancer.this](https://registry.terraform.io/providers/volterraedge/volterra/0.3.0/docs/resources/http_loadbalancer) | resource |
| [volterra_namespace.this](https://registry.terraform.io/providers/volterraedge/volterra/0.3.0/docs/resources/namespace) | resource |
| [volterra_origin_pool.this](https://registry.terraform.io/providers/volterraedge/volterra/0.3.0/docs/resources/origin_pool) | resource |
| [volterra_waf.this](https://registry.terraform.io/providers/volterraedge/volterra/0.3.0/docs/resources/waf) | resource |
| [volterra_namespace.this](https://registry.terraform.io/providers/volterraedge/volterra/0.3.0/docs/data-sources/namespace) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_app_domain"></a> [app\_domain](#input\_app\_domain) | FQDN for the app. If you have delegated domain `prod.example.com`, then your app\_domain can be `<app_name>.prod.example.com` | `string` | n/a | yes |
| <a name="input_disable_js_challenge"></a> [disable\_js\_challenge](#input\_disable\_js\_challenge) | disable javascript challenge | `bool` | `false` | no |
| <a name="input_enable_hsts"></a> [enable\_hsts](#input\_enable\_hsts) | Flag to enable hsts for HTTPS loadbalancer | `bool` | `false` | no |
| <a name="input_enable_redirect"></a> [enable\_redirect](#input\_enable\_redirect) | Flag to enable http redirect to HTTPS loadbalancer | `bool` | `true` | no |
| <a name="input_js_cookie_expiry"></a> [js\_cookie\_expiry](#input\_js\_cookie\_expiry) | Javascript cookie expiry time in seconds | `number` | `3600` | no |
| <a name="input_js_script_delay"></a> [js\_script\_delay](#input\_js\_script\_delay) | Javascript challenge delay in miliseconds | `number` | `5000` | no |
| <a name="input_origin_server_dns_name"></a> [origin\_server\_dns\_name](#input\_origin\_server\_dns\_name) | Origin server's publicly resolvable dns name | `string` | `"www.f5.com"` | no |
| <a name="input_origin_server_sni"></a> [origin\_server\_sni](#input\_origin\_server\_sni) | Origin server's SNI value | `string` | `""` | no |
| <a name="input_volterra_namespace"></a> [volterra\_namespace](#input\_volterra\_namespace) | Volterra app namespace where the object will be created. This cannot be system or shared ns. | `string` | n/a | yes |
| <a name="input_volterra_namespace_exists"></a> [volterra\_namespace\_exists](#input\_volterra\_namespace\_exists) | Flag to create or use existing volterra namespace | `string` | `false` | no |
| <a name="input_web_app_name"></a> [web\_app\_name](#input\_web\_app\_name) | Web App Name. Also used as a prefix in names of related resources. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_app_url"></a> [app\_url](#output\_app\_url) | Domain VIP to access the web app |
