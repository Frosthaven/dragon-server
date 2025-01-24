# 🐲 dragon-server

[Back to README](README.md)

## Install Requirements
*Note to Windows users: Ansible does not have a Windows binary. It is
recommended to install your tools AND any system level environmental variables
in WSL.*

Follow the installation guide for the following tools:

- [Packer](https://developer.hashicorp.com/packer/tutorials/docker-get-started/get-started-install-cli)
- [Ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html)

## Building the Image

### Digital Ocean Snapshot
*Requires `DIGITALOCEAN_TOKEN` environmental variable to be set.*

```shell
packer init ./digitalocean;
packer build ./digitalocean;
```

### Amazon Web Services AMI

not yet implemented

