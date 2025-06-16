#!/bin/bash

# Variables
SERVERS="server1.cloudage.global server2.cloudageglobal.com server3.cloudage.llc server4.cloudage.co.in"
#LOG_DIR="/var/logs/kafka"
LOG_DIR="/home/ubuntu/var/logs/kafka"
CURRENT_DATE=$(date +"%Y-%m-%d")
LOG_LINES=${1:-1000} # Number of log lines per server, can be overridden via CLI

# Create log directory if it doesn't exist
mkdir -p "$LOG_DIR"

# Function to generate a random IP address
random_ip() {
    echo "$((RANDOM % 256)).$((RANDOM % 256)).$((RANDOM % 256)).$((RANDOM % 256))"
}

# Function to generate a random log message
random_log_message() {
    MESSAGES="INFO: User logged in successfully|ERROR: Failed to connect to database|WARN: Disk usage is above 80%|DEBUG: Processing request|INFO: Backup completed"
    IFS='|' read -ra MESSAGE_ARRAY <<< "$MESSAGES"
    echo "${MESSAGE_ARRAY[$RANDOM % ${#MESSAGE_ARRAY[@]}]}"
}

# Generate dummy logs for each server
for SERVER in $SERVERS; do
    LOG_FILE="${LOG_DIR}/${SERVER}-${CURRENT_DATE}.log"
    echo "Generating dummy logs for $SERVER..."

    for ((i = 1; i <= LOG_LINES; i++)); do
        TIMESTAMP=$(date -d "-$((RANDOM % 4)) days -$((RANDOM % 24)) hours -$((RANDOM % 60)) minutes -$((RANDOM % 60)) seconds" +"%Y-%m-%d %H:%M:%S")
        IP=$(random_ip)
        MESSAGE=$(random_log_message)
        echo "$TIMESTAMP | $SERVER | $IP | $MESSAGE" >> "$LOG_FILE"

        if (( i % 100 == 0 )); then echo "  -> $i logs generated for $SERVER..."; fi
    done

    echo "Logs for $SERVER saved to ${LOG_FILE}"
done

echo "All dummy logs have been generated in $LOG_DIR"

exit 0
