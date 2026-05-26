# Wazuh SOC Lab

A hands-on Security Operations Center lab built with Wazuh SIEM/XDR for threat monitoring, detection, and incident response practice.

## Overview

This lab simulates a real SOC environment running on a MacBook Air M1 using Docker and a lightweight Ubuntu VM. It demonstrates threat detection, custom rule writing, and attack response using industry-standard tools.

## Architecture

```
MacBook Air M1
├── Docker Desktop
│   ├── Wazuh Manager     — SIEM engine, correlation rules, alerting
│   ├── Wazuh Indexer     — OpenSearch (event storage & search)
│   └── Wazuh Dashboard   — Web UI for analysts (https://localhost)
│
└── UTM VM
    └── Ubuntu 22.04      — Monitored endpoint with Wazuh Agent
```

## Attack Scenarios Covered

| Scenario | MITRE Tactic | Detection |
|---|---|---|
| SSH Brute Force | Credential Access (T1110) | Custom rule 100001 |
| File Tampering | Defense Evasion (T1565) | FIM + rule 100005 |
| Privilege Escalation | Privilege Escalation (T1548) | Rule 100004 |
| Persistence (new user) | Persistence (T1136) | Rule 100003 |

## Quick Start

```bash
# 1. Start Wazuh (Docker)
cd docker/single-node && docker compose up -d

# 2. Open dashboard
open https://localhost   # admin / SecretPassword

# 3. Install agent on Ubuntu VM
scp agents/setup-agent.sh ubuntu@<vm-ip>:~/
ssh ubuntu@<vm-ip> "sudo bash setup-agent.sh 192.168.64.1"

# 4. Run attack simulations
bash attacks/brute-force-ssh.sh <vm-ip>
```

## Documentation

- [Full Setup Guide](docs/setup-guide.md)
- [VM Setup (UTM for M1)](docs/vm-setup.md)
- [Attack Scenarios & Expected Alerts](docs/attack-scenarios.md)

## Tools Used

- [Wazuh 4.7.5](https://wazuh.com) — Open-source SIEM/XDR
- [Docker Desktop](https://docker.com) — Container runtime
- [UTM](https://mac.getutm.app) — VM software for Apple Silicon
- [Hydra](https://github.com/vanhauser-thc/thc-hydra) — Password attack tool (testing only)

## Skills Demonstrated

- SIEM deployment and configuration
- Custom detection rule writing (XML)
- Threat monitoring and alert triage
- MITRE ATT&CK framework mapping
- Endpoint agent deployment
- File Integrity Monitoring (FIM)
- Log analysis and incident response
