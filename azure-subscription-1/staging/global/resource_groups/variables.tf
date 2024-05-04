variable "location" {
  type  = string
  description = "The Azure Region to use"
}

variable vnet_resource_group_name {
  type        = string
  description = "The name of the vnet resource group"
}

variable subscription_id {
  type        = string
  description = "The id of the subscription"
}