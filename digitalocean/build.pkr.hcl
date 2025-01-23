packer {
  required_plugins {
    digitalocean = {
      version = ">= 1.0.0"
      source  = "github.com/hashicorp/digitalocean"
    }
    ansible = {
      version = "~> 1"
      source = "github.com/hashicorp/ansible"
    }
  }
}

locals {
  timestamp = formatdate("YYYY-MM-DD", timestamp())
}

source "digitalocean" "dragon-server" {
  api_token        = "${var.api_token}"
  droplet_name     = "${var.droplet_name}-${local.timestamp}"
  image            = "${var.image}"
  region           = "${var.region}"
  size             = "${var.size}"
  snapshot_name    = "${var.snapshot_name}-${local.timestamp}"
  snapshot_regions = "${var.snapshot_regions}"
  ssh_username     = "${var.ssh_username}"
  tags             = "${var.tags}"
}

build {
  sources = ["source.digitalocean.dragon-server"]

  provisioner "ansible" {
    user = "root"
    playbook_file = "./playbook.yml"
    extra_arguments = [ "--scp-extra-args", "'-O'" ] # Workaround for "failed to transfer" errors. See https://github.com/hashicorp/packer/issues/11783#issuecomment-1137052770
  }
}
