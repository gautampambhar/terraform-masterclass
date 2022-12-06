variable "environment" {
    description = "The name of the environment"
}

# Vars
variable "location" {
  description = "The Azure Region in which all resources groups should be created."
}

variable "rg-name" {
    description = "The name of the resource group"
}

variable "storage-account-name" {
  description = "The name of the storage account"
}

variable "tags"{
  type = object({
    environments = string
    CreatedBy   = string
  })
}
