resource "proxmox_vm_qemu" "instance" {
  for_each = {
    for instance in var.instances : instance.vmname => instance
  }

  name        = each.key
  os_type     = var.os_type
  full_clone  = true
  clone       = var.template_name
  target_node = var.target_node
  ipconfig0   = each.value.ipconfig
  ciuser      = try(var.vm_config_map.ciuser, null)
  cipassword  = var.cipassword

  # base config
  additional_wait  = lookup(var.vm_base_config_map, "additional_wait", 15)
  automatic_reboot = lookup(var.vm_base_config_map, "automatic_reboot", true)
  clone_wait       = lookup(var.vm_base_config_map, "clone_wait", 30)
  cpu_type         = lookup(var.vm_base_config_map, "cpu", "host")
  agent            = 1
  qemu_os          = lookup(var.vm_base_config_map, "qemu_os", "l26")
  skip_ipv4        = lookup(var.vm_base_config_map, "skip_ipv4", null)
  skip_ipv6        = lookup(var.vm_base_config_map, "skip_ipv6", null)
  sockets          = lookup(var.vm_base_config_map, "sockets", 1)
  vcpus            = lookup(var.vm_base_config_map, "vcpus", null)
  # configurable parameters
  bios                   = var.vm_config_map.bios
  boot                   = var.vm_config_map.boot
  bootdisk               = var.vm_config_map.bootdisk
  ciupgrade              = try(var.vm_config_map.ciupgrade, false)
  cores                  = var.vm_config_map.cores
  define_connection_info = var.vm_config_map.define_connection_info
  machine                = var.vm_config_map.machine
  memory                 = var.vm_config_map.memory
  onboot                 = var.vm_config_map.onboot
  scsihw                 = var.vm_config_map.scsihw
  balloon                = var.vm_config_map.balloon

  sshkeys = var.sshkeys
  tags    = var.tags
  vmid    = each.value.vmid

  network {
    id        = 0
    bridge    = lookup(var.network, "bridge", "null")
    firewall  = lookup(var.network, "firewall", null)
    link_down = lookup(var.network, "link_down", null)
    macaddr   = lookup(each.value, "macaddr", null)
    model     = lookup(var.network, "model", null)
    mtu       = lookup(var.network, "mtu", null)
    queues    = lookup(var.network, "queues", null)
    rate      = lookup(var.network, "rate", null)
    tag       = lookup(var.network, "tag", null)
  }

  disks {
    scsi {
      dynamic "scsi0" {
        for_each = contains(keys(var.disk_configurations.scsi), "scsi0") ? [1] : []
        content {
          dynamic "disk" {
            for_each = contains(keys(var.disk_configurations.scsi.scsi0), "disk") ? [1] : []
            content {
              size                 = lookup(var.disk_configurations.scsi.scsi0.disk, "size", null)
              storage              = lookup(var.disk_configurations.scsi.scsi0.disk, "storage", null)
              format               = lookup(var.disk_configurations.scsi.scsi0.disk, "format", null)
              backup               = lookup(var.disk_configurations.scsi.scsi0.disk, "backup", null)
              discard              = lookup(var.disk_configurations.scsi.scsi0.disk, "discard", null)
              emulatessd           = lookup(var.disk_configurations.scsi.scsi0.disk, "emulatessd", null)
              iothread             = lookup(var.disk_configurations.scsi.scsi0.disk, "iothread", null)
              replicate            = lookup(var.disk_configurations.scsi.scsi0.disk, "replicate", null)
              readonly             = lookup(var.disk_configurations.scsi.scsi0.disk, "readonly", null)
              iops_r_burst         = lookup(var.disk_configurations.scsi.scsi0.disk, "iops_r_burst", null)
              iops_r_burst_length  = lookup(var.disk_configurations.scsi.scsi0.disk, "iops_r_burst_length", null)
              iops_r_concurrent    = lookup(var.disk_configurations.scsi.scsi0.disk, "iops_r_concurrent", null)
              iops_wr_burst        = lookup(var.disk_configurations.scsi.scsi0.disk, "iops_wr_burst", null)
              iops_wr_burst_length = lookup(var.disk_configurations.scsi.scsi0.disk, "iops_wr_burst_length", null)
              iops_wr_concurrent   = lookup(var.disk_configurations.scsi.scsi0.disk, "iops_wr_concurrent", null)
              mbps_r_burst         = lookup(var.disk_configurations.scsi.scsi0.disk, "mbps_r_burst", null)
              mbps_r_concurrent    = lookup(var.disk_configurations.scsi.scsi0.disk, "mbps_r_concurrent", null)
              mbps_wr_burst        = lookup(var.disk_configurations.scsi.scsi0.disk, "mbps_wr_burst", null)
              mbps_wr_concurrent   = lookup(var.disk_configurations.scsi.scsi0.disk, "mbps_wr_concurrent", null)
            }
          }
        }
      }
    }
    ide {
      dynamic "ide2" {
        for_each = contains(keys(var.disk_configurations.ide), "ide2") ? [1] : []
        content {
          dynamic "cdrom" {
            for_each = contains(keys(var.disk_configurations.ide.ide2), "cdrom") ? [1] : []
            content {
              iso = var.disk_configurations.ide.ide2.cdrom.iso
            }
          }
        }
      }

      dynamic "ide3" {
        for_each = contains(keys(var.disk_configurations.ide), "ide3") ? [1] : []
        content {
          dynamic "cloudinit" {
            for_each = contains(keys(var.disk_configurations.ide.ide3), "cloudinit") ? [1] : []
            content {
              storage = var.disk_configurations.ide.ide3.cloudinit.storage
            }
          }
        }
      }
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
