/*
    DESCRIPTION:
    Ubuntu Server 22.04 LTS  variables used by the Packer Plugin for VMware vSphere (vsphere-iso).
    Docs: https://www.packer.io/plugins/builders/vsphere/vsphere-iso
*/

// Guest Operating System Metadata
vm_guest_os_language = "en_US"
vm_guest_os_keyboard = "us"
vm_guest_os_timezone = "America/New_York"
vm_guest_os_family   = "linux"
vm_guest_os_name     = "ubuntu"
vm_guest_os_version  = "22.04lts"
vm_name              = "ubuntu"

// Virtual Machine Guest Operating System Setting
vm_guest_os_type = "ubuntu64Guest"

// Virtual Machine Hardware Settings
vm_firmware              = "efi-secure"
vm_cdrom_type            = "sata"
vm_cpu_sockets           = 2
vm_cpu_cores             = 2
vm_cpu_hot_add           = false
vm_video_ram             = 65536
vm_mem_size              = 8192
vm_mem_hot_add           = false
vm_disk_size             = 81920
vm_disk_controller_type  = ["pvscsi"]
vm_disk_thin_provisioned = true
vm_network_card          = "vmxnet3"

// Removable Media Settings
iso_checksum_type  = "sha256"
# Ubuntu 22.04.2
iso_url            = "https://releases.ubuntu.com/22.04/ubuntu-22.04.2-live-server-amd64.iso"
iso_file           = "ubuntu-22.04.2-live-server-amd64.iso"
iso_checksum_value = "5e38b55d57d94ff029719342357325ed3bda38fa80054f9330dc789cd2d43931"
# Ubuntu 22.04.1
# iso_file           = "ubuntu-22.04.2-live-server-amd64.iso"
# iso_checksum_value = "10f19c5b2b8d6db711582e0e27f5116296c34fe4b313ba45f9b201a5007056cb"
# Ubuntu 22.04
# iso_file           = "ubuntu-22.04-live-server-amd64.iso"
# iso_checksum_value = "84aeaf7823c8c61baa0ae862d0a06b03409394800000b3235854a6b38eb4856f"

// Boot Settings
vm_boot_order = "disk,cdrom"
vm_boot_wait  = "5s"

// Communicator Settings
communicator_port    = 22
communicator_timeout = "60m"