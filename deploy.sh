#!/bin/bash

# Strict mode: exit immediately if a command exits with a non-zero status
set -e

clear
# EZAMPI
echo "=================================================="
echo "  Easy Stalker and Ministra Portal Installer      "
echo " ------------------------------------------------ "
echo "  Automated Deployment Engine   (c) 2026 suuhm    "
echo "=================================================="
echo ""

echo -n "Enter desired MySQL root password: "
read -s DB_PASSWORD
echo ""

if [ -z "$DB_PASSWORD" ]; then
    echo "[-] Error: Password cannot be empty."
    exit 1
fi

echo "STALKER_DB_PASSWORD=$DB_PASSWORD" > .env
echo "[+] Password written safely to .env file."
echo "[+] Starting clean deployment environment..."

docker compose down -v >/dev/null 2>&1 || true
docker compose up -d

echo "[+] Container infrastructure spawned."
echo "[+] Monitoring Phing deployment task. Please wait (approx. 3-4 minutes)..."
echo ""


draw_progress_bar() {
    local percentage=$1
    local width=40
    local filled=$(( percentage * width / 100 ))
    local empty=$(( width - filled ))
    
    local bar_filled=$(printf "%${filled}s" | tr ' ' '#')
    local bar_empty=$(printf "%${empty}s" | tr ' ' '-')
    
    printf "\rProgress: [%s%s] %d%%" "$bar_filled" "$bar_empty" "$percentage"
}

draw_progress_bar 0

docker compose logs -f stalker-portal 2>&1 | while read -r line; do
    if [[ "$line" == *"Stopping container-internal MySQL service"* ]]; then
        draw_progress_bar 10
    elif [[ "$line" == *"Waiting for external stalker-db container"* ]]; then
        draw_progress_bar 20
    elif [[ "$line" == *"Patching config.ini precise parameters"* ]]; then
        draw_progress_bar 30
    elif [[ "$line" == *"Executing essential Phing deployment"* ]]; then
        draw_progress_bar 40
    elif [[ "$line" == *"Executing command: apt-get -y install"* ]]; then
        draw_progress_bar 50
    elif [[ "$line" == *"Updating dependencies"* ]]; then
        draw_progress_bar 65
    elif [[ "$line" == *"IonCube installed: 1"* ]]; then
        draw_progress_bar 82
    elif [[ "$line" == *"Now run database migrations"* ]]; then
        draw_progress_bar 93
    elif [[ "$line" == *"BUILD FINISHED"* ]]; then
        draw_progress_bar 99
    elif [[ "$line" == *"Starting Apache permanently in foreground"* ]]; then
        draw_progress_bar 100
        echo -e "\n\n[+] Deployment successfully finished!"
        echo "[+] Portal URL: http://localhost:8080/stalker_portal/server/adm/"
        echo "[+] Default Credentials -> Username: admin | Password: 1"
        pkill -l -P $$ >/dev/null 2>&1 || true
        break
    fi
done 2>/dev/null

exit 0
