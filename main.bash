#!/bin/bash

# Get the directory of the script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Load the .env file from the script's directory
source "$SCRIPT_DIR/.env"

chmod 777 "$SCRIPT_DIR/updateRecord.bash"

# Ensure the log file exists and is writable
if [ ! -f "$LOG_FILE" ]; then
    touch "$LOG_FILE"
    chmod 777 "$LOG_FILE"
fi

# Log message function
log_message() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> "$LOG_FILE"
}

# Ensure the IP file exists
if [ ! -f "$IP_FILE" ]; then
    log_message "IP file does not exist. Creating it now..."
    touch "$IP_FILE"
    chmod 777 "$IP_FILE"
fi

bash "$SCRIPT_DIR/updateRecord.bash"

# Schedule the script in cron if not already scheduled
CRON_JOB="*/1 * * * * $SCRIPT_DIR/updateRecord.bash"
if ! crontab -l 2>/dev/null | grep -q "$SCRIPT_DIR/updateRecord.bash"; then
    log_message "Scheduling the script to run every 5 minutes..."
    (crontab -l 2>/dev/null; echo "$CRON_JOB") | crontab -
    log_message "Script successfully scheduled in crontab."
fi

