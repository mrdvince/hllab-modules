resource "proxmox_vm_qemu" "instance" {
  name        = var.vmname
  os_type     = var.os_type
  full_clone  = true
  clone       = var.template_name
  target_node = var.target_node
  ipconfig0   = var.ipconfig0
  ciuser      = var.vm_config_map.ciuser
  cipassword  = var.cipassword

  # base config
  additional_wait  = lookup(var.vm_base_config_map, "additional_wait", 15)
  automatic_reboot = lookup(var.vm_base_config_map, "automatic_reboot", true)
  clone_wait       = lookup(var.vm_base_config_map, "clone_wait", 30)
  cpu              = lookup(var.vm_base_config_map, "cpu", "host")
  agent            = 1
  qemu_os          = lookup(var.vm_base_config_map, "qemu_os", "l26")
  skip_ipv4        = lookup(var.vm_base_config_map, "skip_ipv4", null)
  skip_ipv6        = lookup(var.vm_base_config_map, "skip_ipv6", null)
  sockets          = lookup(var.vm_base_config_map, "sockets", 1)
  vcpus            = lookup(var.vm_base_config_map, "vcpus", null)
  #  worthy configurable parameters
  bios                   = var.vm_config_map.bios
  boot                   = var.vm_config_map.boot
  bootdisk               = var.vm_config_map.bootdisk
  ciupgrade              = var.vm_config_map.ciupgrade
  cores                  = var.vm_config_map.cores
  define_connection_info = var.vm_config_map.define_connection_info
  machine                = var.vm_config_map.machine
  memory                 = var.vm_config_map.memory
  onboot                 = var.vm_config_map.onboot
  scsihw                 = var.vm_config_map.scsihw
  balloon                = var.vm_config_map.balloon

  sshkeys = var.sshkeys
  tags    = var.tags
  vmid    = var.vmid

  dynamic "disks" {
    for_each = [var.disks]
    content {
      ide {
        ide2 {
          cloudinit {
            storage = lookup(disks.value, "storage", null)
          }
        }
      }
      scsi {
        scsi0 {
          disk {
            backup               = lookup(disks.value, "backup", null)
            discard              = lookup(disks.value, "discard", null)
            emulatessd           = lookup(disks.value, "emulatessd", null)
            format               = lookup(disks.value, "format", null)
            iops_r_burst         = lookup(disks.value, "iops_r_burst", null)
            iops_r_burst_length  = lookup(disks.value, "iops_r_burst_length", null)
            iops_r_concurrent    = lookup(disks.value, "iops_r_concurrent", null)
            iops_wr_burst        = lookup(disks.value, "iops_wr_burst", null)
            iops_wr_burst_length = lookup(disks.value, "iops_wr_burst_length", null)
            iops_wr_concurrent   = lookup(disks.value, "iops_wr_concurrent", null)
            iothread             = lookup(disks.value, "iothread", null)
            mbps_r_burst         = lookup(disks.value, "mbps_r_burst", null)
            mbps_r_concurrent    = lookup(disks.value, "mbps_r_concurrent", null)
            mbps_wr_burst        = lookup(disks.value, "mbps_wr_burst", null)
            mbps_wr_concurrent   = lookup(disks.value, "mbps_wr_concurrent", null)
            readonly             = lookup(disks.value, "readonly", null)
            replicate            = lookup(disks.value, "replicate", null)
            size                 = lookup(disks.value, "size", null)
            storage              = lookup(disks.value, "storage", null)
          }
        }
      }
    }
  }

  dynamic "network" {
    for_each = [var.network]
    content {
      bridge    = lookup(network.value, "bridge", null)
      firewall  = lookup(network.value, "firewall", null)
      link_down = lookup(network.value, "link_down", null)
      macaddr   = lookup(network.value, "macaddr", null)
      model     = lookup(network.value, "model", null)
      mtu       = lookup(network.value, "mtu", null)
      queues    = lookup(network.value, "queues", null)
      rate      = lookup(network.value, "rate", null)
      tag       = lookup(network.value, "tag", null)
    }
  }

  dynamic "serial" {
    for_each = [var.serial]
    content {
      id   = lookup(serial.value, "id", null)
      type = lookup(serial.value, "type", null)
    }
  }

  dynamic "efidisk" {
    for_each = var.efidisk != null ? [1] : []
    content {
      efitype = lookup(var.efidisk, "efitype", null)
      storage = lookup(var.efidisk, "storage", null)
    }
  }
}
