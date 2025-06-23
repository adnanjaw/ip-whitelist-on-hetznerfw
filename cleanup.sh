#!/bin/bash
set -e

# Constants from positional args
readonly API_TOKEN="$1"
readonly FIREWALL_NAME="$2"
readonly IP_ADDRESS="$3"
readonly PORT="$4"
readonly PROTOCOL="$5"
readonly DIRECTION="$6"
readonly DESCRIPTION="${7:-"github-actions-rule"}"
readonly CLEANUP="$8"

# API constants
readonly AUTH_HEADER="Authorization: Bearer $API_TOKEN"
readonly API_URL="https://api.hetzner.cloud/v1/firewalls"

log() {
    echo "[$(date +'%F %T')] $*"
}

get_firewall_id() {
    curl -s -H "$AUTH_HEADER" "$API_URL" | \
        jq -r --arg name "$FIREWALL_NAME" '.firewalls[] | select(.name == $name) | .id'
}

delete_rule_by_description() {
    local firewall_id="$1"
    local desc="$2"

    log "Fetching rules for firewall ID $firewall_id..."
    local response
    response=$(curl -s -H "$AUTH_HEADER" "$API_URL/$firewall_id")

    # Validate JSON before continuing
    if ! echo "$response" | jq . > /dev/null 2>&1; then
        log "Error: Failed to parse JSON from firewall details. Skipping."
        return 0
    fi

    local rules
    rules=$(echo "$response" | jq '.firewall.rules')

    # Check if any rule matches the description
    local match_count
    match_count=$(echo "$rules" | jq --arg desc "$desc" '[.[] | select(.description == $desc)] | length')

    if [ "$match_count" -eq 0 ]; then
        log "No rule with description '$desc' found. Skipping."
        return 0
    fi

    local updated_rules
    updated_rules=$(echo "$rules" | jq --arg desc "$desc" '[.[] | select(.description != $desc)]')

    log "Sending updated rules (removing rule with description '$desc')..."
    curl -s -X POST -H "$AUTH_HEADER" -H "Content-Type: application/json" \
        -d "{\"rules\": $updated_rules}" \
        "$API_URL/$firewall_id/actions/set_rules"
}

# Start cleanup logic
if [ "$CLEANUP" == "false" ]; then
    log "Starting cleanup for firewall '$FIREWALL_NAME'..."
    firewall_id=$(get_firewall_id)

    if [ -z "$firewall_id" ]; then
        log "Error: Firewall '$FIREWALL_NAME' not found. Aborting."
        exit 1
    fi

    delete_rule_by_description "$firewall_id" "$DESCRIPTION"
    log "Cleanup process completed for description '$DESCRIPTION'."
    exit 0
fi
