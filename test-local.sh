#!/bin/bash
# test-local.sh
# Local test script for IP Whitelist on HetznerFW Action

set -euo pipefail

# Dummy/test values (replace with real/test values as needed)
HETZNER_API_KEY="test-api-key"
FIREWALL_NAME="test-firewall"
IP_ADDRESS="192.0.2.123"
PORT="2222"
PROTOCOL="tcp"
DIRECTION="in"
DESCRIPTION="local-test-rule"
CLEANUP="true"

# Build the Docker image
DOCKER_IMAGE="ip-whitelist-on-hetznerfw-local-test"
echo "[INFO] Building Docker image..."
docker build -t $DOCKER_IMAGE .

echo "[INFO] Running entrypoint.sh (add rule)..."
docker run --rm \
  -e HETZNER_API_KEY=$HETZNER_API_KEY \
  $DOCKER_IMAGE \
  $HETZNER_API_KEY $FIREWALL_NAME $IP_ADDRESS $PORT $PROTOCOL $DIRECTION $DESCRIPTION $CLEANUP

# Simulate cleanup (post step)
echo "[INFO] Running cleanup.sh (remove rule)..."
docker run --rm \
  -e HETZNER_API_KEY=$HETZNER_API_KEY \
  $DOCKER_IMAGE \
  /cleanup.sh $HETZNER_API_KEY $FIREWALL_NAME $IP_ADDRESS $PORT $PROTOCOL $DIRECTION $DESCRIPTION $CLEANUP

echo "[INFO] Local test completed."

