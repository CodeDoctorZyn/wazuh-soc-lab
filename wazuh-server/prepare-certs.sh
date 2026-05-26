#!/bin/bash
# Loads ALL config files and certs into Docker volumes via docker cp (not VirtioFS).
# Run this ONCE before "docker compose up", and again after regenerating certs.

set -e
BASE="$(cd "$(dirname "$0")" && pwd)"
CERTS="$BASE/config/wazuh_indexer_ssl_certs"
DASH_CFG="$BASE/config/wazuh_dashboard"
MGR_CFG="$BASE/config/wazuh_cluster"
RULES="$BASE/../rules"

copy_into_volume() {
  local vol="$1" dest_dir="$2"
  shift 2
  local cid
  cid=$(docker run -d -v "$vol:$dest_dir" alpine sh -c "sleep 60")
  for pair in "$@"; do
    src="${pair%%:*}"
    dst="$dest_dir/${pair##*:}"
    docker cp "$src" "$cid:$dst"
  done
  docker exec "$cid" chown -R 1000:1000 "$dest_dir"
  docker exec "$cid" chmod -R a+r "$dest_dir"
  docker stop "$cid" > /dev/null
  docker rm   "$cid" > /dev/null
}

echo "[*] Creating volumes..."
for vol in \
  wazuh-server_wazuh-indexer-certs-vol \
  wazuh-server_wazuh-dashboard-certs-vol \
  wazuh-server_wazuh-dashboard-osd-config-vol \
  wazuh-server_wazuh-dashboard-config \
  wazuh-server_wazuh-manager-ssl-vol \
  wazuh-server_wazuh-manager-conf-vol \
  wazuh-server_wazuh-manager-rules-vol; do
  docker volume create "$vol" > /dev/null
done

echo "[*] Loading indexer certs..."
copy_into_volume wazuh-server_wazuh-indexer-certs-vol /certs \
  "$CERTS/root-ca.pem:root-ca.pem" \
  "$CERTS/wazuh.indexer.pem:wazuh.indexer.pem" \
  "$CERTS/wazuh.indexer-key.pem:wazuh.indexer.key" \
  "$CERTS/admin.pem:admin.pem" \
  "$CERTS/admin-key.pem:admin-key.pem"

echo "[*] Loading dashboard certs..."
copy_into_volume wazuh-server_wazuh-dashboard-certs-vol /certs \
  "$CERTS/wazuh.dashboard.pem:wazuh-dashboard.pem" \
  "$CERTS/wazuh.dashboard-key.pem:wazuh-dashboard-key.pem" \
  "$CERTS/root-ca.pem:root-ca.pem"

echo "[*] Loading dashboard opensearch_dashboards.yml..."
copy_into_volume wazuh-server_wazuh-dashboard-osd-config-vol /config \
  "$DASH_CFG/opensearch_dashboards.yml:opensearch_dashboards.yml"

echo "[*] Loading dashboard wazuh.yml..."
copy_into_volume wazuh-server_wazuh-dashboard-config /wazuh-config \
  "$DASH_CFG/wazuh.yml:wazuh.yml"

echo "[*] Loading manager SSL certs..."
copy_into_volume wazuh-server_wazuh-manager-ssl-vol /ssl \
  "$CERTS/root-ca-manager.pem:root-ca.pem" \
  "$CERTS/wazuh.manager.pem:filebeat.pem" \
  "$CERTS/wazuh.manager-key.pem:filebeat.key"

echo "[*] Loading manager ossec.conf..."
copy_into_volume wazuh-server_wazuh-manager-conf-vol /ossec-conf \
  "$MGR_CFG/wazuh_manager.conf:ossec.conf"

echo "[*] Loading custom rules..."
copy_into_volume wazuh-server_wazuh-manager-rules-vol /rules \
  "$RULES/local_rules.xml:local_rules.xml"

echo ""
echo "[+] All volumes loaded. Run: docker compose up -d"
