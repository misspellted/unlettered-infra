
variable "subscription_id" {
  type        = string
  description = "The identifier of the Azure subscription in which the infrastructure is to be managed."
}

variable "resource_groups_location" {
  type        = string
  description = "The locations where resource gorups are created."
  default     = "southcentralus"
}
