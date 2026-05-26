#!/bin/bash
# Run this script on the Ubuntu VM to install and register the Wazuh agent

set -e

WAZUH_MANAGER_IP="${1:-192.168.64.1}"  # Default: Mac host IP in UTM
AGENT_NAME="${2:-ubuntu-victim}"

echo "[*] Installing Wazuh Agent 4.7.5 on $(hostname)"
echo "[*] Connecting to Wazuh Manager at: $WAZUH_MANAGER_IP"

# Add Wazuh repo
curl -s https://packages.wazuh.com/key/GPG-KEY-WAZUH | gpg --no-default-keyring \
  --keyring gnupg-ring:/usr/share/keyrings/wazuh.gpg --import && \
  chmod 644 /usr/share/keyrings/wazuh.gpg

echo "deb [signed-by=/usr/share/keyrings/wazuh.gpg] https://packages.wazuh.com/4.x/apt/ stable main" | \
  tee /etc/apt/sources.list.d/wazuh.list

apt-get update -q

# Install agent and register in one step
WAZUH_MANAGER="$WAZUH_MANAGER_IP" \
WAZUH_AGENT_NAME="$AGENT_NAME" \
apt-get install -y wazuh-agent

# Enable and start the agent
systemctl daemon-reload
systemctl enable wazuh-agent
systemctl start wazuh-agent

echo ""
echo "[+] Wazuh agent installed and started."
echo "[+] Check status: systemctl status wazuh-agent"
echo "[+] View logs:    tail -f /var/ossec/logs/ossec.log"
