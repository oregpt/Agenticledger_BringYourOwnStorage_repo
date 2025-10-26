# AgenticLedger Customer Database - Self-Hosted Setup

Easy deployment of AgenticLedger's PostgreSQL database with pgvector for on-premises (Mode 3) data residency.

## 📖 Complete Deployment Guide

**👉 [DEPLOYMENT_GUIDE.md](./DEPLOYMENT_GUIDE.md) - Start Here!**

This repository supports deployment to:
- Personal computers (development)
- Small business servers
- AWS EC2, Azure VMs, Google Cloud
- DigitalOcean, Linode, any cloud provider
- AWS RDS, Azure Database (managed)
- Kubernetes clusters
- On-premises data centers

**Select your scenario in the deployment guide and follow the step-by-step instructions.**

---

## 🚀 Quick Start (Docker - 2 Minutes)

**If you just want to test locally:**

```bash
# Clone this repository
git clone https://github.com/oregpt/Agenticledger_BringYourOwnStorage_repo.git
cd Agenticledger_BringYourOwnStorage_repo

# Copy environment template
cp .env.example .env

# Edit .env and set your password (optional, random password generated if not set)
nano .env

# Start database
docker-compose up -d

# Check it's running
docker-compose ps

# View logs
docker-compose logs -f
```

**Done!** Your database is running on `localhost:5432`

**Next:** See [DEPLOYMENT_GUIDE.md](./DEPLOYMENT_GUIDE.md) section "Post-Deployment: Connect to AgenticLedger" to configure your connection

---

### Option 2: Automated Setup Script (5 Minutes)

**Requirements:** PostgreSQL 14+ installed

**Linux/Mac:**
```bash
git clone https://github.com/oregpt/Agenticledger_BringYourOwnStorage_repo.git
cd Agenticledger_BringYourOwnStorage_repo
chmod +x setup.sh
./setup.sh
```

**Windows (PowerShell as Administrator):**
```powershell
git clone https://github.com/oregpt/Agenticledger_BringYourOwnStorage_repo.git
cd Agenticledger_BringYourOwnStorage_repo
.\setup.ps1
```

The script will:
- ✅ Check PostgreSQL is installed
- ✅ Install pgvector extension
- ✅ Create database and user
- ✅ Run schema migrations
- ✅ Generate secure passwords
- ✅ Create .env file with connection details

---

### Option 3: Manual Setup (10 Minutes)

See [MANUAL_SETUP.md](./docs/MANUAL_SETUP.md) for step-by-step instructions.

---

## 📋 What Gets Installed

- **PostgreSQL Database:** `agenticledger_customer_db`
- **pgvector Extension:** For AI/vector search capabilities
- **5 Tables:**
  - `files` - Document storage
  - `document_chunks` - Vector embeddings for RAG
  - `conversations` - Chat sessions
  - `messages` - Chat messages with review tracking
  - `conversation_files` - Temporary file attachments
- **Optimized Indexes:** For fast queries and vector search
- **Dedicated User:** `platform_user` with appropriate permissions

---

## 🔗 Connection Details

After setup, your connection details will be in `.env`:

```env
DB_HOST=localhost
DB_PORT=5432
DB_NAME=agenticledger_customer_db
DB_USER=platform_user
DB_PASSWORD=<generated-secure-password>
```

**Connection String:**
```
postgresql://platform_user:<password>@localhost:5432/agenticledger_customer_db
```

---

## 🧪 Testing Your Setup

**Quick test:**
```bash
# Using Docker
docker-compose exec postgres psql -U platform_user -d agenticledger_customer_db -c "\dt"

# Using local PostgreSQL
psql -h localhost -U platform_user -d agenticledger_customer_db -c "\dt"
```

**Expected output:** List of 5 tables

**Run test suite:**
```bash
npm install
npm test
```

---

## 🔒 Security Notes

### For Development:
- Default passwords are in `.env` (included in `.gitignore`)
- Database only accessible on localhost

### For Production:
- [ ] Change all passwords to strong, random values (32+ characters)
- [ ] Configure `pg_hba.conf` to restrict access by IP
- [ ] Enable SSL/TLS connections
- [ ] Set up automated backups
- [ ] Configure firewall rules
- [ ] Enable PostgreSQL audit logging

See [SECURITY.md](./docs/SECURITY.md) for detailed hardening steps.

---

## 🌐 Connecting from Cloud Application

Your AgenticLedger cloud application can connect to this database using:

### Option 1: Tailscale VPN (Recommended)
See [docs/TAILSCALE_SETUP.md](./docs/TAILSCALE_SETUP.md)

### Option 2: Cloudflare Tunnel
See [docs/CLOUDFLARE_TUNNEL.md](./docs/CLOUDFLARE_TUNNEL.md)

