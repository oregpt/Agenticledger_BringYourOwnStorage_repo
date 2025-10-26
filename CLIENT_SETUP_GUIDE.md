# AgenticLedger BYOS Database - Client Setup Guide

## Welcome! 👋

This guide will help you set up your own AgenticLedger database in **under 10 minutes**. No technical expertise required!

---

## 📋 What You'll Get

After following this guide, you'll have:
- ✅ Your own PostgreSQL database running locally
- ✅ pgvector extension enabled (for AI features)
- ✅ All AgenticLedger tables created
- ✅ Secure passwords auto-generated
- ✅ Connection details ready to use

---

## 🎯 Choose Your Setup Method

**Pick ONE of these options:**

| Method | Time | Best For | Difficulty |
|--------|------|----------|------------|
| **Option 1: Docker** | 2 min | Everyone with Docker | ⭐ Easy |
| **Option 2: Windows Script** | 5 min | Windows users | ⭐⭐ Medium |
| **Option 3: Mac/Linux Script** | 5 min | Mac/Linux users | ⭐⭐ Medium |

**💡 Recommendation:** Use Docker if you can - it's the easiest!

---

## 📥 STEP 1: Get the Code

### 1.1 Open Your Web Browser

Go to this URL:
```
https://github.com/oregpt/Agenticledger_BringYourOwnStorage_repo
```

### 1.2 Download the Repository

You have two options:

#### Option A: Download as ZIP (Easiest)
1. Click the green **"Code"** button (top-right area)
2. Click **"Download ZIP"**
3. Save the file to your computer (e.g., Downloads folder)
4. **Right-click** the ZIP file → **"Extract All"**
5. Choose where to extract (e.g., `C:\AgenticLedger` or `~/AgenticLedger`)
6. Open the extracted folder

**You're now in the setup folder!** ✅ Skip to Step 2.

#### Option B: Git Clone (If you have Git installed)

1. Open Terminal (Mac/Linux) or PowerShell (Windows)

2. Navigate to where you want the folder:
   ```bash
   # Windows example
   cd C:\

   # Mac/Linux example
   cd ~/
   ```

3. Clone the repository:
   ```bash
   git clone https://github.com/oregpt/Agenticledger_BringYourOwnStorage_repo.git
   ```

4. Enter the folder:
   ```bash
   cd Agenticledger_BringYourOwnStorage_repo
   ```

**You're now in the setup folder!** ✅ Continue to Step 2.

---

## 🚀 STEP 2: Choose Your Setup Method

---

## ⚡ OPTION 1: Docker Setup (Recommended - 2 Minutes)

