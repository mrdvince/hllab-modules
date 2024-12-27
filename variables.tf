variable "vmname" {
  description = "Name of the VM"
  type        = string
}

variable "template_name" {
  description = "Name of the template"
  type        = string
}

variable "os_type" {
  description = "Type of the OS"
  type        = string
}

variable "target_node" {
  description = "Node to deploy the VM to"
  type        = string
}

variable "ipconfig0" {
  description = "IP configuration for the VM"
  type        = string
}

variable "vmid" {
  description = "VM ID"
  type        = number
  default     = 0
}

variable "tags" {
  description = "Tags for the VM"
  default     = null
}

variable "vm_base_config_map" {
  description = "Base VM configuration options"
  type        = map(any)
  default     = {}
}

variable "vm_config_map" {
  type        = map(any)
  description = "Additional VM configuration options"
  # bios type can seabios or ovmf
}

variable "sshkeys" {
  description = "SSH keys used in the VM"
  default     = null
}
variable "cipassword" {
  description = "Password for the VM"
  type        = string
  default     = null
}

variable "disks" {
  description = "VM Disk"
  type        = map(any)
}

variable "network" {
  description = "VM Network configuration"
  type        = map(any)
}

variable "serial" {
  description = "VM Serial configuration"
  type        = map(any)
}

variable "efidisk" {
  description = "EFI Disk config"
  type        = map(any)
  default     = null
}
