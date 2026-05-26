#!/bin/bash
# Populates the wazuh-indexer-certs-vol Docker volume using docker cp (not VirtioFS).
# Run this ONCE before the first "docker compose up".
# Re-run any time you regenerate certs.

set -e
CERTS_DIR="$(cd "$(dirname "$0")" && pwd)/config/wazuh_indexer_ssl_certs"

echo "[*] Creating cert volume and copying files via docker cp..."

docker volume create wazuh-server_wazuh-indexer-certs-vol 2>/dev/null || true

CID=$(docker run -d -v wazuh-server_wazuh-indexer-certs-vol:/certs alpine sh -c "sleep 60")

docker cp "$CERTS_DIR/root-ca.pem"           "$CID:/certs/root-ca.pem"
docker cp "$CERTS_DIR/wazuh.indexer.pem"     "$CID:/certs/wazuh.indexer.pem"
docker cp "$CERTS_DIR/wazuh.indexer-key.pem" "$CID:/certs/wazuh.indexer.key"
docker cp "$CERTS_DIR/admin.pem"             "$CID:/certs/admin.pem"
docker cp "$CERTS_DIR/admin-key.pem"         "$CID:/certs/admin-key.pem"

docker exec "$CID" chown 1000:1000 /certs/root-ca.pem /certs/wazuh.indexer.pem /certs/wazuh.indexer.key /certs/admin.pem /certs/admin-key.pem
docker exec "$CID" chmod 400 /certs/wazuh.indexer.key /certs/admin-key.pem
docker exec "$CID" chmod 444 /certs/root-ca.pem /certs/wazuh.indexer.pem /certs/admin.pem
docker stop "$CID" && docker rm "$CID"

echo "[+] Certs loaded into volume. Run: docker compose up -d"