### Prerequisites
- Docker Desktop installed ([Download here](https://www.docker.com/products/docker-desktop/))

### Steps

#### 2.1 Open Terminal/PowerShell in the Folder

**Windows:**
- In File Explorer, **Shift + Right-click** in the folder
- Select **"Open PowerShell window here"**

**Mac:**
- Right-click the folder
- Select **"New Terminal at Folder"**

**Linux:**
- Right-click in the folder → **"Open Terminal here"**

#### 2.2 (Optional) Customize Password

If you want to set your own password:

1. Copy the template file:
   ```bash
   # Windows PowerShell
   Copy-Item .env.example .env

   # Mac/Linux
   cp .env.example .env
   ```

2. Open `.env` file in notepad/text editor

3. Find this line:
   ```
   DB_PASSWORD=CHANGE_ME_TO_SECURE_PASSWORD_32_CHARS_MIN
   ```

4. Replace with your password:
   ```
   DB_PASSWORD=YourSuperSecurePassword123!@#
   ```

5. Save the file

**If you skip this, a random secure password will be generated automatically.** ✅

#### 2.3 Start the Database

Run this command:

```bash
docker-compose up -d
```

**Wait 10-30 seconds** while Docker downloads and starts PostgreSQL.

#### 2.4 Verify It's Running

```bash
docker-compose ps
```

You should see:
```
NAME                 STATUS
agenticledger_db     Up
```

✅ **Success! Your database is running!**

#### 2.5 Get Your Connection Details

Run:

```bash
# Windows
type .env

# Mac/Linux
cat .env
```

Look for these values:
```
DB_HOST=localhost
DB_PORT=5432
DB_NAME=agenticledger_customer_db
DB_USER=platform_user
DB_PASSWORD=<your-generated-password>
```

**Save these! You'll need them to connect AgenticLedger.** 📝

---

### ✅ Docker Setup Complete!

Your database is running. Skip to **Step 3: Test Your Setup**

---

## 🪟 OPTION 2: Windows PowerShell Setup (5 Minutes)

### Prerequisites
- PostgreSQL 14 or higher installed ([Download here](https://www.postgresql.org/download/windows/))

### Steps

#### 2.1 Open PowerShell as Administrator

1. Press **Windows key**
2. Type **"PowerShell"**
3. **Right-click** on **"Windows PowerShell"**
4. Select **"Run as administrator"**

#### 2.2 Navigate to the Folder

```powershell
cd "C:\path\to\Agenticledger_BringYourOwnStorage_repo"
```

Replace `C:\path\to\` with where you extracted the files.

**Example:**
```powershell
cd "C:\Downloads\Agenticledger_BringYourOwnStorage_repo"
```

#### 2.3 Run the Setup Script

```powershell
.\setup.ps1
```

#### 2.4 Follow the Prompts

The script will:
- ✅ Check for PostgreSQL
- ✅ Install pgvector (if needed)
- ✅ Create database
- ✅ Create tables
- ✅ Generate secure passwords
- ✅ Create .env file

**This takes 2-3 minutes.**

#### 2.5 Review Connection Details

At the end, you'll see:
```
================================================================
Installation Complete!
================================================================

Your connection details (also saved in .env):

  Host:     localhost
  Port:     5432
  Database: agenticledger_customer_db
  User:     platform_user
  Password: <generated-password>
```

**Save these connection details!** 📝

---

### ✅ Windows Setup Complete!

Your database is running. Continue to **Step 3: Test Your Setup**

---

## 🍎 OPTION 3: Mac/Linux Setup (5 Minutes)

### Prerequisites
- PostgreSQL 14 or higher installed
  - **Mac:** `brew install postgresql@17`
  - **Linux:** `sudo apt-get install postgresql postgresql-contrib`

### Steps

#### 3.1 Open Terminal

**Mac:** Applications → Utilities → Terminal
**Linux:** Ctrl+Alt+T

#### 3.2 Navigate to the Folder

```bash
cd ~/path/to/Agenticledger_BringYourOwnStorage_repo
```

Replace `~/path/to/` with where you extracted the files.

**Example:**
```bash
cd ~/Downloads/Agenticledger_BringYourOwnStorage_repo
```

#### 3.3 Make Script Executable

```bash
chmod +x setup.sh
```

#### 3.4 Run the Setup Script

```bash
sudo ./setup.sh
```

Enter your system password when prompted.

#### 3.5 Follow the Prompts

The script will:
- ✅ Check for PostgreSQL
- ✅ Install pgvector (if needed)
- ✅ Create database
- ✅ Create tables
- ✅ Generate secure passwords
- ✅ Create .env file

**This takes 2-3 minutes.**

#### 3.6 Review Connection Details

At the end, you'll see:
```
================================================================
Installation Complete!
================================================================

Your connection details (also saved in .env):

  Host:     localhost
  Port:     5432
  Database: agenticledger_customer_db
  User:     platform_user
  Password: <generated-password>
```

**Save these connection details!** 📝

---

### ✅ Mac/Linux Setup Complete!

Your database is running. Continue to **Step 3: Test Your Setup**

---

## 🧪 STEP 3: Test Your Setup

Let's verify everything works!

### Option A: Quick Test (Recommended)

#### For Docker Users:

```bash
docker-compose exec postgres psql -U platform_user -d agenticledger_customer_db -c "\dt"
```

#### For Windows/Mac/Linux Users:

```bash
psql -h localhost -U platform_user -d agenticledger_customer_db -c "\dt"
```

**When prompted for password:** Enter the password from your `.env` file

**Expected Output:**
```
             List of relations
 Schema |        Name        | Type  |  Owner
--------+--------------------+-------+----------
 public | conversation_files | table | ...
 public | conversations      | table | ...
 public | document_chunks    | table | ...
 public | files              | table | ...
 public | messages           | table | ...
(5 rows)
```

**✅ If you see 5 tables, you're good!**

---

## 📋 STEP 4: Connect AgenticLedger

Now configure AgenticLedger to use your database.

### 4.1 Get Your Connection Details

From your `.env` file, you need:

```
Host:     localhost
Port:     5432
Database: agenticledger_customer_db
User:     platform_user
Password: <your-password-from-env-file>
```

**OR use the full connection string:**

```
postgresql://platform_user:<your-password>@localhost:5432/agenticledger_customer_db
```

### 4.2 Configure AgenticLedger

1. Log into your AgenticLedger dashboard
2. Go to **Settings** → **Data Residency** (or similar)
3. Select **"Mode 3: Bring Your Own Storage"**
4. Enter your connection details:
   - **Host:** `localhost` (or your server IP if on different machine)
   - **Port:** `5432`
   - **Database:** `agenticledger_customer_db`
   - **User:** `platform_user`
   - **Password:** `<from .env file>`
5. Click **"Test Connection"**
6. If successful, click **"Save"**

**✅ You're connected!**

---

## 🌐 STEP 5: Cloud Connection (Optional)

If your AgenticLedger app is hosted in the cloud (like Replit), you need to create a secure tunnel from the cloud to your local database.

### Recommended: Tailscale VPN (Easiest)

1. **Install Tailscale** on your local machine:
   - Go to: https://tailscale.com/download
   - Download and install
   - Sign in

2. **Note your Tailscale IP:**
   - Look for IP like `100.x.x.x` in Tailscale app

3. **Install Tailscale on your cloud server** (if needed)

4. **Update AgenticLedger connection:**
   - Change `Host` from `localhost` to your Tailscale IP (e.g., `100.64.0.5`)
   - Keep everything else the same

**Alternative Options:**
- **Cloudflare Tunnel** - Free, no port forwarding needed
- **ngrok** - Quick, good for testing (URL changes on restart)

(Detailed guides available in repository `docs/` folder)

---

## 🔒 STEP 6: Security Checklist

For production use, please review:

- [ ] Changed default password to strong password (32+ characters)
- [ ] Configured firewall to restrict database access
- [ ] Enabled SSL/TLS if accessing over network
- [ ] Set up automated backups
- [ ] Documented connection details securely

See `docs/SECURITY.md` for detailed hardening steps.

---

## 💾 Backup Your Database (Recommended)

### Quick Backup

**Docker:**
```bash
docker-compose exec postgres pg_dump -U platform_user agenticledger_customer_db > backup.sql
```

**Local PostgreSQL:**
```bash
pg_dump -U platform_user agenticledger_customer_db > backup.sql
```

**Save `backup.sql` somewhere safe!**

### Automated Backups

See `docs/BACKUP_RESTORE.md` for automated backup strategies.

---

## ❓ Troubleshooting

### Issue: "Password authentication failed"

**Solution:**
- Double-check password in `.env` file
- Make sure you copied it correctly (no extra spaces)
- Try generating a new password

### Issue: "Connection refused"

**Solution:**
1. Check database is running:
   - Docker: `docker-compose ps`
   - Local: Check PostgreSQL service status

2. Check port 5432 is not blocked by firewall

3. Verify connection details are correct

### Issue: "pgvector extension not found"

**Solution:**
- Docker: Rebuild containers: `docker-compose down && docker-compose up -d --build`
- Local: Re-run setup script

### Issue: "Permission denied"

**Solution:**
- Make sure you ran setup script with admin/sudo privileges
- Check PostgreSQL is running under correct user

### Still Having Issues?

1. Check repository issues: https://github.com/oregpt/Agenticledger_BringYourOwnStorage_repo/issues
2. Create new issue with:
   - Operating system
   - Setup method used
   - Error message (remove any passwords!)
3. Contact AgenticLedger support

---

## 🎉 Success!

You now have:
- ✅ Your own PostgreSQL database running
- ✅ pgvector enabled for AI features
- ✅ All AgenticLedger tables created
- ✅ Secure connection established
- ✅ Full control of your data

**Welcome to AgenticLedger BYOS (Bring Your Own Storage)!** 🚀

---

## 📚 Additional Resources

- **Repository:** https://github.com/oregpt/Agenticledger_BringYourOwnStorage_repo
- **Documentation:** See `docs/` folder in repository
- **AgenticLedger Help:** https://agenticledger.com/support (update this)
- **PostgreSQL Docs:** https://www.postgresql.org/docs/
- **pgvector Docs:** https://github.com/pgvector/pgvector

---

## 🔄 Updating Your Database

When AgenticLedger releases schema updates:

```bash
# Docker users
cd /path/to/Agenticledger_BringYourOwnStorage_repo
git pull origin main
docker-compose down
docker-compose up -d

# Script users
cd /path/to/Agenticledger_BringYourOwnStorage_repo
git pull origin main
./setup.sh  # or .\setup.ps1 for Windows
```

---

**Need Help?** Open an issue on GitHub or contact AgenticLedger support!

---

**Document Version:** 1.0
**Last Updated:** 2025-10-25
**Compatible with:** PostgreSQL 14+, Docker 20+
