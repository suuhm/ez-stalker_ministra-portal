# Easy Automated Stalker Portal Deployment with External MySQL 5.7

This repository provides a fully automated, production-ready `docker-compose` setup for running a legacy Infomir Stalker Portal (Ministra Middleware) inside an isolated Docker environment. It automatically resolves severe legacy software conflicts, forces English locales, and bypasses deactivated Composer 1.x repositories online.

<img width="660" height="270" alt="grafik" src="https://github.com/user-attachments/assets/361c0a0b-4705-4da0-9f86-630985367ca4" />


## Features
- **Automated Phing Migration:** Automatically patches and handles framework database migrations.
- **Offline Composer Fallback:** Bypasses broken Packagist v1 endpoints by forcing pre-installed image dependencies.
- **Progress Monitoring:** Includes a native Bash script with a visual progress bar tracking deployment milestones.
- **Language Enforcement:** Enforces English (`en_GB.utf8`) for both the Admin Backend and STB Middleware Client Frontend.

## Prerequisites
- Docker & Docker Compose plugin installed
- Bash-compatible shell (e.g., Kali Linux, Ubuntu, Debian)

## Usage

1. **Clone the repository:**
   ```bash
   git clone https://github.com/suuhm/ez-stalker_ministra-portal /opt/ez-stalker
   cd /opt/ez-stalker
   ```

2. **Make the deployment script executable:**
   ```bash
   chmod +x deploy.sh
   ```

3. **Run the deployment:**
   ```bash
   ./deploy.sh
   ```
   *You will be securely prompted to enter your desired MySQL root password.*

<img width="561" height="327" alt="grafik" src="https://github.com/user-attachments/assets/88db8e4b-426f-4070-ba82-d781d236871b" />


4. **Access the Portal:**
   - **Admin Panel:** `http://localhost:8080/stalker_portal/server/adm/`
   - **Default Credentials:** Username: `admin` | Password: `1`

## Architecture Note
The container uses `slaserx/stalker-portal:latest` mapped from internal Apache Port `88` to Host Port `8080`. Data is stored persistently in the `stalker_db_data` Docker volume.
