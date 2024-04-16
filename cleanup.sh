#!/bin/bash

# Constants
readonly API_TOKEN="$1"
readonly HEADER="Authorization: Bearer $API_TOKEN"
readonly URL="https://api.hetzner.cloud/v1/firewalls"
readonly FIREWALL_NAME="$2"

get_firewall_id() {
    local firewall_name="$1"
    curl -s -H "$HEADER" "$URL" | jq -r --arg name "$firewall_name" '.firewalls[] | select(.name == $name) | .id'
}

firewall_id=$(get_firewall_id "$FIREWALL_NAME")

curl -X POST -H "$HEADER" -H "Content-Type: application/json" -d '{"rules": []}' "$URL/$firewall_id/actions/set_rules"
