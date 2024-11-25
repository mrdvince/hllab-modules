# Proxmox VM QEMU Terraform Module

This Terraform module is designed to manage and provision QEMU virtual machines on a Proxmox server.

## Files

- **main.tf**: Contains the main resource definitions for creating and managing Proxmox VMs.
- **variables.tf**: Defines the input variables used by the module to customize VM configurations.
- **versions.tf**: Specifies the required Terraform version and provider dependencies.

## Usage

To use this module, include it in your Terraform configuration and provide the necessary input variables. Below is an example:

```hcl
module "vm" {
  source        = "./modules"
  vmname        = "<vmname>"
  template_name = "<template_name>"
  os_type       = "cloud_init"
  target_node   = "<target_node>"
  ipconfig0     = "ip=<ip>/<cidr>,gw=<gw>"
  network = {
    bridge    = "<bridge>"
    firewall  = false
    link_down = false
    model     = "virtio"
  }
  cipassword = "<cipassword>"
  vm_config_map = {
    bios                   = "ovmf"
    boot                   = "c"
    bootdisk               = "scsi0"
    ciupgrade              = true
    ciuser                 = "<ciuser>"
    cores                  = 1
    define_connection_info = true
    machine                = "q35"
    memory                 = 1024
    onboot                 = true
    scsihw                 = "virtio-scsi-pci"
  }

  disks = {
    storage    = "<storage>"
    backup     = true
    discard    = false
    emulatessd = false
    format     = "raw"
    iothread   = false
    readonly   = false
    replicate  = false
    size       = "10G"

  }
  serial = {
    id   = 0
    type = "socket"
  }
  sshkeys = file("~/.ssh/<sshkey>.pub")

  efidisk = {
    efitype = "4m"
    storage = "<storage>"
  }
}
```

## Inputs

Refer to `variables.tf` for a complete list of input variables and their descriptions. Customize these variables to suit your specific VM requirements.

## Outputs

The module does not currently define any outputs. You can modify the module to include outputs as needed.

## Requirements

- Terraform version specified in `versions.tf`
- Proxmox provider