### Option 3: ngrok (Testing Only)
See [docs/NGROK_SETUP.md](./docs/NGROK_SETUP.md)

---

## 📦 What's Included

```
agenticledger-customer-db/
├── README.md                   # This file
├── docker-compose.yml          # Docker setup
├── .env.example                # Environment template
├── setup.sh                    # Linux/Mac automated setup
├── setup.ps1                   # Windows automated setup
├── schema/
│   ├── 001_enable_extensions.sql
│   ├── 002_create_tables.sql
│   ├── 003_create_indexes.sql
│   └── 004_create_policies.sql
├── scripts/
│   ├── backup.sh               # Backup database
│   ├── restore.sh              # Restore from backup
│   └── cleanup.sh              # Clean expired files
├── tests/
│   ├── connection-test.js      # Test connection
│   └── schema-test.js          # Verify schema
├── docs/
│   ├── MANUAL_SETUP.md         # Step-by-step manual setup
│   ├── SECURITY.md             # Security hardening guide
│   ├── BACKUP_RESTORE.md       # Backup strategies
│   ├── TAILSCALE_SETUP.md      # VPN setup for cloud
│   ├── CLOUDFLARE_TUNNEL.md    # Tunnel setup
│   └── TROUBLESHOOTING.md      # Common issues
└── .github/
    └── workflows/
        └── test.yml            # CI/CD tests
```

---

## 🔄 Updating Your Database

When AgenticLedger releases schema updates:

```bash
git pull origin main
docker-compose down
docker-compose up -d
# Or for local: ./scripts/migrate.sh
```

---

## 🗄️ Backup & Restore

### Automated Backups (Docker)

Backups automatically run daily and are stored in `./backups/`

### Manual Backup

```bash
# Docker
docker-compose exec postgres pg_dump -U platform_user agenticledger_customer_db > backup.sql

# Local
pg_dump -U platform_user agenticledger_customer_db > backup.sql
```

### Restore

```bash
# Docker
cat backup.sql | docker-compose exec -T postgres psql -U platform_user agenticledger_customer_db

# Local
psql -U platform_user agenticledger_customer_db < backup.sql
```

See [docs/BACKUP_RESTORE.md](./docs/BACKUP_RESTORE.md) for automated backup strategies.

---

## 🐛 Troubleshooting

### Database won't start

**Docker:**
```bash
docker-compose logs postgres
docker-compose down -v  # Remove volumes and restart
docker-compose up -d
```

**Local:**
```bash
# Check PostgreSQL is running
systemctl status postgresql  # Linux
brew services list | grep postgresql  # Mac
Get-Service postgresql*  # Windows PowerShell
```

### Can't connect

1. Check database is running: `docker-compose ps` or `pg_isready`
2. Verify credentials in `.env`
3. Check firewall allows port 5432
4. Review logs: `docker-compose logs` or PostgreSQL logs

### pgvector not found

```bash
# Docker - rebuild with pgvector
docker-compose down
docker-compose up -d --build

# Local - install pgvector
./scripts/install-pgvector.sh
```

See [docs/TROUBLESHOOTING.md](./docs/TROUBLESHOOTING.md) for more issues.

---

## 📊 Monitoring

### Check database size

```bash
docker-compose exec postgres psql -U platform_user -d agenticledger_customer_db -c "
  SELECT pg_size_pretty(pg_database_size('agenticledger_customer_db'));"
```

### Check table sizes

```bash
docker-compose exec postgres psql -U platform_user -d agenticledger_customer_db -c "
  SELECT tablename, pg_size_pretty(pg_total_relation_size(tablename::text))
  FROM pg_tables WHERE schemaname='public';"
```

### Monitor connections

```bash
docker-compose exec postgres psql -U platform_user -d agenticledger_customer_db -c "
  SELECT count(*) FROM pg_stat_activity WHERE datname='agenticledger_customer_db';"
```

---

## 🆘 Support

- **Documentation:** [docs/](./docs/)
- **Issues:** https://github.com/oregpt/Agenticledger_BringYourOwnStorage_repo/issues
- **AgenticLedger Support:** support@agenticledger.com
- **Community:** https://discord.gg/agenticledger

---

## 📜 License

MIT License - See [LICENSE](./LICENSE)

---

## 🎯 What's Next?

1. ✅ Database is running
2. ✅ Schema is created
3. ✅ Connection details saved
4. ⬜ Set up cloud connectivity (optional)
5. ⬜ Configure your AgenticLedger app to use this database
6. ⬜ Set up automated backups
7. ⬜ Review security hardening steps

**Need help connecting your cloud app?** See [docs/CLOUD_INTEGRATION.md](./docs/CLOUD_INTEGRATION.md)

---

**Your self-hosted AgenticLedger database is ready!** 🎉
