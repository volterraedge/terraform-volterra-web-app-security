variable "web_app_name" {
  type        = string
  description = "Web App Name. Also used as a prefix in names of related resources."
}

variable "volterra_namespace_exists" {
  type        = string
  description = "Flag to create or use existing volterra namespace"
  default     = false
}

variable "volterra_namespace" {
  type        = string
  description = "Volterra app namespace where the object will be created. This cannot be system or shared ns."
}

variable "origin_server_dns_name" {
  type        = string
  description = "Origin server's publicly resolvable dns name"
  default     = "www.f5.com"
}

variable "origin_server_sni" {
  type        = string
  description = "Origin server's SNI value"
  default     = ""
}

variable "app_domain" {
  type        = string
  description = "FQDN for the app. If you have delegated domain `prod.example.com`, then your app_domain can be `<app_name>.prod.example.com`"
}

variable "enable_hsts" {
  type        = bool
  description = "Flag to enable hsts for HTTPS loadbalancer"
  default     = false
}

variable "enable_redirect" {
  type        = bool
  description = "Flag to enable http redirect to HTTPS loadbalancer"
  default     = true
}

variable "js_script_delay" {
  type        = number
  description = "Javascript challenge delay in miliseconds"
  default     = 5000
}

variable "js_cookie_expiry" {
  type        = number
  description = "Javascript cookie expiry time in seconds"
  default     = 3600
}

variable "disable_js_challenge" {
  type        = bool
  description = "disable javascript challenge"
  default     = false
}