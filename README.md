\# GitOps Home Lab



Infrastructure as Code lab using OpenTofu and Ansible on Proxmox.



\## Architecture

\- \*\*vm-web-01\*\* (192.168.72.11) — Nginx web server

\- \*\*vm-db-01\*\* (192.168.72.12) — PostgreSQL database

\- \*\*vm-mon-01\*\* (192.168.72.13) — Prometheus + Grafana monitoring



\## Stack

\- \*\*Proxmox VE\*\* — hypervisor (nested in VMware)

\- \*\*OpenTofu\*\* — VM provisioning (IaC)

\- \*\*Ansible\*\* — configuration management

\- \*\*Ubuntu 24.04\*\* — base OS for all VMs



\## Usage

```bash

\# Provision VMs

cd terraform \&\& tofu apply



\# Configure services

cd ansible \&\& ansible-playbook site.yml

```



\## Services

\- Nginx: `http://192.168.72.11`

\- Prometheus: `http://192.168.72.13:9090`

\- Grafana: `http://192.168.72.13:3000`

