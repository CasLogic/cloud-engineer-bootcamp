variable "location" {
  description = "Azure region where resources will be deployed"
  type        = string
  default     = "East US"
}

variable "environment" {
  description = "Deployment environment"
  type        = string
  default     = "dev"
}

variable "vm_size" {
  description = "Azure VM SKU"
  type        = string
  default     = "Standard_B2ts_v2"
}
variable "vnet_address_space" {
  description = "Address space for the virtual network"
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "subnet_address_prefixes" {
  description = "Address prefixes for the web subnet"
  type        = list(string)
  default     = ["10.0.1.0/24"]
}
variable "common_tags" {
  description = "Common tags applied to Azure resources"
  type        = map(string)

  default = {
    Project   = "terraform-lab"
    ManagedBy = "terraform"
  }
}