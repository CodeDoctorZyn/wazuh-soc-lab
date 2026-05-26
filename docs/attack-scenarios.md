# Attack Scenarios & Expected Alerts

These scenarios simulate real attacks and generate alerts in the Wazuh dashboard.
Each scenario maps to a MITRE ATT&CK tactic — great to mention in your project.

---

## Scenario 1 — SSH Brute Force (Credential Access)

**MITRE:** T1110 — Brute Force

**Run from:** Your Mac terminal (simulating external attacker)

```bash
# Install hydra if not already installed
brew install hydra

# Run brute force against the Ubuntu VM
bash attacks/brute-force-ssh.sh <ubuntu-vm-ip>
```

**Expected alerts in Wazuh:**
- Rule 5716: `SSH authentication failed`
- Rule 100001: `SOC Lab: SSH brute force attempt detected` (Level 10)

**Where to see it:** Dashboard → Security Events → filter by `rule.id:100001`

---

## Scenario 2 — File Integrity Monitoring (Defense Evasion)

**MITRE:** T1565 — Data Manipulation

**Run from:** Inside the Ubuntu VM

```bash
sudo bash fim-trigger.sh
```

**Expected alerts in Wazuh:**
- Rule 550: `Integrity checksum changed`
- Rule 100005: `Critical file modified` (Level 12)

**Where to see it:** Dashboard → File Integrity Monitoring

---

## Scenario 3 — Privilege Escalation (sudo)

**MITRE:** T1548.003 — Sudo and Sudo Caching

**Run from:** Inside the Ubuntu VM

```bash
# Just use sudo — Wazuh monitors all sudo usage
sudo cat /etc/shadow
```

**Expected alerts in Wazuh:**
- Rule 5402: `Successful sudo`
- Rule 100004: `Privilege escalation via sudo detected` (Level 9)

---

## Scenario 4 — New User Creation (Persistence)

**MITRE:** T1136 — Create Account

**Run from:** Inside the Ubuntu VM

```bash
sudo useradd -m backdoor-user
sudo passwd backdoor-user
```

**Expected alerts in Wazuh:**
- Rule 5901: `New user added to the system`
- Rule 100003: `New user account created` (Level 8)

---

## Dashboard Views for Your Presentation

| View | Path in Dashboard |
|---|---|
| Live alerts | Security Events → Real-time |
| Alert timeline | Overview → Security Events |
| MITRE mapping | MITRE ATT&CK |
| FIM events | File Integrity Monitoring |
| Agent health | Agents |
| Vulnerability scan | Vulnerability Detection |
