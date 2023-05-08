/*
    DESCRIPTION:
    Ubuntu Server 22.04 LTS template using the Packer Builder for VMware vSphere (vsphere-iso).
*/

//  BLOCK: packer
//  The Packer configuration.

packer {
  required_version = ">= 1.8.0"
  required_plugins {
    vsphere = {
      version = ">= v1.0.3"
      source  = "github.com/hashicorp/vsphere"
    }
  }
}

//  BLOCK: source
//  Defines the builder configuration blocks.

source "vsphere-iso" "linux-ubuntu" {

  // vCenter Server Endpoint Settings and Credentials
  vcenter_server      = var.vsphere_endpoint
  username            = var.vsphere_username
  password            = var.vsphere_password
  insecure_connection = var.vsphere_insecure_connection

  // vSphere Settings
  datacenter          = var.vsphere_datacenter
  cluster             = var.vsphere_cluster
  host                = var.vsphere_host
  datastore           = var.vsphere_datastore
  folder              = var.vsphere_folder
  resource_pool       = var.vsphere_resource_pool

  // Virtual Machine Settings
  guest_os_type        = var.vm_guest_os_type
  vm_name              = "${var.vm_guest_os_name}-${var.vm_guest_os_version}-v${local.build_version}"
  firmware             = var.vm_firmware
  CPUs                 = var.vm_cpu_sockets
  cpu_cores            = var.vm_cpu_cores
  CPU_hot_plug         = var.vm_cpu_hot_add
  RAM                  = var.vm_mem_size
  RAM_hot_plug         = var.vm_mem_hot_add
  video_ram            = var.vm_video_ram
  cdrom_type           = var.vm_cdrom_type
  disk_controller_type = var.vm_disk_controller_type
  NestedHV             = var.vm_nested_hardware_virtualization
  storage {
    disk_size             = var.vm_disk_size
    disk_thin_provisioned = var.vm_disk_thin_provisioned
  }
  network_adapters {
    network      = "/${var.vsphere_datacenter}/network/${var.vsphere_switch}/${var.vsphere_network}"
    network_card = var.vm_network_card
  }
  vm_version           = var.common_vm_version
  remove_cdrom         = var.common_remove_cdrom
  tools_upgrade_policy = var.common_tools_upgrade_policy
  notes                = "Version: v${local.build_version}\nBuilt on: ${local.build_date}\n${local.build_by}\nCreds: ${var.build_username} / ${var.build_password}"

  // Removable Media Settings
  iso_paths    = ["[${var.vsphere_iso_datastore}] ${var.iso_path}/${var.iso_file}"]
  iso_checksum = "${var.iso_checksum_type}:${var.iso_checksum_value}"
  http_content = var.common_data_source == "http" ? local.data_source_content : null
  cd_content   = var.common_data_source == "disk" ? local.data_source_content : null
  cd_label     = var.common_data_source == "disk" ? "cidata" : null

  // Boot and Provisioning Settings
  http_ip       = var.common_data_source == "http" ? var.common_http_ip : null
  http_port_min = var.common_data_source == "http" ? var.common_http_port_min : null
  http_port_max = var.common_data_source == "http" ? var.common_http_port_max : null
  boot_order    = var.vm_boot_order
  boot_wait     = var.vm_boot_wait
  boot_command = [
    "c<wait>",
    "linux /casper/vmlinuz --- autoinstall ${local.data_source_command}",
    "<enter><wait>",
    "initrd /casper/initrd",
    "<enter><wait>",
    "boot",
    "<enter>"
  ]
  ip_wait_timeout  = var.common_ip_wait_timeout
  // Our build process puts the build user in the sudoers group whith the NOPASSWD option, so no need to echo the PW
  //shutdown_command = "echo '${var.build_password}' | sudo -S -E shutdown -P now"
  shutdown_command = "sudo -E shutdown -P now"
  shutdown_timeout = var.common_shutdown_timeout

  // Communicator Settings and Credentials
  communicator       = "ssh"
  ssh_proxy_host     = var.communicator_proxy_host
  ssh_proxy_port     = var.communicator_proxy_port
  ssh_proxy_username = var.communicator_proxy_username
  ssh_proxy_password = var.communicator_proxy_password
  ssh_username       = var.build_username
  ssh_password       = var.build_password
  ssh_port           = var.communicator_port
  ssh_timeout        = var.communicator_timeout

  // Template and Content Library Settings
  create_snapshot     = var.common_create_snapshot
  snapshot_name       = var.common_snapshot_name
  convert_to_template = var.common_template_conversion
  dynamic "content_library_destination" {
    for_each = var.common_content_library_name != null ? [1] : []
    content {
      library     = var.common_content_library_name
      description = "Version: v${local.build_version}\nBuilt on: ${local.build_date}\n${local.build_by}"
      ovf         = var.common_content_library_ovf
      destroy     = var.common_content_library_destroy
      skip_import = var.common_content_library_skip_export
    }
  }
  // Output Configuration
  dynamic "export" {
    for_each = var.common_export_ovf == "yes" ? [1] : []
    content {
     output_directory  = var.common_output_path
     force             = var.common_output_force_overwrite
     //options         = ["mac","uuid","extraconfig"]
    }
  }
}

