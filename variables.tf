variable "resource_group_name" {
  description = "Name of the Resource Group"

}

variable "resource_group_location" {
  description = "Location of the resource group"
}

variable "address_space_list" {
  type = list(string)
  description = "List of address spaces"
  
}

variable "subnet_address_prefixes" {
  type=list(string)
  description = "List of subnet address spaces"
}

variable "nsg_name" {
  description = "Name of the nsg"
  
}

variable "subnet_name" {
  description = "Name of the subnet"
  
}

variable "vnet_name" {
  description = "Name of the vnet"
}