#!/bin/bash

# Define installation paths
SCRIPT_SRC="src/service_uptime_monitor.sh"
CONFIG_SRC="src/service_uptime_monitor.conf"
CRON_SRC="src/service_uptime_monitor_cron"
LOGROTATE_SRC="src/service_uptime_monitor_logrotate"
CRON_DEST="/etc/cron.d/service_uptime_monitor"
SCRIPT_DEST="/usr/local/bin/service_uptime_monitor.sh"
CONFIG_DEST="/etc/service_uptime_monitor.conf"
LOG_FILE="/var/log/service_uptime_monitor.log"
LOGROTATE_DEST="/etc/logrotate.d/service_uptime_monitor"

# Check for root privileges
if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root. Use sudo." >&2
    exit 1
fi

echo "Installing service_uptime_monitor script and configuration..."

# Copy script
echo "Copying script to $SCRIPT_DEST..."
cp "$SCRIPT_SRC" "$SCRIPT_DEST"
chmod +x "$SCRIPT_DEST"

# Set up configuration
echo "Setting up configuration..."
cp "$CONFIG_SRC" "$CONFIG_DEST"
chmod 600 "$CONFIG_DEST"

while true; do
    read -p "Enter service name (or press Enter to finish): " service_name
    if [ -z "$service_name" ]; then
        break
    fi
    read -p "Enter Uptime Kuma endpoint URL for $service_name: " endpoint_url
    echo "$service_name=$endpoint_url" >> "$CONFIG_DEST"
done

# Copy cron file
echo "Installing cron job at $CRON_DEST..."
cp "$CRON_SRC" "$CRON_DEST"
chmod 644 "$CRON_DEST"

# Ensure log file exists
echo "Creating log file at $LOG_FILE..."
touch "$LOG_FILE"
chmod 644 "$LOG_FILE"

# Copy logrotate file
echo "Installing logrotate configuration at $LOGROTATE_DEST..."
cp "$LOGROTATE_SRC" "$LOGROTATE_DEST"
chmod 644 "$LOGROTATE_DEST"

# Test the script
echo "Testing the script..."
"$SCRIPT_DEST"

# Check the exit status of the test
if [ $? -eq 0 ]; then
    echo "Test successful!"
else
    echo "Test failed. Please check the configuration and try again."
    exit 1
fi

echo "Installation complete!"
