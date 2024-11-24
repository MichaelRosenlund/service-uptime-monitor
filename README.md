# Uptime Kuma Systemd Monitor

A lightweight Bash-based monitoring tool that checks system services and reports their status to [Uptime Kuma](https://github.com/louislam/uptime-kuma). This project ensures that services are running as expected and automatically updates Uptime Kuma through predefined HTTP endpoints.

## Features

- Checks the status of systemd-managed services.
- Reports service statuses to Uptime Kuma endpoints.
- Configurable via a simple YAML file.
- Automates monitoring using cron jobs.
- Outputs logs for troubleshooting and tracking.

---

## Installation

### 1. Clone the Repository

```bash
git clone https://github.com/MichaelRosenlund/service-uptime-monitor.git
cd service-uptime-monitor
```

### 2. Modify Configuration

Edit src/service_uptime_monitor.conf to include the services you want to monitor and their corresponding Uptime Kuma endpoints.

Example:

```conf
[services]
nginx=http://uptime-kuma.local/api/push/some-unique-id?status=up
mysql=http://uptime-kuma.local/api/push/another-unique-id?status=up
```

### 3. Run the Installation Script

```bash
sudo bash ./install.sh
```

This will:

1. Copy the script to /usr/local/bin.
2. Copy the configuration file to /etc/service_uptime_monitor.conf.
3. Set up a cron job in /etc/cron.d.
4. Create a log file in /var/log/service_uptime_monitor.log.

### 4. Verify Installation

Ensure the cron job is installed:

```bash
sudo cat /etc/cron.d/service_uptime_monitor
```

Check the log file for activity:

```bash
tail -f /var/log/service_uptime_monitor.log
```

## How It Works

### Configuration File

Define services and their Uptime Kuma endpoints in service_uptime_monitor. Each service should have its systemd service name and an associated HTTP endpoint.

### Script

The script service_uptime_monitor.sh:

- Checks the status of each service using systemctl is-active.
- Sends an HTTP request to the corresponding Uptime Kuma endpoint based on the status.

### Cron Job

The cron job ensures the script runs every 10 minutes (configurable).

## Configuration

### Example `service_uptime_monitor.conf`

Config file

```conf
[services]
nginx=http://uptime-kuma.local/api/push/some-unique-id?status=up
mysql=http://uptime-kuma.local/api/push/another-unique-id?status=up
```

Cron file

```text
*/10 * * * * root /usr/local/bin/service_uptime_monitor.sh >> /var/log/service_uptime_monitor.log 2>&1
```

### Log File

Logs are written to /var/log/service_uptime_monitor.log.

## Uninstallation

To uninstall the tool:

1. Remove the script:

```bash
sudo rm /usr/local/bin/service_uptime_monitor.sh
```

2. Remove the configuration file:

```bash
sudo rm /etc/service_uptime_monitor.conf
```

3. Remove the cron job:

```bash
sudo rm /etc/cron.d/service_uptime_monitor
```

4. Remove the log file (optional):

```bash
sudo rm /var/log/service_uptime_monitor.log
```

5. Remove the logrotate configuration:

```bash
sudo rm /etc/logrotate.d/service_uptime_monitor
```

## Requirements

Linux with systemd
Bash
Cron
Curl (for HTTP requests)

## License

This project is licensed under the MIT License. See the LICENSE file for details.

## Acknowledgments

Uptime Kuma for providing an excellent self-hosted monitoring tool.
