# AgenticLedger Database - Complete Deployment Guide

## Choose Your Deployment Scenario

Select the scenario that matches your needs and follow that section:

| Scenario | Best For | Time | Difficulty |
|----------|----------|------|------------|
| [1. Personal Computer (Development)](#scenario-1-personal-computer-development) | Developers, Testing | 2-5 min | ⭐ Easy |
| [2. Small Business Server](#scenario-2-small-business-server) | Small teams, Local office | 10 min | ⭐⭐ Medium |
| [3. AWS EC2 (Cloud VM)](#scenario-3-aws-ec2-cloud-vm) | Startups, Medium businesses | 15 min | ⭐⭐ Medium |
| [4. Azure Virtual Machine](#scenario-4-azure-virtual-machine) | Microsoft-centric companies | 15 min | ⭐⭐ Medium |
| [5. Google Cloud VM](#scenario-5-google-cloud-vm) | Google Cloud customers | 15 min | ⭐⭐ Medium |
| [6. DigitalOcean Droplet](#scenario-6-digitalocean-droplet) | Simple cloud hosting | 10 min | ⭐⭐ Medium |
| [7. AWS RDS (Managed Database)](#scenario-7-aws-rds-managed-database) | No server management | 20 min | ⭐⭐⭐ Advanced |
| [8. Azure Database for PostgreSQL](#scenario-8-azure-database-for-postgresql) | Managed Azure solution | 20 min | ⭐⭐⭐ Advanced |
| [9. Kubernetes Cluster](#scenario-9-kubernetes-cluster) | Large enterprises, High availability | 30 min | ⭐⭐⭐⭐ Expert |
| [10. On-Premises Data Center](#scenario-10-on-premises-data-center) | Compliance, Air-gapped | 20 min | ⭐⭐⭐ Advanced |

---

# Scenario 1: Personal Computer (Development)

**Perfect for:** Developers testing locally, personal projects, learning

**What you need:**
- Windows, Mac, or Linux computer
- Docker Desktop installed OR PostgreSQL installed

**Where database runs:** Your laptop/desktop at `localhost:5432`

---

## Option A: Using Docker (Recommended)

### Step 1: Install Docker Desktop
- **Windows/Mac:** Download from https://www.docker.com/products/docker-desktop/
- **Linux:** `sudo apt-get install docker.io docker-compose`

### Step 2: Download This Repository

**Option 2A: Download ZIP**
1. Go to: https://github.com/oregpt/Agenticledger_BringYourOwnStorage_repo
2. Click green "Code" button → "Download ZIP"
3. Extract ZIP to a folder (e.g., `C:\AgenticLedger` or `~/AgenticLedger`)

**Option 2B: Git Clone**
```bash
git clone https://github.com/oregpt/Agenticledger_BringYourOwnStorage_repo.git
cd Agenticledger_BringYourOwnStorage_repo
```

### Step 3: Configure Password (Optional)

```bash
# Windows PowerShell
Copy-Item .env.example .env
notepad .env

# Mac/Linux
cp .env.example .env
nano .env
```

Change `DB_PASSWORD` to your own password (or skip to auto-generate).

### Step 4: Start Database

```bash
docker-compose up -d
```

**Wait 10-30 seconds for database to start.**

### Step 5: Verify It's Running

```bash
docker-compose ps
```

You should see:
```
NAME                 STATUS
agenticledger_db     Up
```

### Step 6: Get Connection Details

```bash
# Windows
type .env

# Mac/Linux
cat .env
```

**Your connection string:**
```
postgresql://platform_user:your-password@localhost:5432/agenticledger_customer_db
```

✅ **Done! Database running on your computer.**

---

## Option B: Using Existing PostgreSQL

### Step 1: Verify PostgreSQL is Installed

```bash
# Windows
psql --version

# Mac
psql --version

# Linux
psql --version
```

If not installed:
- **Windows:** https://www.postgresql.org/download/windows/
- **Mac:** `brew install postgresql@17`
- **Linux:** `sudo apt-get install postgresql postgresql-contrib`

### Step 2: Download Repository

```bash
git clone https://github.com/oregpt/Agenticledger_BringYourOwnStorage_repo.git
cd Agenticledger_BringYourOwnStorage_repo
```

### Step 3: Run Setup Script

**Windows (PowerShell as Administrator):**
```powershell
.\setup.ps1
```

**Mac/Linux:**
```bash
chmod +x setup.sh
sudo ./setup.sh
```

The script will:
- ✅ Check PostgreSQL is running
- ✅ Install pgvector extension
- ✅ Create database and tables
- ✅ Generate secure password
- ✅ Create `.env` file

### Step 4: Get Connection Details

Script will display:
```
================================================================
Installation Complete!
================================================================

Your connection details:
  Host:     localhost
  Port:     5432
  Database: agenticledger_customer_db
  User:     platform_user
  Password: <generated-password>
```

✅ **Done! Database running on your computer.**

---

# Scenario 2: Small Business Server

**Perfect for:** Small team with a Windows/Linux server in the office

**What you need:**
- Office server (Windows Server or Linux)
- Access to the server (RDP or SSH)

**Where database runs:** Your office server at `server-ip:5432`

---

## Step 1: Access Your Server

**Windows Server:**
- Use Remote Desktop (RDP) to connect

**Linux Server:**
```bash
ssh your-username@your-server-ip
```

## Step 2: Install Docker

**Windows Server:**
1. Download Docker Desktop: https://www.docker.com/products/docker-desktop/
2. Install and restart

**Linux Server:**
```bash
sudo apt-get update
sudo apt-get install -y docker.io docker-compose
sudo systemctl start docker
sudo systemctl enable docker
sudo usermod -aG docker $USER
```

Log out and back in for group changes to take effect.

## Step 3: Download Repository

```bash
git clone https://github.com/oregpt/Agenticledger_BringYourOwnStorage_repo.git
cd Agenticledger_BringYourOwnStorage_repo
```

## Step 4: Configure

```bash
cp .env.example .env
nano .env  # or notepad .env on Windows
```

Set a strong password:
```env
DB_PASSWORD=YourSecurePassword123!@#WithMinimum32Characters
```

## Step 5: Deploy

```bash
docker-compose up -d
```

## Step 6: Configure Firewall

**Linux (UFW):**
```bash
sudo ufw allow 5432/tcp
```

**Windows Server:**
1. Open Windows Firewall
2. New Inbound Rule → Port → TCP 5432 → Allow

## Step 7: Get Server IP Address

**Linux:**
```bash
hostname -I
```

**Windows:**
```powershell
ipconfig
```

**Your connection string:**
```
postgresql://platform_user:your-password@192.168.1.100:5432/agenticledger_customer_db
```
(Replace `192.168.1.100` with your actual server IP)

✅ **Done! Team can connect from any computer on your network.**

---

# Scenario 3: AWS EC2 (Cloud VM)

**Perfect for:** Startups, medium businesses, scalable cloud deployment

**What you need:**
- AWS account
- Basic AWS knowledge

**Where database runs:** AWS cloud at `ec2-xx-xxx-xxx-xx.compute.amazonaws.com:5432`

---

## Step 1: Create EC2 Instance

1. Log into AWS Console → EC2
2. Click "Launch Instance"
3. **Choose AMI:** Ubuntu Server 22.04 LTS
4. **Instance Type:**
   - Small: `t3.medium` (2 vCPU, 4GB RAM) - ~$30/month
   - Medium: `t3.xlarge` (4 vCPU, 16GB RAM) - ~$120/month
5. **Configure Security Group:**
   - SSH (port 22) - Your IP only
   - PostgreSQL (port 5432) - Your application IP only
6. **Storage:** 20GB - 100GB gp3 SSD
7. Click "Launch"
8. Download the key pair (e.g., `my-key.pem`)

## Step 2: Connect to EC2 Instance

```bash
chmod 400 my-key.pem
ssh -i my-key.pem ubuntu@ec2-xx-xxx-xxx-xx.compute.amazonaws.com
```

## Step 3: Install Docker

```bash
sudo apt-get update
sudo apt-get install -y docker.io docker-compose
sudo systemctl start docker
sudo systemctl enable docker
sudo usermod -aG docker ubuntu
```

Log out and back in:
```bash
exit
ssh -i my-key.pem ubuntu@ec2-xx-xxx-xxx-xx.compute.amazonaws.com
```

## Step 4: Download Repository

```bash
git clone https://github.com/oregpt/Agenticledger_BringYourOwnStorage_repo.git
cd Agenticledger_BringYourOwnStorage_repo
```

## Step 5: Configure

```bash
cp .env.example .env
nano .env
```

Set strong password (32+ characters):
```env
DB_PASSWORD=SuperSecure_AWS_Password_2025_aB3$xY9#mK2!pQ7@vL5%
```

## Step 6: Deploy

```bash
docker-compose up -d
```

## Step 7: Verify Running

```bash
docker-compose ps
```

## Step 8: Get Connection Details

**Your EC2 public DNS:**
```bash
ec2-metadata --public-hostname
```

**Your connection string:**
```
postgresql://platform_user:your-password@ec2-18-123-45-67.compute.amazonaws.com:5432/agenticledger_customer_db
```

## Step 9: (Optional) Elastic IP

For a permanent IP address:
1. AWS Console → EC2 → Elastic IPs
2. Allocate new address
3. Associate with your instance

## Step 10: (Optional) Automated Backups to S3

```bash
# Install AWS CLI
sudo apt-get install -y awscli

# Configure credentials
aws configure

# Create backup script
cat > /home/ubuntu/backup.sh << 'EOF'
#!/bin/bash
DATE=$(date +%Y%m%d_%H%M%S)
docker-compose exec -T postgres pg_dump -U platform_user agenticledger_customer_db | gzip > /tmp/backup_$DATE.sql.gz
aws s3 cp /tmp/backup_$DATE.sql.gz s3://your-backup-bucket/backups/
rm /tmp/backup_$DATE.sql.gz
EOF

chmod +x /home/ubuntu/backup.sh

# Add to crontab (daily at 2 AM)
crontab -e
# Add: 0 2 * * * /home/ubuntu/backup.sh
```

✅ **Done! Database running on AWS.**

---

# Scenario 4: Azure Virtual Machine

**Perfect for:** Companies using Microsoft Azure, enterprise Windows environments

**What you need:**
- Azure account
- Basic Azure knowledge

**Where database runs:** Azure cloud at `your-vm.eastus.cloudapp.azure.com:5432`

---

## Step 1: Create Azure VM

1. Log into Azure Portal
2. Click "Create a resource" → "Virtual Machine"
3. **Basics:**
   - Resource Group: Create new or use existing
   - VM Name: `agenticledger-db`
   - Region: Choose nearest to you
   - Image: **Ubuntu Server 22.04 LTS**
   - Size:
     - Small: `Standard_B2s` (2 vCPU, 4GB RAM) - ~$30/month
     - Medium: `Standard_D4s_v3` (4 vCPU, 16GB RAM) - ~$140/month
4. **Authentication:**
   - SSH public key (generate or use existing)
5. **Disks:**
   - OS Disk: 30GB - 100GB Premium SSD
6. **Networking:**
   - Create new Virtual Network
   - **Inbound port rules:** SSH (22), PostgreSQL (5432)
7. Click "Review + Create"

## Step 2: Configure Network Security Group

1. Go to VM → Networking → Network Security Group
2. Add inbound rule:
   - Port: 5432
   - Protocol: TCP
   - Source: Your application IP (or "Any" temporarily)
   - Priority: 310

## Step 3: Connect to VM

```bash
ssh azureuser@your-vm.eastus.cloudapp.azure.com
```

## Step 4: Install Docker

```bash
sudo apt-get update
sudo apt-get install -y docker.io docker-compose
sudo systemctl start docker
sudo systemctl enable docker
sudo usermod -aG docker azureuser
```

Log out and back in:
```bash
exit
ssh azureuser@your-vm.eastus.cloudapp.azure.com
```

## Step 5: Download Repository

```bash
git clone https://github.com/oregpt/Agenticledger_BringYourOwnStorage_repo.git
cd Agenticledger_BringYourOwnStorage_repo
```

## Step 6: Configure

```bash
cp .env.example .env
nano .env
```

Set strong password:
```env
DB_PASSWORD=Azure_Secure_Password_2025_mN8$kP4#zX9!qR7@wT3%
```

## Step 7: Deploy

```bash
docker-compose up -d
```

## Step 8: Verify Running

```bash
docker-compose ps
```

## Step 9: Get Connection Details

**Your Azure DNS name:**
- Go to Azure Portal → VM → Overview
- Copy "DNS name" (e.g., `agenticledger-db.eastus.cloudapp.azure.com`)

**Your connection string:**
```
postgresql://platform_user:your-password@agenticledger-db.eastus.cloudapp.azure.com:5432/agenticledger_customer_db
```

## Step 10: (Optional) Automated Backups to Azure Blob

```bash
# Install Azure CLI
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash

# Login
az login

# Create backup script
cat > /home/azureuser/backup.sh << 'EOF'
#!/bin/bash
DATE=$(date +%Y%m%d_%H%M%S)
docker-compose exec -T postgres pg_dump -U platform_user agenticledger_customer_db | gzip > /tmp/backup_$DATE.sql.gz
az storage blob upload --account-name yourstorageaccount --container-name backups --file /tmp/backup_$DATE.sql.gz --name backup_$DATE.sql.gz
rm /tmp/backup_$DATE.sql.gz
EOF

chmod +x /home/azureuser/backup.sh

# Add to crontab (daily at 2 AM)
crontab -e
# Add: 0 2 * * * /home/azureuser/backup.sh
```

✅ **Done! Database running on Azure.**

---

# Scenario 5: Google Cloud VM

**Perfect for:** Google Cloud Platform customers, modern cloud infrastructure

**What you need:**
- Google Cloud account
- gcloud CLI installed (optional)

**Where database runs:** GCP cloud at `your-instance-ip:5432`

---

## Step 1: Create Compute Engine Instance

1. Log into Google Cloud Console
2. Navigate to **Compute Engine** → **VM Instances**
3. Click "Create Instance"
4. **Configuration:**
   - Name: `agenticledger-db`
   - Region: Choose nearest to you
   - Machine type:
     - Small: `e2-medium` (2 vCPU, 4GB RAM) - ~$25/month
     - Medium: `e2-standard-4` (4 vCPU, 16GB RAM) - ~$120/month
   - Boot disk: **Ubuntu 22.04 LTS**, 20GB - 100GB SSD
5. **Firewall:**
   - ✅ Allow HTTP traffic
   - ✅ Allow HTTPS traffic
6. Click "Create"

## Step 2: Configure Firewall Rules

1. Go to **VPC Network** → **Firewall**
2. Click "Create Firewall Rule"
3. **Configuration:**
   - Name: `allow-postgresql`
   - Targets: All instances in network
   - Source IP ranges: Your application IP (or `0.0.0.0/0` temporarily)
   - Protocols and ports: `tcp:5432`
4. Click "Create"

## Step 3: Connect to Instance

**Option A: Browser SSH (easiest)**
1. Go to Compute Engine → VM Instances
2. Click "SSH" button next to your instance

**Option B: gcloud CLI**
```bash
gcloud compute ssh agenticledger-db --zone=us-central1-a
```

## Step 4: Install Docker

```bash
sudo apt-get update
sudo apt-get install -y docker.io docker-compose
sudo systemctl start docker
sudo systemctl enable docker
sudo usermod -aG docker $USER
```

Log out and back in:
```bash
exit
# Then reconnect
```

## Step 5: Download Repository

```bash
git clone https://github.com/oregpt/Agenticledger_BringYourOwnStorage_repo.git
cd Agenticledger_BringYourOwnStorage_repo
```

## Step 6: Configure

```bash
cp .env.example .env
nano .env
```

Set strong password:
```env
DB_PASSWORD=GCP_Secure_Password_2025_pL6$nM9#vX4!qK8@wR2%
```

## Step 7: Deploy

```bash
docker-compose up -d
```

## Step 8: Verify Running

```bash
docker-compose ps
```

## Step 9: Get External IP

```bash
curl ifconfig.me
```

Or from GCP Console → Compute Engine → VM Instances (see "External IP")

## Step 10: Reserve Static IP (Optional)

1. Go to **VPC Network** → **External IP addresses**
2. Find your instance's IP → Change from "Ephemeral" to "Static"
3. Give it a name

**Your connection string:**
```
postgresql://platform_user:your-password@35.123.45.67:5432/agenticledger_customer_db
```

## Step 11: (Optional) Automated Backups to Cloud Storage

```bash
# Install gsutil (usually pre-installed)
gcloud auth login

# Create backup script
cat > /home/$USER/backup.sh << 'EOF'
#!/bin/bash
DATE=$(date +%Y%m%d_%H%M%S)
docker-compose exec -T postgres pg_dump -U platform_user agenticledger_customer_db | gzip > /tmp/backup_$DATE.sql.gz
gsutil cp /tmp/backup_$DATE.sql.gz gs://your-backup-bucket/backups/
rm /tmp/backup_$DATE.sql.gz
EOF

chmod +x /home/$USER/backup.sh

# Add to crontab (daily at 2 AM)
crontab -e
# Add: 0 2 * * * /home/$USER/backup.sh
```

✅ **Done! Database running on Google Cloud.**

---

# Scenario 6: DigitalOcean Droplet

**Perfect for:** Simple cloud hosting, developers, small businesses

**What you need:**
- DigitalOcean account

**Where database runs:** DigitalOcean at `your-droplet-ip:5432`

---

## Step 1: Create Droplet

1. Log into DigitalOcean
2. Click "Create" → "Droplets"
3. **Choose Image:** Ubuntu 22.04 LTS
4. **Choose Plan:**
   - Basic: $12/month (1 vCPU, 2GB RAM, 50GB SSD)
   - Regular: $24/month (2 vCPU, 4GB RAM, 80GB SSD)
   - Performance: $48/month (4 vCPU, 8GB RAM, 160GB SSD)
5. **Choose datacenter:** Nearest to you
6. **Authentication:** SSH key (recommended) or password
7. **Hostname:** `agenticledger-db`
8. Click "Create Droplet"

## Step 2: Configure Firewall

1. Go to **Networking** → **Firewalls**
2. Click "Create Firewall"
3. **Name:** `agenticledger-firewall`
4. **Inbound Rules:**
   - SSH (22) - Your IP
   - Custom (5432) - Your application IP (or All)
5. **Apply to Droplets:** Select your droplet
6. Click "Create Firewall"

## Step 3: Connect to Droplet

```bash
ssh root@your-droplet-ip
```

## Step 4: Install Docker

```bash
apt-get update
apt-get install -y docker.io docker-compose
systemctl start docker
systemctl enable docker
```

## Step 5: Download Repository

```bash
git clone https://github.com/oregpt/Agenticledger_BringYourOwnStorage_repo.git
cd Agenticledger_BringYourOwnStorage_repo
```

## Step 6: Configure

```bash
cp .env.example .env
nano .env
```

Set strong password:
```env
DB_PASSWORD=DigitalOcean_Secure_2025_xK9$mP4#vN8!qL7@wT3%
```

## Step 7: Deploy

```bash
docker-compose up -d
```

## Step 8: Verify Running

```bash
docker-compose ps
```

## Step 9: Get Connection Details

**Your droplet IP:**
```bash
curl ifconfig.me
```

Or check DigitalOcean dashboard.

**Your connection string:**
```
postgresql://platform_user:your-password@164.123.45.67:5432/agenticledger_customer_db
```

## Step 10: (Optional) Automated Backups to Spaces

```bash
# Install s3cmd
apt-get install -y s3cmd

# Configure Spaces
s3cmd --configure

# Create backup script
cat > /root/backup.sh << 'EOF'
#!/bin/bash
DATE=$(date +%Y%m%d_%H%M%S)
docker-compose exec -T postgres pg_dump -U platform_user agenticledger_customer_db | gzip > /tmp/backup_$DATE.sql.gz
s3cmd put /tmp/backup_$DATE.sql.gz s3://your-space-name/backups/
rm /tmp/backup_$DATE.sql.gz
EOF

chmod +x /root/backup.sh

# Add to crontab (daily at 2 AM)
crontab -e
# Add: 0 2 * * * /root/backup.sh
```

✅ **Done! Database running on DigitalOcean.**

---

# Scenario 7: AWS RDS (Managed Database)

**Perfect for:** No server management, automatic backups, enterprise scale

**What you need:**
- AWS account
- Comfort with managed databases

**Where database runs:** AWS RDS at `your-db.abc123.us-east-1.rds.amazonaws.com:5432`

**Note:** RDS manages the PostgreSQL instance - you only run the schema scripts.

---

## Step 1: Create RDS Instance

1. Log into AWS Console → RDS
2. Click "Create database"
3. **Engine:** PostgreSQL
4. **Version:** 14.x or higher (must support pgvector)
5. **Template:**
   - Dev/Test (cheaper)
   - Production (high availability)
6. **DB Instance Identifier:** `agenticledger-db`
7. **Master username:** `postgres`
8. **Master password:** Set strong password
9. **Instance Configuration:**
   - Small: `db.t3.micro` - ~$15/month
   - Medium: `db.t3.medium` - ~$60/month
   - Large: `db.m5.large` - ~$140/month
10. **Storage:** 20GB - 100GB gp3
11. **Connectivity:**
    - VPC: Default
    - Public access: Yes (or No if using VPC peering)
    - Security group: Create new
12. **Additional Configuration:**
    - Initial database name: `postgres`
    - Backup retention: 7 days
    - Enable Enhanced Monitoring
13. Click "Create database"

**Wait 5-10 minutes for creation.**

## Step 2: Configure Security Group

1. Go to RDS → Databases → Your database
2. Click on VPC security group
3. Edit inbound rules → Add rule:
   - Type: PostgreSQL
   - Port: 5432
   - Source: Your application IP (or My IP for testing)

## Step 3: Install pgvector Extension

```bash
# From your computer (or EC2 instance)
# Install PostgreSQL client
sudo apt-get install -y postgresql-client

# Connect to RDS
psql -h your-db.abc123.us-east-1.rds.amazonaws.com -U postgres -d postgres

# In psql:
CREATE EXTENSION IF NOT EXISTS vector;
\q
```

## Step 4: Download Schema Files

```bash
git clone https://github.com/oregpt/Agenticledger_BringYourOwnStorage_repo.git
cd Agenticledger_BringYourOwnStorage_repo
```

## Step 5: Create Database

```bash
export PGPASSWORD='your-rds-master-password'
export RDS_HOST='your-db.abc123.us-east-1.rds.amazonaws.com'

# Create database
psql -h $RDS_HOST -U postgres -d postgres -c "CREATE DATABASE agenticledger_customer_db;"
```

## Step 6: Run Schema Scripts

```bash
# Enable extensions
psql -h $RDS_HOST -U postgres -d agenticledger_customer_db -f schema/001_enable_extensions.sql

# Create tables
psql -h $RDS_HOST -U postgres -d agenticledger_customer_db -f schema/002_create_tables.sql

# Create indexes
psql -h $RDS_HOST -U postgres -d agenticledger_customer_db -f schema/003_create_indexes.sql

# Create functions
psql -h $RDS_HOST -U postgres -d agenticledger_customer_db -f schema/004_create_functions.sql
```

## Step 7: Create Dedicated User

```bash
psql -h $RDS_HOST -U postgres -d agenticledger_customer_db << 'EOF'
CREATE USER platform_user WITH PASSWORD 'YourSecure_RDS_Password_2025_aB3$xY9#mK2!';
GRANT CONNECT ON DATABASE agenticledger_customer_db TO platform_user;
GRANT USAGE ON SCHEMA public TO platform_user;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO platform_user;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO platform_user;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON TABLES TO platform_user;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON SEQUENCES TO platform_user;
EOF
```

## Step 8: Test Connection

```bash
psql -h $RDS_HOST -U platform_user -d agenticledger_customer_db -c "\dt"
```

You should see 5 tables.

## Step 9: Get Connection Details

**Your connection string:**
```
postgresql://platform_user:your-password@your-db.abc123.us-east-1.rds.amazonaws.com:5432/agenticledger_customer_db
```

## Step 10: Enable SSL (Recommended)

```bash
# Download RDS certificate
wget https://truststore.pki.rds.amazonaws.com/global/global-bundle.pem

# Connect with SSL
psql "postgresql://platform_user:password@your-db.rds.amazonaws.com:5432/agenticledger_customer_db?sslmode=verify-full&sslrootcert=global-bundle.pem"
```

**Connection string with SSL:**
```
postgresql://platform_user:your-password@your-db.rds.amazonaws.com:5432/agenticledger_customer_db?sslmode=require
```

✅ **Done! Managed database on AWS RDS.**

**Benefits:**
- ✅ Automatic backups
- ✅ Automatic updates
- ✅ High availability
- ✅ No server management

---

# Scenario 8: Azure Database for PostgreSQL

**Perfect for:** Microsoft Azure customers, managed database solution

**What you need:**
- Azure account
- Azure CLI (optional)

**Where database runs:** Azure Database at `your-db.postgres.database.azure.com:5432`

---

## Step 1: Create Azure Database for PostgreSQL

1. Log into Azure Portal
2. Click "Create a resource" → "Azure Database for PostgreSQL"
3. Click "Create" under **"Flexible server"**
4. **Basics:**
   - Resource group: Create new or use existing
   - Server name: `agenticledger-db`
   - Region: Choose nearest
   - PostgreSQL version: 14 or higher
   - Workload type: Development or Production
5. **Compute + storage:**
   - Small: Burstable B1ms (1 vCore, 2GB RAM) - ~$15/month
   - Medium: General Purpose D2s_v3 (2 vCore, 8GB RAM) - ~$110/month
   - Large: General Purpose D4s_v3 (4 vCore, 16GB RAM) - ~$220/month
   - Storage: 32GB - 128GB
6. **Authentication:**
   - Authentication method: PostgreSQL authentication
   - Admin username: `postgres`
   - Password: Set strong password
7. **Networking:**
   - Connectivity method: Public access
   - Add current client IP address: ✅
8. Click "Review + Create"

**Wait 5-10 minutes for creation.**

## Step 2: Configure Firewall

1. Go to your database → Settings → Networking
2. Add firewall rule:
   - Rule name: `AllowApp`
   - Start IP: Your application IP
   - End IP: Same IP
3. Click "Save"

## Step 3: Enable pgvector Extension

```bash
# From your computer
# Install PostgreSQL client
sudo apt-get install -y postgresql-client

# Connect to Azure Database
psql "host=agenticledger-db.postgres.database.azure.com port=5432 dbname=postgres user=postgres password=your-password sslmode=require"

# In psql:
CREATE EXTENSION IF NOT EXISTS vector;
\q
```

## Step 4: Download Schema Files

```bash
git clone https://github.com/oregpt/Agenticledger_BringYourOwnStorage_repo.git
cd Agenticledger_BringYourOwnStorage_repo
```

## Step 5: Create Database

```bash
export PGPASSWORD='your-azure-password'
export AZURE_HOST='agenticledger-db.postgres.database.azure.com'

# Create database
psql "host=$AZURE_HOST port=5432 dbname=postgres user=postgres sslmode=require" -c "CREATE DATABASE agenticledger_customer_db;"
```

## Step 6: Run Schema Scripts

```bash
# Enable extensions
psql "host=$AZURE_HOST port=5432 dbname=agenticledger_customer_db user=postgres sslmode=require" -f schema/001_enable_extensions.sql

# Create tables
psql "host=$AZURE_HOST port=5432 dbname=agenticledger_customer_db user=postgres sslmode=require" -f schema/002_create_tables.sql

# Create indexes
psql "host=$AZURE_HOST port=5432 dbname=agenticledger_customer_db user=postgres sslmode=require" -f schema/003_create_indexes.sql

# Create functions
psql "host=$AZURE_HOST port=5432 dbname=agenticledger_customer_db user=postgres sslmode=require" -f schema/004_create_functions.sql
```

## Step 7: Create Dedicated User

```bash
psql "host=$AZURE_HOST port=5432 dbname=agenticledger_customer_db user=postgres sslmode=require" << 'EOF'
CREATE USER platform_user WITH PASSWORD 'Azure_Secure_Password_2025_mN8$kP4#zX9!';
GRANT CONNECT ON DATABASE agenticledger_customer_db TO platform_user;
GRANT USAGE ON SCHEMA public TO platform_user;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO platform_user;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO platform_user;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON TABLES TO platform_user;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON SEQUENCES TO platform_user;
EOF
```

## Step 8: Test Connection

```bash
psql "host=$AZURE_HOST port=5432 dbname=agenticledger_customer_db user=platform_user password=Azure_Secure_Password_2025_mN8$kP4#zX9! sslmode=require" -c "\dt"
```

You should see 5 tables.

## Step 9: Get Connection Details

**Your connection string:**
```
postgresql://platform_user:your-password@agenticledger-db.postgres.database.azure.com:5432/agenticledger_customer_db?sslmode=require
```

## Step 10: Enable Backups (Default)

Azure automatically enables:
- ✅ Daily backups (7-35 day retention)
- ✅ Geo-redundant backups (optional)
- ✅ Point-in-time restore

To verify:
1. Go to database → Settings → Backup and restore
2. Configure retention period if needed

✅ **Done! Managed database on Azure.**

**Benefits:**
- ✅ Automatic backups
- ✅ Automatic updates
- ✅ High availability options
- ✅ Built-in monitoring

---

# Scenario 9: Kubernetes Cluster

**Perfect for:** Large enterprises, high availability, container orchestration

**What you need:**
- Kubernetes cluster (AWS EKS, Azure AKS, GKE, or self-hosted)
- kubectl installed and configured
- Basic Kubernetes knowledge

**Where database runs:** Kubernetes cluster at `service-ip:5432` or `LoadBalancer-DNS:5432`

---

## Step 1: Create Namespace

```bash
kubectl create namespace agenticledger
```

## Step 2: Create Password Secret

```bash
# Generate strong password
PASSWORD=$(openssl rand -base64 32)
echo "Save this password: $PASSWORD"

# Create secret
kubectl create secret generic agenticledger-db-secret \
  --from-literal=password="$PASSWORD" \
  -n agenticledger
```

## Step 3: Download Repository

```bash
git clone https://github.com/oregpt/Agenticledger_BringYourOwnStorage_repo.git
cd Agenticledger_BringYourOwnStorage_repo
```

## Step 4: Create ConfigMap with Schema Files

```bash
kubectl create configmap agenticledger-schema \
  --from-file=schema/ \
  -n agenticledger
```

## Step 5: Create Deployment Manifest

Create file `k8s-deployment.yaml`:

```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: postgres-pvc
  namespace: agenticledger
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 50Gi
  storageClassName: gp3  # AWS EKS, use appropriate storage class
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: agenticledger-db
  namespace: agenticledger
spec:
  replicas: 1
  selector:
    matchLabels:
      app: agenticledger-db
  template:
    metadata:
      labels:
        app: agenticledger-db
    spec:
      containers:
      - name: postgres
        image: ankane/pgvector:latest
        env:
        - name: POSTGRES_DB
          value: agenticledger_customer_db
        - name: POSTGRES_USER
          value: platform_user
        - name: POSTGRES_PASSWORD
          valueFrom:
            secretKeyRef:
              name: agenticledger-db-secret
              key: password
        ports:
        - containerPort: 5432
          name: postgres
        volumeMounts:
        - name: postgres-storage
          mountPath: /var/lib/postgresql/data
          subPath: pgdata
        - name: init-scripts
          mountPath: /docker-entrypoint-initdb.d
        resources:
          requests:
            memory: "2Gi"
            cpu: "1000m"
          limits:
            memory: "4Gi"
            cpu: "2000m"
        livenessProbe:
          exec:
            command:
            - pg_isready
            - -U
            - platform_user
          initialDelaySeconds: 30
          periodSeconds: 10
        readinessProbe:
          exec:
            command:
            - pg_isready
            - -U
            - platform_user
          initialDelaySeconds: 5
          periodSeconds: 5
      volumes:
      - name: postgres-storage
        persistentVolumeClaim:
          claimName: postgres-pvc
      - name: init-scripts
        configMap:
          name: agenticledger-schema
---
apiVersion: v1
kind: Service
metadata:
  name: agenticledger-db
  namespace: agenticledger
spec:
  type: LoadBalancer
  ports:
  - port: 5432
    targetPort: 5432
    protocol: TCP
    name: postgres
  selector:
    app: agenticledger-db
```

## Step 6: Deploy

```bash
kubectl apply -f k8s-deployment.yaml
```

## Step 7: Wait for Deployment

```bash
# Watch pods
kubectl get pods -n agenticledger -w

# Wait for "Running" status
# Press Ctrl+C to stop watching
```

## Step 8: Get Service Endpoint

```bash
kubectl get svc agenticledger-db -n agenticledger
```

**For LoadBalancer:**
```
NAME               TYPE           CLUSTER-IP      EXTERNAL-IP                                                              PORT(S)
agenticledger-db   LoadBalancer   10.100.123.45   a1b2c3d4e5f6g7h8.us-east-1.elb.amazonaws.com   5432:31234/TCP
```

**Your connection string:**
```
postgresql://platform_user:your-password@a1b2c3d4e5f6g7h8.us-east-1.elb.amazonaws.com:5432/agenticledger_customer_db
```

## Step 9: Test Connection

```bash
# Get password
PASSWORD=$(kubectl get secret agenticledger-db-secret -n agenticledger -o jsonpath='{.data.password}' | base64 -d)

# Port forward for testing
kubectl port-forward svc/agenticledger-db 5432:5432 -n agenticledger

# In another terminal
psql "postgresql://platform_user:$PASSWORD@localhost:5432/agenticledger_customer_db" -c "\dt"
```

## Step 10: (Optional) Create Internal Service Only

If you don't need external access, change Service type:

```yaml
apiVersion: v1
kind: Service
metadata:
  name: agenticledger-db
  namespace: agenticledger
spec:
  type: ClusterIP  # Internal only
  ports:
  - port: 5432
    targetPort: 5432
  selector:
    app: agenticledger-db
```

**Connection from within cluster:**
```
postgresql://platform_user:password@agenticledger-db.agenticledger.svc.cluster.local:5432/agenticledger_customer_db
```

## Step 11: Set Up Automated Backups

Create `backup-cronjob.yaml`:

```yaml
apiVersion: batch/v1
kind: CronJob
metadata:
  name: postgres-backup
  namespace: agenticledger
spec:
  schedule: "0 2 * * *"  # Daily at 2 AM
  jobTemplate:
    spec:
      template:
        spec:
          containers:
          - name: backup
            image: postgres:15
            command:
            - /bin/sh
            - -c
            - |
              pg_dump -h agenticledger-db -U platform_user -d agenticledger_customer_db | gzip > /backups/backup_$(date +\%Y\%m\%d_\%H\%M\%S).sql.gz
              # Upload to S3/Azure Blob/GCS here
            env:
            - name: PGPASSWORD
              valueFrom:
                secretKeyRef:
                  name: agenticledger-db-secret
                  key: password
            volumeMounts:
            - name: backup-storage
              mountPath: /backups
          restartPolicy: OnFailure
          volumes:
          - name: backup-storage
            persistentVolumeClaim:
              claimName: backup-pvc
```

✅ **Done! Database running on Kubernetes.**

**Benefits:**
- ✅ High availability
- ✅ Auto-healing
- ✅ Scalable
- ✅ Cloud-agnostic

---

# Scenario 10: On-Premises Data Center

**Perfect for:** Compliance requirements, air-gapped environments, full control

**What you need:**
- Physical server or VM in your data center
- Windows Server or Linux
- Network access to the server

**Where database runs:** Your data center at `internal-server-ip:5432`

---

## Step 1: Access Your Server

**Windows Server:**
- Use Remote Desktop (RDP)

**Linux Server:**
```bash
ssh admin@your-internal-server-ip
```

## Step 2: Install Docker

**Windows Server:**
1. Install Docker Desktop for Windows Server
2. Or install Docker Engine: https://docs.docker.com/engine/install/

**Linux Server:**
```bash
sudo apt-get update
sudo apt-get install -y docker.io docker-compose
sudo systemctl start docker
sudo systemctl enable docker
sudo usermod -aG docker $USER
```

Log out and back in.

## Step 3: Download Repository

**If internet access:**
```bash
git clone https://github.com/oregpt/Agenticledger_BringYourOwnStorage_repo.git
cd Agenticledger_BringYourOwnStorage_repo
```

**If air-gapped (no internet):**
1. Download ZIP on internet-connected computer
2. Transfer via USB/secure file transfer
3. Extract on server

## Step 4: Configure

```bash
cp .env.example .env
nano .env  # or notepad on Windows
```

Set strong password:
```env
DB_HOST=0.0.0.0  # Listen on all interfaces
DB_PORT=5432
DB_NAME=agenticledger_customer_db
DB_USER=platform_user
DB_PASSWORD=OnPrem_Secure_Password_2025_xK9$mP4#vN8!qL7@wT3%
```

## Step 5: Configure Docker Compose for Production

Edit `docker-compose.yml` to add resource limits and restart policy:

```yaml
services:
  postgres:
    image: ankane/pgvector:latest
    container_name: agenticledger_db
    restart: always  # Auto-restart on failure
    environment:
      POSTGRES_DB: ${DB_NAME}
      POSTGRES_USER: ${DB_USER}
      POSTGRES_PASSWORD: ${DB_PASSWORD}
    ports:
      - "${DB_PORT:-5432}:5432"
    volumes:
      - postgres_data:/var/lib/postgresql/data
      - ./schema:/docker-entrypoint-initdb.d
      - ./backups:/backups
    deploy:
      resources:
        limits:
          cpus: '4'
          memory: 8G
        reservations:
          cpus: '2'
          memory: 4G
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U ${DB_USER}"]
      interval: 10s
      timeout: 5s
      retries: 5

volumes:
  postgres_data:
    driver: local
```

## Step 6: Deploy

```bash
docker-compose up -d
```

## Step 7: Configure Firewall

**Linux (UFW):**
```bash
# Allow from specific internal network
sudo ufw allow from 192.168.1.0/24 to any port 5432
sudo ufw enable
```

**Linux (iptables):**
```bash
# Allow from internal network only
sudo iptables -A INPUT -p tcp -s 192.168.1.0/24 --dport 5432 -j ACCEPT
sudo iptables -A INPUT -p tcp --dport 5432 -j DROP
sudo iptables-save > /etc/iptables/rules.v4
```

**Windows Server:**
1. Open Windows Defender Firewall
2. New Inbound Rule → Port → TCP 5432
3. Scope: Specify remote IPs (your internal network)
4. Allow the connection

## Step 8: Set Up Automated Backups

**Linux:**
```bash
# Create backup script
sudo mkdir -p /opt/agenticledger/backups

cat > /opt/agenticledger/backup.sh << 'EOF'
#!/bin/bash
BACKUP_DIR="/opt/agenticledger/backups"
DATE=$(date +%Y%m%d_%H%M%S)
RETENTION_DAYS=30

cd /path/to/Agenticledger_BringYourOwnStorage_repo

# Create backup
docker-compose exec -T postgres pg_dump -U platform_user agenticledger_customer_db | gzip > "$BACKUP_DIR/backup_$DATE.sql.gz"

# Delete old backups
find "$BACKUP_DIR" -name "backup_*.sql.gz" -mtime +$RETENTION_DAYS -delete

# Optional: Copy to network storage
# cp "$BACKUP_DIR/backup_$DATE.sql.gz" /mnt/nas/backups/
EOF

chmod +x /opt/agenticledger/backup.sh

# Add to crontab
sudo crontab -e
# Add: 0 2 * * * /opt/agenticledger/backup.sh
```

**Windows Server (PowerShell):**
```powershell
# Create backup script
$backupScript = @'
$BACKUP_DIR = "C:\AgenticLedger\backups"
$DATE = Get-Date -Format "yyyyMMdd_HHmmss"
$RETENTION_DAYS = 30

cd C:\path\to\Agenticledger_BringYourOwnStorage_repo

# Create backup
docker-compose exec -T postgres pg_dump -U platform_user agenticledger_customer_db | gzip > "$BACKUP_DIR\backup_$DATE.sql.gz"

# Delete old backups
Get-ChildItem "$BACKUP_DIR\backup_*.sql.gz" | Where-Object {$_.LastWriteTime -lt (Get-Date).AddDays(-$RETENTION_DAYS)} | Remove-Item

# Optional: Copy to network storage
# Copy-Item "$BACKUP_DIR\backup_$DATE.sql.gz" "\\nas\backups\"
'@

$backupScript | Out-File C:\AgenticLedger\backup.ps1

# Create scheduled task
$action = New-ScheduledTaskAction -Execute "PowerShell.exe" -Argument "-File C:\AgenticLedger\backup.ps1"
$trigger = New-ScheduledTaskTrigger -Daily -At 2am
Register-ScheduledTask -Action $action -Trigger $trigger -TaskName "AgenticLedger Backup" -Description "Daily database backup"
```

## Step 9: Enable SSL/TLS

Create SSL certificates:

```bash
# Generate self-signed certificate (or use your CA certificates)
openssl req -new -x509 -days 365 -nodes -text -out server.crt -keyout server.key -subj "/CN=your-server.yourdomain.com"

# Set permissions
chmod 600 server.key

# Move to Docker volume
mkdir -p ./ssl
mv server.crt server.key ./ssl/
```

Update `docker-compose.yml`:
```yaml
services:
  postgres:
    command: >
      -c ssl=on
      -c ssl_cert_file=/var/lib/postgresql/ssl/server.crt
      -c ssl_key_file=/var/lib/postgresql/ssl/server.key
    volumes:
      - ./ssl:/var/lib/postgresql/ssl
```

Restart:
```bash
docker-compose down
docker-compose up -d
```

## Step 10: Set Up Monitoring

**Install Prometheus + Grafana:**

Create `monitoring-stack.yml`:
```yaml
version: '3.8'

services:
  prometheus:
    image: prom/prometheus:latest
    container_name: prometheus
    volumes:
      - ./prometheus.yml:/etc/prometheus/prometheus.yml
      - prometheus_data:/prometheus
    ports:
      - "9090:9090"
    restart: always

  grafana:
    image: grafana/grafana:latest
    container_name: grafana
    ports:
      - "3000:3000"
    environment:
      - GF_SECURITY_ADMIN_PASSWORD=admin
    volumes:
      - grafana_data:/var/lib/grafana
    restart: always

  postgres_exporter:
    image: prometheuscommunity/postgres-exporter:latest
    container_name: postgres_exporter
    environment:
      DATA_SOURCE_NAME: "postgresql://platform_user:your-password@agenticledger_db:5432/agenticledger_customer_db?sslmode=disable"
    ports:
      - "9187:9187"
    restart: always

volumes:
  prometheus_data:
  grafana_data:
```

Start monitoring:
```bash
docker-compose -f monitoring-stack.yml up -d
```

Access Grafana at `http://your-server-ip:3000`

## Step 11: Document Connection Details

```bash
echo "Connection String: postgresql://platform_user:your-password@your-server-ip:5432/agenticledger_customer_db" > CONNECTION_INFO.txt

# Secure the file
chmod 600 CONNECTION_INFO.txt
```

## Step 12: Get Internal IP Address

**Linux:**
```bash
hostname -I
```

**Windows:**
```powershell
ipconfig
```

**Your connection string (from internal network):**
```
postgresql://platform_user:your-password@192.168.1.100:5432/agenticledger_customer_db
```

✅ **Done! Database running in your data center.**

**Benefits:**
- ✅ Full control
- ✅ Data never leaves premises
- ✅ Compliance-ready (HIPAA, SOC2, etc.)
- ✅ No internet dependency

---

# Post-Deployment: Connect to AgenticLedger

After deploying using ANY scenario above, you need to provide your database connection details to AgenticLedger.

---

## Step 1: Gather Your Connection Details

You'll need these 5 pieces of information:

| Field | Value | Your Value |
|-------|-------|------------|
| **Host** | Your database hostname or IP | _________________ |
| **Port** | 5432 (default PostgreSQL port) | 5432 |
| **Database Name** | agenticledger_customer_db | agenticledger_customer_db |
| **Username** | platform_user | platform_user |
| **Password** | From your `.env` file | _________________ |

### Finding Your Host (Depends on Deployment)

| Deployment Type | Host Example |
|-----------------|--------------|
| **Personal Computer** | `localhost` |
| **Small Business Server** | `192.168.1.100` (internal IP) |
| **AWS EC2** | `ec2-18-123-45-67.compute.amazonaws.com` |
| **Azure VM** | `agenticledger-db.eastus.cloudapp.azure.com` |
| **Google Cloud VM** | `35.123.45.67` (external IP) |
| **DigitalOcean** | `164.123.45.67` (droplet IP) |
| **AWS RDS** | `your-db.abc123.us-east-1.rds.amazonaws.com` |
| **Azure Database** | `agenticledger-db.postgres.database.azure.com` |
| **Kubernetes** | LoadBalancer DNS from `kubectl get svc` |
| **On-Premises** | `192.168.1.100` (internal IP) or `database.yourcompany.com` |

### Finding Your Password

**If you used Docker or scripts:**
```bash
# Mac/Linux
cat .env | grep DB_PASSWORD

# Windows PowerShell
type .env | Select-String DB_PASSWORD
```

**Look for:**
```
DB_PASSWORD=YourPasswordHere
```

---

## Step 2: Configure AgenticLedger

### Login to AgenticLedger

1. Go to your AgenticLedger dashboard
2. Login with your account

### Navigate to Data Residency Settings

1. Click **Settings** (usually in top-right or sidebar)
2. Find **Data Residency** or **Database Configuration** section
3. Select **"Mode 3: Bring Your Own Storage (BYOS)"**

### Enter Your Database Connection Details

You'll see a form with these fields:

```
┌─────────────────────────────────────────────┐
│  Database Connection Configuration          │
├─────────────────────────────────────────────┤
│                                             │
│  Host:     [____________________________]  │
│            Example: ec2-xx-xxx-xxx-xx...    │
│                                             │
│  Port:     [5432]                          │
│                                             │
│  Database: [agenticledger_customer_db]     │
│                                             │
│  Username: [platform_user]                 │
│                                             │
│  Password: [____________________________]  │
│            (from your .env file)            │
│                                             │
│  [Test Connection]  [Save Configuration]    │
└─────────────────────────────────────────────┘
```

**Fill in each field:**

1. **Host:**
   - Paste your server hostname or IP address
   - Examples: `ec2-18-123-45-67.compute.amazonaws.com` or `192.168.1.100`

2. **Port:**
   - Enter `5432` (default PostgreSQL port)
   - Unless you changed it in your deployment

3. **Database:**
   - Enter `agenticledger_customer_db`
   - This is created automatically by the setup

4. **Username:**
   - Enter `platform_user`
   - This is created automatically by the setup

5. **Password:**
   - Copy from your `.env` file
   - Paste the entire password (usually 32+ characters)

---

## Step 3: Test the Connection

1. Click **"Test Connection"** button
2. Wait 5-10 seconds

**You should see:**
```
✅ Connection successful!
Connected to: agenticledger_customer_db
Tables found: 5 (files, document_chunks, conversations, messages, conversation_files)
Database version: PostgreSQL 15.x with pgvector 0.8.1
```

**If connection fails, see [Troubleshooting](#troubleshooting) section below.**

---

## Step 4: Save Configuration

1. Click **"Save Configuration"** button
2. Confirm when prompted

**You should see:**
```
✅ Configuration saved successfully!
Your organization is now using Bring Your Own Storage (BYOS).
All data will be stored in your database.
```

---

## Step 5: Verify It's Working

1. Create a test file or conversation in AgenticLedger
2. Verify data is being saved to your database:

```bash
# Connect to your database
psql "postgresql://platform_user:your-password@your-host:5432/agenticledger_customer_db"

# Check for data
SELECT COUNT(*) FROM files;
SELECT COUNT(*) FROM conversations;

# Exit
\q
```

**You should see counts greater than 0 if data is being saved.**

---

## ✅ Setup Complete!

**Congratulations!** Your organization is now using Bring Your Own Storage (BYOS) with AgenticLedger.

**What this means:**
- ✅ All your data is stored in **your** database
- ✅ AgenticLedger **only processes** data, doesn't store it
- ✅ You have **full control** over backups, security, and access
- ✅ Your data **never leaves** your infrastructure (if on-premises)
- ✅ You can **audit** all data access directly in your database

---

## Connection String Format (Alternative)

Some configurations may ask for a single connection string instead of separate fields:

**Format:**
```
postgresql://platform_user:your-password@your-host:5432/agenticledger_customer_db
```

**Examples:**

**Personal Computer:**
```
postgresql://platform_user:YourPassword@localhost:5432/agenticledger_customer_db
```

**AWS EC2:**
```
postgresql://platform_user:YourPassword@ec2-18-123-45-67.compute.amazonaws.com:5432/agenticledger_customer_db
```

**Azure VM:**
```
postgresql://platform_user:YourPassword@your-vm.eastus.cloudapp.azure.com:5432/agenticledger_customer_db
```

**AWS RDS:**
```
postgresql://platform_user:YourPassword@your-db.abc123.us-east-1.rds.amazonaws.com:5432/agenticledger_customer_db?sslmode=require
```

**With SSL (Recommended for production):**
```
postgresql://platform_user:YourPassword@your-host:5432/agenticledger_customer_db?sslmode=require
```

---

## Troubleshooting Connection Issues

### Error: "Connection refused"

**Possible causes:**
- Database not running
- Firewall blocking port 5432
- Wrong host/IP address

**Solutions:**
1. Verify database is running:
   ```bash
   docker-compose ps
   # Should show "Up"
   ```

2. Check firewall allows port 5432 from AgenticLedger's IP

3. Verify host is correct:
   ```bash
   ping your-host
   ```

### Error: "Password authentication failed"

**Possible causes:**
- Wrong password
- Copy-paste error (extra spaces)

**Solutions:**
1. Double-check password in `.env` file
2. Try copying password again (no extra spaces)
3. Reset password:
   ```bash
   docker-compose exec postgres psql -U postgres -d agenticledger_customer_db -c "ALTER USER platform_user WITH PASSWORD 'NewPassword123';"
   ```
   Then update `.env` and try again

### Error: "Database does not exist"

**Possible causes:**
- Database name spelled wrong
- Database not created

**Solutions:**
1. Verify database name: `agenticledger_customer_db` (no typos)
2. Check database exists:
   ```bash
   docker-compose exec postgres psql -U postgres -c "\l"
   ```
3. If missing, re-run setup script

### Error: "Could not connect to server"

**Possible causes:**
- Host unreachable
- Network issue
- Database server down

**Solutions:**
1. Test connectivity:
   ```bash
   telnet your-host 5432
   # Or: nc -zv your-host 5432
   ```
2. Verify server is running
3. Check network connection
4. If using cloud VM, verify security group/firewall rules

### Error: "SSL connection required"

**Possible causes:**
- RDS or managed database requires SSL
- PostgreSQL configured to require SSL

**Solutions:**
1. Add `?sslmode=require` to connection string
2. Or in separate fields, enable SSL/TLS option
3. For RDS, download certificate if needed

### Error: "Tables not found"

**Possible causes:**
- Schema scripts not run
- Connected to wrong database

**Solutions:**
1. Verify correct database selected
2. Re-run schema scripts:
   ```bash
   psql "your-connection-string" -f schema/002_create_tables.sql
   ```
3. Check tables exist:
   ```bash
   psql "your-connection-string" -c "\dt"
   ```

---

## Advanced: VPN Connection for Cloud Apps

If your AgenticLedger app is hosted in the cloud (e.g., Replit, Vercel) and your database is on-premises or in a different cloud, you'll need a VPN or tunnel.

### Option 1: Tailscale VPN (Recommended)

1. **Install Tailscale on database server:**
   ```bash
   curl -fsSL https://tailscale.com/install.sh | sh
   sudo tailscale up
   ```

2. **Note Tailscale IP** (e.g., `100.64.0.5`)

3. **Install Tailscale on app server** (Replit, etc.)

4. **Use Tailscale IP in AgenticLedger:**
   - Host: `100.64.0.5`
   - Port: `5432`

### Option 2: Cloudflare Tunnel

1. Install cloudflared on database server
2. Create tunnel to port 5432
3. Use Cloudflare URL in AgenticLedger

### Option 3: ngrok (Testing Only)

```bash
ngrok tcp 5432
```

Use ngrok URL as host.

---

## Next Steps

Now that your database is connected:

1. ✅ **Invite team members** to AgenticLedger
2. ✅ **Set up automated backups** (see your deployment scenario above)
3. ✅ **Configure monitoring** (optional)
4. ✅ **Review security checklist** (see below)
5. ✅ **Test data recovery** (restore from backup)

---

## Security Recommendations

Now that you're live:

- [ ] Change default password to 32+ character random password
- [ ] Enable SSL/TLS for database connections
- [ ] Restrict firewall to only AgenticLedger IP addresses
- [ ] Set up automated daily backups
- [ ] Test backup restore procedure
- [ ] Enable database audit logging
- [ ] Document connection details securely (password manager)
- [ ] Set up monitoring and alerts
- [ ] Review PostgreSQL `pg_hba.conf` for access controls
- [ ] Implement least-privilege access (don't use postgres superuser)

---

**🎉 Your AgenticLedger organization is now connected to your own database!**

All your data is stored securely in your infrastructure under your control.

---

# Security Checklist

After deployment, verify these security measures:

- [ ] Strong password set (32+ characters, mixed case, numbers, symbols)
- [ ] Firewall configured (only allow necessary IPs)
- [ ] SSL/TLS enabled for production
- [ ] Automated backups configured
- [ ] Backup restore tested
- [ ] Monitoring enabled
- [ ] `.env` file not committed to git
- [ ] Database user has minimal required permissions
- [ ] Regular security updates enabled
- [ ] Access logs enabled
- [ ] Incident response plan documented

---

# Cost Comparison

| Scenario | Monthly Cost | Setup Time | Management |
|----------|--------------|------------|------------|
| Personal Computer | $0 | 5 min | DIY |
| Small Business Server | $0 (existing hardware) | 10 min | DIY |
| AWS EC2 (t3.medium) | $30-50 | 15 min | DIY |
| Azure VM (B2s) | $30-50 | 15 min | DIY |
| GCP VM (e2-medium) | $25-40 | 15 min | DIY |
| DigitalOcean (Basic) | $12-24 | 10 min | DIY |
| AWS RDS (db.t3.micro) | $15-60 | 20 min | Managed |
| Azure Database (2 vCore) | $100-150 | 20 min | Managed |
| Kubernetes | $150-500+ | 30 min | Managed cluster |
| On-Premises | $50-200 (power) | 20 min | DIY |

---

# Troubleshooting

## Database won't start

**Check logs:**
```bash
docker-compose logs postgres
```

**Common issues:**
- Port 5432 already in use → Change `DB_PORT` in `.env`
- Permission denied → Run with sudo or check Docker permissions
- Out of memory → Reduce container memory limits

## Can't connect from application

**Test connection:**
```bash
psql "postgresql://platform_user:password@host:5432/agenticledger_customer_db"
```

**Common issues:**
- Firewall blocking port 5432 → Check firewall rules
- Wrong password → Verify `.env` file
- Wrong host/IP → Verify hostname or IP address
- SSL required → Add `?sslmode=require` to connection string

## pgvector extension not found

**Docker:**
```bash
docker-compose exec postgres psql -U platform_user -d agenticledger_customer_db -c "CREATE EXTENSION vector;"
```

**Managed database:**
- Verify PostgreSQL version supports pgvector (14+)
- Check if extension is available: `SELECT * FROM pg_available_extensions WHERE name='vector';`

## Slow queries

**Create indexes:**
```bash
psql "your-connection-string" -f schema/003_create_indexes.sql
```

**Check query performance:**
```sql
EXPLAIN ANALYZE SELECT * FROM document_chunks WHERE agent_id = 1;
```

## Out of storage

**Check database size:**
```bash
docker-compose exec postgres psql -U platform_user -d agenticledger_customer_db -c "SELECT pg_size_pretty(pg_database_size('agenticledger_customer_db'));"
```

**Clean up old data or expand storage.**

---

# Support

Need help?

- **Documentation:** See other guides in repository
- **GitHub Issues:** https://github.com/oregpt/Agenticledger_BringYourOwnStorage_repo/issues
- **AgenticLedger Support:** support@agenticledger.com

---

**Document Version:** 2.0
**Last Updated:** 2025-01-26
**Repository:** https://github.com/oregpt/Agenticledger_BringYourOwnStorage_repo
