variable "api_token" {
  description = "My digital ocean token"
  type        = string
  default     = env("DIGITALOCEAN_TOKEN")
}

variable "droplet_name" {
  description = "Name of our droplet"
  type        = string
  default     = "ubuntu-24-04-x64"
}

variable "image" {
  description = "The desired image for packer"
  type        = string
  default     = "ubuntu-24-04-x64"
}

variable "region" {
  description = "Desired region"
  type        = string
  default     = "nyc1"
}

variable "size" {
  description = "Desired cpu and ram size for the droplet"
  type        = string
  default     = "s-1vcpu-1gb-amd"
}

variable "snapshot_name" {
  description = "Name of the snapshot"
  type        = string
  default     = "dragon-server"
}

variable "snapshot_regions" {
  description = "Snapshot regions"
  type        = list(string)
  default     = ["nyc1", "nyc2", "nyc3"]
}

variable "ssh_username" {
  description = ""
  type        = string
  default     = "root"
}

variable "tags" {
  description = "My favorite tags"
  type        = list(string)
  default     = ["dev", "packer", "docker", "caddy", "ubuntu", "2025"]
}
