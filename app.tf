data "volterra_namespace" "this" {
  count = var.volterra_namespace_exists ? 1 : 0
  name  = var.volterra_namespace
}

resource "volterra_namespace" "this" {
  count = var.volterra_namespace_exists ? 0 : 1
  name  = var.volterra_namespace
}

resource "volterra_origin_pool" "this" {
  name                   = format("%s-server", var.web_app_name)
  namespace              = local.namespace
  description            = format("Origin pool pointing to origin server %s", var.origin_server_dns_name)
  loadbalancer_algorithm = "ROUND ROBIN"
  origin_servers {
    public_name {
      dns_name = var.origin_server_dns_name
    }
  }
  port               = 443
  endpoint_selection = "LOCAL_PREFERRED"
  use_tls {
    no_mtls                  = true
    volterra_trusted_ca      = true
    skip_server_verification = false

    disable_sni            = false
    use_host_header_as_sni = false
    sni                    = var.origin_server_sni != "" ? var.origin_server_sni : var.origin_server_dns_name
    tls_config {
      default_security = true
      low_security     = false
      medium_security  = false
    }
  }
}

resource "volterra_waf" "this" {
  name        = format("%s-waf", var.web_app_name)
  description = format("WAF in block mode for %s", var.web_app_name)
  namespace   = local.namespace
  app_profile {
    cms       = []
    language  = []
    webserver = []
  }
  mode = "BLOCK"
  lifecycle {
    ignore_changes = [
      app_profile
    ]
  }
}

resource "volterra_http_loadbalancer" "this" {
  name                            = format("%s-lb", var.web_app_name)
  namespace                       = local.namespace
  description                     = format("HTTPS loadbalancer object for %s origin server", var.web_app_name)
  domains                         = [var.app_domain]
  advertise_on_public_default_vip = true
  default_route_pools {
    pool {
      name      = volterra_origin_pool.this.name
      namespace = local.namespace
    }
  }
  https_auto_cert {
    add_hsts      = var.enable_hsts
    http_redirect = var.enable_redirect
  }
  waf {
    name      = volterra_waf.this.name
    namespace = local.namespace
  }
  disable_waf                     = false
  disable_rate_limit              = true
  round_robin                     = true
  service_policies_from_namespace = true
  no_challenge                    = false
  js_challenge {
    enable_js_challenge = true
    js_script_delay     = var.js_script_delay
    cookie_expiry       = var.js_cookie_expiry
  }
}

