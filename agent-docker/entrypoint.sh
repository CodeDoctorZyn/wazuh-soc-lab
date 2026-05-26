#!/bin/bash
# Start SSH daemon
/usr/sbin/sshd

# Update manager IP in case it changed
sed -i "s|MANAGER_IP|wazuh.manager|g" /var/ossec/etc/ossec.conf 2>/dev/null || true

# Start Wazuh agent
/var/ossec/bin/wazuh-agentd &
/var/ossec/bin/wazuh-execd &
/var/ossec/bin/wazuh-logcollector &
/var/ossec/bin/wazuh-syscheckd &
/var/ossec/bin/wazuh-agentlessd 2>/dev/null &

# Keep container running
echo "[*] Ubuntu victim agent started. Wazuh agent connecting to wazuh.manager..."
tail -f /var/ossec/logs/ossec.log
