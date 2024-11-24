#!/bin/bash

# Define installation paths
SCRIPT_SRC="src/service_uptime_monitor.sh"
CONFIG_SRC="src/service_uptime_monitor.conf"
CRON_SRC="src/service_uptime_monitor"
CRON_DEST="/etc/cron.d/service_uptime_monitor"
SCRIPT_DEST="/usr/local/bin/service_uptime_monitor.sh"
CONFIG_DEST="/etc/service_uptime_monitor.conf"
LOG_FILE="/var/log/service_uptime_monitor.log"

# Check for root privileges
if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root. Use sudo." >&2
    exit 1
fi

echo "Installing service_uptime_monitor script and configuration..."

# Create destination directories
echo "Creating necessary directories..."
mkdir -p /etc/service_uptime_monitor
mkdir -p /var/log

# Copy script
echo "Copying script to $SCRIPT_DEST..."
cp "$SCRIPT_SRC" "$SCRIPT_DEST"
chmod +x "$SCRIPT_DEST"

# Copy config file
echo "Copying configuration to $CONFIG_DEST..."
cp "$CONFIG_SRC" "$CONFIG_DEST"
chmod 600 "$CONFIG_DEST"

# Copy cron file
echo "Installing cron job at $CRON_DEST..."
cp "$CRON_SRC" "$CRON_DEST"
chmod 644 "$CRON_DEST"

# Ensure log file exists
echo "Creating log file at $LOG_FILE..."
touch "$LOG_FILE"
chmod 644 "$LOG_FILE"

# Reload cron service
echo "Reloading cron service..."
systemctl reload cron

echo "Installation complete!"
