# GitOps Home Lab

Infrastructure as Code lab provisioning and configuring a 3-tier environment on Proxmox using OpenTofu and Ansible — built from scratch, including recovering from real infrastructure failures along the way (LVM storage exhaustion, dpkg corruption, clock skew, broken Jinja2 templates).

## Architecture

| Layer | Tool | Responsibility |
|---|---|---|
| Host | Windows + VMware | Runs Proxmox as a nested VM |
| Hypervisor | Proxmox VE | Manages VM lifecycle and storage |
| Provisioning | OpenTofu | Declaratively creates 3 VMs from a cloud-init template |
| Configuration | Ansible | Installs and configures services over SSH |
| Workloads | Nginx, PostgreSQL, Prometheus, Grafana | The services being managed |

### VM Roles

| VM | IP | Role |
|---|---|---|
| vm-web-01 | 192.168.72.11 | Nginx web server, also acts as Ansible control node |
| vm-db-01 | 192.168.72.12 | PostgreSQL database |
| vm-mon-01 | 192.168.72.13 | Prometheus + Grafana monitoring stack |

## Stack

- **Proxmox VE** — hypervisor, nested inside VMware
- **OpenTofu** — infrastructure as code for VM provisioning
- **Ansible** — configuration management, idempotent service deployment
- **Ubuntu 24.04 LTS** — base OS for all VMs

## Usage

Provision the VMs:
```bash
cd terraform
tofu init
tofu apply
```

Configure all services:
```bash
cd ansible
ansible all -m ping
ansible-playbook site.yml
```

## Services

| Service | Endpoint |
|---|---|
| Nginx | http://192.168.72.11 |
| Nginx health check | http://192.168.72.11/health |
| Prometheus | http://192.168.72.13:9090 |
| Grafana | http://192.168.72.13:3000 |

## Repository structure

gitops-lab/

├── terraform/

│   ├── main.tf

│   ├── providers.tf

│   ├── variables.tf

│   └── outputs.tf

└── ansible/

├── ansible.cfg

├── site.yml

├── inventory/

│   └── hosts.yml

└── roles/

├── common/

├── webserver/

├── database/

└── monitoring/


## What this demonstrates

- Infrastructure as Code with OpenTofu (declarative VM provisioning)
- Configuration management with Ansible (roles, handlers, Jinja2 templates)
- Debugging real production-style failures: LVM thin pool exhaustion, dpkg interruption recovery, NTP clock skew, Jinja2 syntax errors
- Network segmentation and firewall configuration (UFW)
- Monitoring stack deployment (Prometheus + Grafana)