output "web_app_url" {
  value = format("https://%s", var.app_domain)
}