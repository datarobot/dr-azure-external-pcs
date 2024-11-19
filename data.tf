data "azurerm_client_config" "current" {}
data "azurerm_subscription" "current" {}

data "azurerm_key_vault_secret" "atlas_public_key" {
  name         = "mongo-atlas-public-key"
  key_vault_id = data.azurerm_key_vault.existing.id
}

data "azurerm_key_vault_secret" "atlas_private_key" {
  name         = "mongo-atlas-private-key"
  key_vault_id = data.azurerm_key_vault.existing.id
}
