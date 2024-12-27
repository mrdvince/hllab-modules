variable "vmname" {
  type = string
}

variable "template_name" {
  type = string
}

variable "os_type" {
  type = string
}

variable "target_node" {
  type = string
}

variable "ipconfig0" {
  type = string
}

variable "vmid" {
  type    = number
  default = 0
}

variable "tags" {
  default = null
}

variable "vm_base_config_map" {
  type = map(any)
  default = {}
}

variable "vm_config_map" {
  type        = map(any)
  description = "Additional VM configuration options"
  # bios type can seabios or ovmf
}

variable "sshkeys" {
  default = null
}
variable "cipassword" {
}

variable "disks" {
  type = map(any)
}

variable "network" {
  type = map(any)
}

variable "serial" {
  type = map(any)
}

variable "efidisk" {
  type    = map(any)
  default = null
}
