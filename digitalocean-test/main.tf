terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
  required_version = ">= 1.6"
}

# --- Variables (inputs) ---
variable "do_token" {
  type        = string
  sensitive   = true
  description = "DigitalOcean API token"
}

variable "region" {
  type        = string
  default     = "fra1"  # Frankfurt
}

variable "droplet_name" {
  type        = string
  default     = "swarm-test-1"
}

# OPTIONAL: if you already have SSH keys in DigitalOcean,
# you can put their IDs or fingerprints here via terraform.tfvars later.
variable "ssh_key_ids" {
  type        = list(string)
  default     = []
  description = "List of existing DigitalOcean SSH key IDs or fingerprints"
}

# --- Provider ---
provider "digitalocean" {
  token = var.do_token
}

# --- One droplet ---
resource "digitalocean_droplet" "vm" {
  name   = var.droplet_name
  region = var.region
  size   = "s-1vcpu-1gb"       # small + cheap
  image  = "ubuntu-24-04-x64"  # Ubuntu LTS

  ssh_keys = var.ssh_key_ids   # can be [] at first
}

# --- Output: show the IP after apply ---
output "droplet_ip" {
  value       = digitalocean_droplet.vm.ipv4_address
  description = "Public IPv4 address of the droplet"
}