//  BLOCK: build
//  Defines the builders to run, provisioners, and post-processors.
build {
  sources = ["source.vsphere-iso.linux-ubuntu"]
  // The Nerd Fonts are downloaded into this directory as part of the build.sh script
  // They are used for the oh-my-zsh and powerlevel10k configuration, and set as the
  // default font for Visual Studio Code, Terminal, and Terminator
  provisioner "file" {
    source      = "./MesloLGSNF"
    destination = "~/MesloLGSNF"
  }
  # TODO Re-Structure Project to clone from github repo into the ~/.scripts folder
  provisioner "file" {
    source      = "./scripts"
    destination = "~/.scripts"
  }
  # If you want Conky to displya your logo, place a file named "Logo.png" in the Pictures folder
  # If you want a custom login screen, place a file named "custom-login-screen.png" in the Pictures folder
  provisioner "file" {
    source      = "./Pictures"
    destination = "~/Pictures"
  }
  // Each of the .sh scripts in the scripts folder are executed in numeric order
  // They can make use of the environment variables provided in this block during their execution
  // NOTE: the -eux displays debug info (x), exits whenever a command exits with a non-zero status (e), exits whenever there is an undefined parameter
  provisioner "shell" {
    environment_vars  = [ "HOME_DIR=/home/${var.build_username}","SSH_PUBKEY=${var.build_key}","PRIVATE_DNS_IP=${var.common_private_dns_ip}","PRIVATE_NTP_IP=${var.common_private_ntp_ip}","INTERNAL_DOMAIN_NAME=${var.common_internal_domain_name}","BUILD_LOCALE=${var.vm_guest_os_language}" ]
    expect_disconnect = true
    execute_command = "{{.Vars}} bash -eu '{{ .Path }}'"
    scripts         = fileset(".","scripts/build/*.sh")
  }

  post-processor "manifest" {
    output     = "${var.common_output_path}${local.manifest_date}.json"
    strip_path = true
    strip_time = true
    custom_data = {
      build_username           = var.build_username
      build_date               = local.build_date
      build_version            = local.build_version
      common_data_source       = var.common_data_source
      common_vm_version        = var.common_vm_version
      vm_cpu_cores             = var.vm_cpu_cores
      vm_cpu_sockets           = var.vm_cpu_sockets
      vm_disk_size             = var.vm_disk_size
      vm_disk_thin_provisioned = var.vm_disk_thin_provisioned
      vm_firmware              = var.vm_firmware
      vm_guest_os_type         = var.vm_guest_os_type
      vm_mem_size              = var.vm_mem_size
      vm_network_card          = var.vm_network_card
      vsphere_cluster          = var.vsphere_cluster
      vsphere_host             = var.vsphere_host
      vsphere_datacenter       = var.vsphere_datacenter
      vsphere_datastore        = var.vsphere_datastore
      vsphere_endpoint         = var.vsphere_endpoint
      vsphere_folder           = var.vsphere_folder
      resource_pool            = var.vsphere_resource_pool
      common_export_ovf        = var.common_export_ovf
      vsphere_iso_path         = "[${var.vsphere_iso_datastore}] ${var.iso_path}/${var.iso_file}"
    }
  }
}

//  BLOCK: locals
//  Defines the local variables.

locals {
  build_by      = "Built by: HashiCorp Packer ${packer.version}"
  build_date    = formatdate("YYYY-MM-DD hh:mm ZZZ", timestamp())
  build_version = formatdate("YY.MM.DD.hh.mm", timestamp())
  manifest_date = formatdate("YYYY-MM-DD hh:mm:ss", timestamp())
  data_source_content = {
    "/meta-data" = file("${abspath(path.root)}/data/meta-data")
    "/user-data" = templatefile("${abspath(path.root)}/data/user-data.pkrtpl.hcl", {
      build_hostname = "${var.vm_name}-${var.vm_guest_os_version}"
      build_username           = var.build_username
      build_password_encrypted = var.build_password_encrypted
      vm_guest_os_language     = var.vm_guest_os_language
      vm_guest_os_keyboard     = var.vm_guest_os_keyboard
      vm_guest_os_timezone     = var.vm_guest_os_timezone
    })
  }
  data_source_command = var.common_data_source == "http" ? "ds=\"nocloud-net;seedfrom=http://{{.HTTPIP}}:{{.HTTPPort}}/\"" : "ds=\"nocloud\""
}