resource "digitalocean_container_registry" "demo-docr" {
  name                   = "spring-boot-demo-registry"
  subscription_tier_slug = "starter"
}