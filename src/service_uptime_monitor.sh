CONFIG_FILE="/etc/service_uptime_monitor.conf"
SERVICES=$(sed -n "/\[services\]/,/\[/{/\[/!{/^#/!{/\S/ p}}}" "$CONFIG_FILE")

for service in $SERVICES; do
    IFS="=" read -r name endpoint <<< "$service"

    echo "Checking service: $name"
    if systemctl is-active --quiet "$name"; then
        echo "Service '$name' is running. Checking endpoint..."
        response=$(curl -s -o /dev/null -w "%{http_code}" "$endpoint")
        if [[ "$response" -eq 200 ]]; then
            echo "Endpoint '$endpoint' is reachable. (HTTP 200)"
        else
            echo "Warning: Endpoint '$endpoint' is not reachable. (HTTP $response)"
        fi
    else
        echo "Service '$name' is not running."
    fi
done
