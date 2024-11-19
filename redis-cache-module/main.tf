resource "azurerm_redis_cache" "redis" {
  name                = "${var.project_name}-dmaic"
  location            = var.resource_group.location
  resource_group_name = var.resource_group.name
  capacity            = 4
  family              = "C"
  sku_name            = "Standard"
  enable_non_ssl_port = true
  minimum_tls_version = "1.2"

  public_network_access_enabled = false

  redis_version = 6

  redis_configuration {
    enable_authentication = true
  }

  tags = var.tags

}

#tfsec:ignore:azure-keyvault-ensure-secret-expiry
resource "azurerm_key_vault_secret" "redistoken" {
  name         = "${var.project_name}-redis-password"
  value        = azurerm_redis_cache.redis.primary_access_key
  key_vault_id = var.key_vault_id

  tags = var.tags
}

resource "azurerm_private_endpoint" "redis" {
  name                = "${var.project_name}-redis"
  location            = var.resource_group.location
  resource_group_name = var.resource_group.name
  subnet_id           = var.subnet_id
  tags                = var.tags

  private_service_connection {
    name                           = "rediscache-${var.project_name}"
    is_manual_connection           = false
    private_connection_resource_id = azurerm_redis_cache.redis.id
    subresource_names              = ["redisCache"]
  }
}

data "azurerm_private_endpoint_connection" "redis_ip" {
  name                = azurerm_private_endpoint.redis.name
  resource_group_name = var.resource_group.name
}

resource "azurerm_private_dns_zone" "redis" {
  name                = "privatelink.redis.cache.windows.net"
  resource_group_name = var.resource_group.name
  tags                = var.tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "redis" {
  name                  = "${var.project_name}-redis"
  resource_group_name   = var.resource_group.name
  private_dns_zone_name = azurerm_private_dns_zone.redis.name
  virtual_network_id    = var.network_id
  tags                  = var.tags
}

resource "azurerm_private_dns_a_record" "redis" {
  name                = azurerm_redis_cache.redis.name
  zone_name           = azurerm_private_dns_zone.redis.name
  resource_group_name = var.resource_group.name
  ttl                 = 300
  records             = [data.azurerm_private_endpoint_connection.redis_ip.private_service_connection.0.private_ip_address]
}
