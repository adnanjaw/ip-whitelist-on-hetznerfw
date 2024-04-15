#!/bin/bash

# Constants
readonly API_TOKEN="$1"
readonly HEADER="Authorization: Bearer $API_TOKEN"
readonly URL="https://api.hetzner.cloud/v1/firewalls"
readonly FIREWALL_NAME="$3"

# Functions
get_firewall_id() {
    local firewall_name="$1"
    curl -s -H "$HEADER" "$URL" | jq -r --arg name "$firewall_name" '.firewalls[] | select(.name == $name) | .id'
}

add_rule() {
    local description="$1"
    local direction="$2"
    local port="$3"
    local protocol="$4"
    local ips="$5"
    local direction_ips

    direction_ips='source_ips'
    if "$direction" = 'out'; then
      direction_ips='destination_ips'
    fi

    printf '{"description":"%s","direction":"%s","port":"%s","protocol":"%s","%s":[%s]}' "$description" "$direction" "$port" "$protocol" "$direction_ips" "$ips"
}

update_firewall_rules() {
    local firewall_id="$1"
    local new_rule="$2"
    local existing_rules
    local updated_rules

    existing_rules=$(curl -s -H "$HEADER" "$URL/$firewall_id" | jq -r '.firewall.rules')
    updated_rules=$(jq --argjson existing_rules "$existing_rules" --argjson new_rule "$new_rule" '.rules = ($existing_rules + [$new_rule])' <<< '{}' )

    curl -X POST -H "$HEADER" -H "Content-Type: application/json" -d "$updated_rules" "$URL/$firewall_id/actions/set_rules"
}

check_error() {
    local response="$1"
    local error_message

    error_message=$(jq -r '.error.message' <<< "$response")

    if [ "$error_message" != "null" ]; then
        echo "Error: $error_message"
    else
        echo "Firewall rules updated successfully."
    fi
}

# Main script
firewall_id=$(get_firewall_id "$FIREWALL_NAME")
if [ -n "$firewall_id" ]; then
    echo "Firewall ID for '$FIREWALL_NAME': $firewall_id"
else
    echo "Firewall '$FIREWALL_NAME' not found."
fi

new_rule=$(add_rule "$4" "$5" "$7" "$6" "$2")

existing_rules=$(curl -s -H "$HEADER" "$URL/$firewall_id" | jq -r '.firewall.rules')

response=$(update_firewall_rules "$firewall_id" "$new_rule")

check_error "$response"