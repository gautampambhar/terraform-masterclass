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

variable "tags" {
  type = object({
    environments = string
    CreatedBy    = string
  })
}
