resource "azurerm_resource_group" "demo-rg" {
  name = var.resource_group_name
  location = var.resource_group_location
  tags = local.commontags
}

resource "azurerm_virtual_network" "demo-vnet" {
  name = var.vnet_name
  location = var.resource_group_location
  resource_group_name = azurerm_resource_group.demo-rg.name
  address_space = var.address_space_list
  tags = local.commontags
}

resource "azurerm_subnet" "demo-subnet" {
  name = var.subnet_name
  resource_group_name = azurerm_resource_group.demo-rg.name
  virtual_network_name = azurerm_virtual_network.demo-vnet.name
  address_prefixes = var.subnet_address_prefixes

}

resource "azurerm_network_security_group" "demo-nsg" {
  name = var.nsg_name
  location = var.resource_group_location
  resource_group_name = azurerm_resource_group.demo-rg.name
}

resource "azurerm_network_security_rule" "demo" {
  depends_on = [
    azurerm_network_security_group.demo-nsg
  ]
  for_each = local.web_inbound_ports_map
  name                        = "rule-${each.value}"
  priority                    = each.key
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = each.value
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.demo-rg.name
  network_security_group_name = azurerm_network_security_group.demo-nsg.name
}

resource "azurerm_subnet_network_security_group_association" "association1" {
  depends_on = [
    azurerm_network_security_rule.demo
  ]
  network_security_group_id = azurerm_network_security_group.demo-nsg.id
  subnet_id = azurerm_subnet.demo-subnet.id
  
}