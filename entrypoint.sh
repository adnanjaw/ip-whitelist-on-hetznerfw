#!/bin/bash

set -euo pipefail

# Constants
readonly API_TOKEN="$1"
readonly HEADER="Authorization: Bearer $API_TOKEN"
readonly URL="https://api.hetzner.cloud/v1/firewalls"
readonly FIREWALL_NAME="$2"
readonly IP_ADDRESS="$3"
readonly PORT="$4"
readonly PROTOCOL="$5"
readonly DIRECTION="$6"
readonly DESCRIPTION="${7:-"github-actions-rule"}"

# Logging
log() {
    echo "[$(date +'%F %T')] $*"
}

# Functions
get_firewall_id() {
    local firewall_name="$1"
    curl -s -H "$HEADER" "$URL" | jq -r --arg name "$firewall_name" '.firewalls[] | select(.name == $name) | .id'
}

# Get IP in CIDR format
retrieve_cidr_info() {
    local ip="$1"
    if [[ "$ip" == *:* ]]; then
        echo "$ip/128"  # IPv6
    else
        echo "$ip/32"   # IPv4
    fi
}

# Build rule JSON
add_rule() {
    local cidr_ip
    cidr_ip=$(retrieve_cidr_info "$1")
    local port="$2"
    local protocol="$3"
    local direction="$4"
    local description="$5"
    local direction_key="source_ips"

    if [[ "$direction" == "out" ]]; then
        direction_key="destination_ips"
    fi

    jq -n \
        --arg desc "$description" \
        --arg dir "$direction" \
        --arg port "$port" \
        --arg proto "$protocol" \
        --arg key "$direction_key" \
        --arg ip "$cidr_ip" \
        '{
            description: $desc,
            direction: $dir,
            port: $port,
            protocol: $proto
        } + {($key): [$ip]}'
}

# Update firewall rules
update_firewall_rules() {
    local firewall_id="$1"
    local new_rule="$2"

    local existing_rules
    existing_rules=$(curl -s -H "$HEADER" "$URL/$firewall_id" | jq '.firewall.rules')

    local updated_rules
    updated_rules=$(jq --argjson rules "$existing_rules" --argjson new "$new_rule" '{rules: ($rules + [$new])}' <<< '{}')

    curl -s -X POST -H "$HEADER" -H "Content-Type: application/json" \
        -d "$updated_rules" \
        "$URL/$firewall_id/actions/set_rules"
}

# Handle API errors
check_error() {
    local response="$1"
    local error_message
    error_message=$(jq -r '.error.message // empty' <<< "$response")

    if [ -n "$error_message" ]; then
        log "❌ Error: $error_message"
        exit 1
    else
        log "Firewall rules updated successfully."
    fi
}

# MAIN
firewall_id=$(get_firewall_id "$FIREWALL_NAME")

if [ -z "$firewall_id" ]; then
    log "Firewall '$FIREWALL_NAME' not found."
    exit 1
else
    log "Found firewall ID: $firewall_id"
fi

new_rule=$(add_rule "$IP_ADDRESS" "$PORT" "$PROTOCOL" "$DIRECTION" "$DESCRIPTION")
response=$(update_firewall_rules "$firewall_id" "$new_rule")

check_error "$response"
