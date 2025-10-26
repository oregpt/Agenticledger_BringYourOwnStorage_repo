# How to Publish This to GitHub

## 📋 Quick Steps

### 1. Create GitHub Repository

1. Go to https://github.com/new
2. Create a new repository:
   - **Name:** `agenticledger-customer-db` (or your preferred name)
   - **Description:** "Self-hosted PostgreSQL database with pgvector for AgenticLedger Mode 3 (Customer-Hosted) deployments"
   - **Visibility:** Public (so customers can access) or Private (if you want to control access)
   - **Don't** initialize with README (we already have one)
3. Click "Create repository"

---

### 2. Initialize Git Repository (In This Folder)

Open terminal/PowerShell in this `github-deployment` folder:

```bash
# Initialize git repository
git init

# Add all files
git add .

# Create first commit
git commit -m "Initial commit: AgenticLedger customer database setup"

# Add your GitHub repository as remote
# Replace YOUR-USERNAME and YOUR-REPO-NAME with your actual values
git remote add origin https://github.com/YOUR-USERNAME/agenticledger-customer-db.git

# Push to GitHub
git branch -M main
git push -u origin main
```

---

### 3. Verify Upload

Go to your GitHub repository URL and verify:
- ✅ README.md is displayed
- ✅ All folders are present (schema/, scripts/, docs/)
- ✅ .env file is NOT present (it's in .gitignore)
- ✅ docker-compose.yml is present

---

### 4. Update README with Your Repository URL

After publishing, update these placeholders in README.md:

```markdown
# Change this:
git clone https://github.com/your-org/agenticledger-customer-db.git

# To your actual URL:
git clone https://github.com/YOUR-USERNAME/agenticledger-customer-db.git
```

Then commit and push:

```bash
git add README.md
git commit -m "Update repository URL in README"
git push
```

---

## 🎯 What Customers Will Do

Once published, customers can simply:

```bash
# Clone your repository
git clone https://github.com/YOUR-USERNAME/agenticledger-customer-db.git

# Enter directory
cd agenticledger-customer-db

# Option 1: Docker (easiest)
docker-compose up -d

# Option 2: Automated script
./setup.sh  # Linux/Mac
.\setup.ps1 # Windows PowerShell

# Done! Database ready
```

---

## 📝 Optional: Add a LICENSE

Add an MIT License (or your preferred license):

1. Create file `LICENSE` in root folder
2. Go to https://choosealicense.com/licenses/mit/
3. Copy the license text
4. Replace `[year]` and `[fullname]` with your info
5. Commit and push

```bash
git add LICENSE
git commit -m "Add MIT License"
git push
```

---

## 🔐 Security Notes

**IMPORTANT - Files That Should NEVER Be Committed:**

❌ `.env` - Contains passwords (already in .gitignore)
❌ `backups/` - May contain sensitive data
❌ Any file with real passwords or credentials

**Files That Are Safe to Commit:**

✅ `.env.example` - Template without real passwords
✅ `schema/*.sql` - Database structure only
✅ `setup.sh` and `setup.ps1` - Scripts that generate passwords
✅ `docker-compose.yml` - Uses environment variables
✅ All documentation

---

## 🎨 Optional: Customize Repository

### Add Topics (Tags)

On GitHub repository page:
1. Click "⚙️ Settings"
2. In "Topics" section, add:
   - `postgresql`
   - `pgvector`
   - `docker`
   - `database`
   - `ai`
   - `vector-search`
   - `self-hosted`

### Add Repository Description

Edit the description to:
```
Self-hosted PostgreSQL database with pgvector for AgenticLedger. Supports AI/RAG workloads with vector similarity search. Easy deployment via Docker or automated scripts.
```

### Add a Banner Image (Optional)

Create a nice banner/screenshot showing:
- The setup process
- The folder structure
- Connection successful message

---

## 🚀 Advanced: GitHub Actions (Optional)

If you want automated testing, create `.github/workflows/test.yml`:

```yaml
name: Test Database Setup

on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest

    services:
      postgres:
        image: ankane/pgvector:latest
        env:
          POSTGRES_PASSWORD: test
        options: >-
          --health-cmd pg_isready
          --health-interval 10s
          --health-timeout 5s
          --health-retries 5

    steps:
      - uses: actions/checkout@v3

      - name: Test schema files
        run: |
          for file in schema/*.sql; do
            PGPASSWORD=test psql -h postgres -U postgres -f "$file"
          done

      - name: Verify tables created
        run: |
          TABLE_COUNT=$(PGPASSWORD=test psql -h postgres -U postgres -t -c "SELECT COUNT(*) FROM information_schema.tables WHERE table_schema='public'")
          if [ "$TABLE_COUNT" -eq 5 ]; then
            echo "✓ All 5 tables created"
          else
            echo "✗ Expected 5 tables, found $TABLE_COUNT"
            exit 1
          fi
```

---

## 📚 Documentation Structure (Already Created)

Your repository has this structure:

```
agenticledger-customer-db/
├── README.md                   ✅ Main documentation
├── docker-compose.yml          ✅ Docker setup
├── .env.example                ✅ Environment template
├── .gitignore                  ✅ Prevents committing secrets
├── LICENSE                     ⬜ Add your license
├── setup.sh                    ✅ Linux/Mac setup
├── setup.ps1                   ✅ Windows setup
├── schema/                     ✅ Database schema files
│   ├── 001_enable_extensions.sql
│   ├── 002_create_tables.sql
│   ├── 003_create_indexes.sql
│   └── 004_create_functions.sql
├── docs/                       ⬜ Add detailed guides
│   ├── MANUAL_SETUP.md
│   ├── SECURITY.md
│   ├── TAILSCALE_SETUP.md
│   └── TROUBLESHOOTING.md
├── scripts/                    ⬜ Add utility scripts
│   ├── backup.sh
│   └── restore.sh
└── .github/                    ⬜ Optional CI/CD
    └── workflows/
        └── test.yml
```

---

## ✅ Checklist Before Publishing

- [ ] Verified `.env` is in `.gitignore`
- [ ] Tested Docker Compose setup locally
- [ ] Tested setup scripts (sh/ps1) locally
- [ ] All passwords are in .env.example (not real passwords)
- [ ] README.md has correct repository URL
- [ ] Added LICENSE file
- [ ] Repository description is clear
- [ ] Topics/tags added for discoverability

---

## 🎉 After Publishing

Share with your customers:

1. **Direct link:**
   ```
   https://github.com/YOUR-USERNAME/agenticledger-customer-db
   ```

2. **In your documentation:**
   ```markdown
   For Mode 3 (Customer-Hosted) deployments, see:
   https://github.com/YOUR-USERNAME/agenticledger-customer-db
   ```

3. **In your app settings:**
   Add a "Setup Guide" link that points to your GitHub repo

---

## 📖 Example Customer Email

```
Subject: AgenticLedger Mode 3 - Self-Hosted Database Setup

Hi [Customer],

Thank you for choosing AgenticLedger Mode 3 (Customer-Hosted) for your data residency requirements.

Your database can be set up in just 2 minutes using our automated setup:

1. Clone the repository:
   git clone https://github.com/YOUR-USERNAME/agenticledger-customer-db.git

2. Choose your deployment method:
   - Docker: docker-compose up -d
   - Script: ./setup.sh (Linux/Mac) or .\setup.ps1 (Windows)

3. Connection details will be saved in .env file

Full documentation: https://github.com/YOUR-USERNAME/agenticledger-customer-db

Need help? Reply to this email or visit our support portal.

Best regards,
AgenticLedger Team
```

---

**You're ready to publish!** 🚀

Just run the git commands above and your customers will be able to clone and deploy in minutes.
