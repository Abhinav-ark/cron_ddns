#!/bin/bash

# Get the directory of the script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Load the .env file from the script's directory
source "$SCRIPT_DIR/.env"

# Log message function
log_message() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> "$LOG_FILE"
}

# Function to get the current IPv6 address
get_current_ipv6() {
    ip -6 addr show dev eth0 scope global | grep -oP 'inet6 \K[0-9a-f:]+(?=/)'
}

# Function to update the Cloudflare record
update_cloudflare_record() {
    local ipv6_address=$1
    response=$(curl -s -o /dev/null -w "%{http_code}" -X PUT \
        "https://api.cloudflare.com/client/v4/zones/$ZONE_ID/dns_records/$RECORD_ID" \
        -H "Authorization: Bearer $API_KEY" \
        -H "Content-Type: application/json" \
        --data "{\"type\":\"AAAA\",\"name\":\"$DNS_NAME\",\"content\":\"$ipv6_address\",\"ttl\":120,\"proxied\":false}")
    
    if [ "$response" -eq 200 ]; then
        log_message "Successfully updated Cloudflare record with IPv6: $ipv6_address"
    else
        log_message "Failed to update Cloudflare record. HTTP status: $response"
    fi
}

# Get the current IPv6 address
current_ipv6=$(get_current_ipv6)
log_message "Current IPv6 Address: $current_ipv6"

# Check the last known IPv6 address
if [ ! -s "$IP_FILE" ]; then
    log_message "IP file is empty. Storing current IPv6 and updating Cloudflare..."
    echo "$current_ipv6" > "$IP_FILE"
    update_cloudflare_record "$current_ipv6"
else
    last_ipv6=$(cat "$IP_FILE")
    log_message "Last IPv6 Address: $last_ipv6"

    if [ "$current_ipv6" != "$last_ipv6" ]; then
        log_message "IPv6 address has changed. Updating Cloudflare..."
        update_cloudflare_record "$current_ipv6"
        echo "$current_ipv6" > "$IP_FILE"
    else
        log_message "IPv6 address has not changed. No action needed."
    fi
fi
