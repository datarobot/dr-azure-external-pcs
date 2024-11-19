resource "azurerm_postgresql_flexible_server" "postgres_instance" {
  name                = var.project_name
  location            = var.resource_group.location
  resource_group_name = var.resource_group.name

  version             = "12"
  delegated_subnet_id = var.subnet_id
  private_dns_zone_id = azurerm_private_dns_zone.postgres_dns_zone.id

  administrator_login    = "postgres"
  administrator_password = random_password.postgres.result

  storage_mb        = var.disk_size
  auto_grow_enabled = true

  sku_name = var.db_instance_sku
  # TODO: Get this dynamically
  zone = 2

  high_availability {
    mode = "ZoneRedundant"
    # TODO: Get this dynamically
    standby_availability_zone = 1
  }

  backup_retention_days = 30

  maintenance_window {
    # Monday
    day_of_week = 0
    # Midnight
    start_hour = 00
  }

  tags = var.tags

  depends_on = [
    azurerm_private_dns_zone_virtual_network_link.postgres_dns_link
  ]
}

resource "azurerm_postgresql_flexible_server_configuration" "postgresql_extensions" {
  name      = "azure.extensions"
  server_id = azurerm_postgresql_flexible_server.postgres_instance.id
  value     = "PLPGSQL,PG_STAT_STATEMENTS"
}

resource "azurerm_private_dns_zone" "postgres_dns_zone" {
  name                = "sts.${var.project_name}.postgres.database.azure.com"
  resource_group_name = var.resource_group.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "postgres_dns_link" {
  name                  = "${var.project_name}-postgres"
  resource_group_name   = var.resource_group.name
  private_dns_zone_name = azurerm_private_dns_zone.postgres_dns_zone.name
  virtual_network_id    = var.network_id

  tags = var.tags
}
