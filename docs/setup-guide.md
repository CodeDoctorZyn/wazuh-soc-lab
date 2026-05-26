# Wazuh SOC Lab — Setup Guide

## Architecture

```
MacBook Air M1 (8GB RAM)
├── Docker Desktop
│   ├── wazuh-manager    (SIEM engine, rules, alerts)
│   ├── wazuh-indexer    (OpenSearch — stores all events)
│   └── wazuh-dashboard  (Web UI — https://localhost)
│
└── UTM Virtual Machine
    └── Ubuntu 22.04 VM  ← Wazuh Agent installed here
        (this is your "victim" machine)
```

## Prerequisites

Install these on your Mac before starting:

```bash
# 1. Docker Desktop for Mac (Apple Silicon)
# Download: https://www.docker.com/products/docker-desktop/

# 2. UTM (free VM software for M1)
# Download: https://mac.getutm.app/

# 3. GitHub CLI (optional, for repo management)
brew install gh
```

## Step 1 — Start Wazuh Server (Docker)

```bash
cd wazuh-soc-lab

# Download official Wazuh Docker deployment
curl -so wazuh-docker.tar.gz https://github.com/wazuh/wazuh-docker/archive/refs/tags/v4.7.5.tar.gz
tar -xzf wazuh-docker.tar.gz
mv wazuh-docker-4.7.5/* docker/
cd docker/single-node

# Generate SSL certificates (required first time)
docker compose -f generate-indexer-certs.yml run --rm generator

# Start all services
docker compose up -d

# Watch startup logs (takes 2-3 minutes)
docker compose logs -f
```

## Step 2 — Access Dashboard

Open your browser: **https://localhost**

- Username: `admin`
- Password: `SecretPassword`

> Accept the self-signed certificate warning.

## Step 3 — Install Agent on Ubuntu VM

SSH into your Ubuntu VM, then run:

```bash
# Copy the script to the VM first (from your Mac)
scp agents/setup-agent.sh ubuntu@<vm-ip>:~/

# SSH into VM and run it
ssh ubuntu@<vm-ip>
sudo bash setup-agent.sh 192.168.64.1 ubuntu-victim
```

## Step 4 — Verify Agent Connected

In Wazuh Dashboard → **Agents** — you should see `ubuntu-victim` as Active.

## Step 5 — Run Attack Simulations

See `docs/attack-scenarios.md` for step-by-step attack simulations that
generate real alerts in the dashboard.
