# ================================================================
# AgenticLedger Customer Database Setup Script
# For Windows PowerShell
# ================================================================

$ErrorActionPreference = "Stop"

Write-Host "================================================================" -ForegroundColor Cyan
Write-Host "AgenticLedger Customer Database Setup" -ForegroundColor Cyan
Write-Host "================================================================" -ForegroundColor Cyan
Write-Host ""

# Function to print colored messages
function Print-Success {
    param([string]$Message)
    Write-Host "✓ $Message" -ForegroundColor Green
}

function Print-Error {
    param([string]$Message)
    Write-Host "✗ $Message" -ForegroundColor Red
}

function Print-Info {
    param([string]$Message)
    Write-Host "ℹ $Message" -ForegroundColor Blue
}

function Print-Warning {
    param([string]$Message)
    Write-Host "⚠ $Message" -ForegroundColor Yellow
}

# Check if PostgreSQL is installed
function Test-PostgreSQL {
    Write-Host "Checking for PostgreSQL..."

    $psqlPath = "C:\Program Files\PostgreSQL\17\bin\psql.exe"

    if (Test-Path $psqlPath) {
        $version = & $psqlPath --version
        Print-Success "PostgreSQL found: $version"
        return $psqlPath
    } else {
        Print-Error "PostgreSQL not found at $psqlPath"
        Write-Host ""
        Write-Host "Please install PostgreSQL 14 or higher from:"
        Write-Host "  https://www.postgresql.org/download/windows/"
        Write-Host ""
        exit 1
    }
}

# Check if pgvector is installed
function Test-PgVector {
    param([string]$PsqlPath)

    Write-Host "Checking for pgvector extension..."

    $result = & $PsqlPath -U postgres -c "SELECT 1 FROM pg_available_extensions WHERE name='vector'" 2>$null

    if ($result -match "1") {
        Print-Success "pgvector extension available"
        return $true
    } else {
        Print-Warning "pgvector not found"
        return $false
    }
}

# Install pgvector
function Install-PgVector {
    Print-Info "Installing pgvector for Windows..."

    # Download pre-built binaries
    $downloadUrl = "https://github.com/andreiramani/pgvector_pgsql_windows/releases/download/0.8.1_17.6/vector.v0.8.1-pg17.zip"
    $downloadPath = "$env:TEMP\pgvector.zip"
    $extractPath = "$env:TEMP\pgvector"

    Print-Info "Downloading pgvector binaries..."
    Invoke-WebRequest -Uri $downloadUrl -OutFile $downloadPath

    Print-Info "Extracting..."
    Expand-Archive -Path $downloadPath -DestinationPath $extractPath -Force

    Print-Info "Installing pgvector files..."
    Copy-Item -Path "$extractPath\*" -Destination "C:\Program Files\PostgreSQL\17\" -Recurse -Force

    # Cleanup
    Remove-Item $downloadPath
    Remove-Item $extractPath -Recurse

    Print-Success "pgvector installed"
}

# Generate secure password
function New-SecurePassword {
    $bytes = New-Object Byte[] 32
    [Security.Cryptography.RNGCryptoServiceProvider]::Create().GetBytes($bytes)
    return [Convert]::ToBase64String($bytes).Substring(0,32) -replace '[+/=]',''
}

# Create .env file
function New-EnvFile {
    if (Test-Path ".env") {
        Print-Warning ".env file already exists, skipping creation"
        return
    }

    Write-Host "Creating .env file..."

    # Generate secure passwords
    $dbPassword = New-SecurePassword
    $postgresPassword = New-SecurePassword
    $pgAdminPassword = New-SecurePassword

    $envContent = @"
# AgenticLedger Customer Database Configuration
# Generated: $(Get-Date)

# Database Configuration
DB_HOST=localhost
DB_PORT=5432
DB_NAME=agenticledger_customer_db
DB_USER=platform_user
DB_PASSWORD=$dbPassword

# PostgreSQL Admin
POSTGRES_PASSWORD=$postgresPassword

# pgAdmin Configuration (optional)
PGADMIN_EMAIL=admin@agenticledger.local
PGADMIN_PASSWORD=$pgAdminPassword
PGADMIN_PORT=5050

# Application Configuration
APP_ENV=production
APP_PORT=3000

# Security
SSL_MODE=disable

# Backup Configuration
BACKUP_RETENTION_DAYS=30
BACKUP_SCHEDULE="0 2 * * *"
"@

    $envContent | Out-File -FilePath ".env" -Encoding UTF8
    Print-Success ".env file created with secure passwords"
}

# Load environment variables
function Get-EnvVariables {
    $env = @{}
    Get-Content ".env" | ForEach-Object {
        if ($_ -match '^([^#][^=]+)=(.*)$') {
            $env[$matches[1].Trim()] = $matches[2].Trim()
        }
    }
    return $env
}

# Create database
function New-Database {
    param([string]$PsqlPath)

    Write-Host "Creating database..."

    $env = Get-EnvVariables

    # Create SQL script
    $createDbScript = @"
-- Create database
CREATE DATABASE $($env.DB_NAME);
"@

    # Run as postgres user
    $createDbScript | & $PsqlPath -U postgres 2>&1 | Out-Null

    # Create user and grant permissions
    $setupScript = @"
-- Enable pgvector
CREATE EXTENSION IF NOT EXISTS vector;

-- Create user
CREATE USER $($env.DB_USER) WITH PASSWORD '$($env.DB_PASSWORD)';

-- Grant permissions
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO $($env.DB_USER);
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO $($env.DB_USER);

ALTER DEFAULT PRIVILEGES IN SCHEMA public
  GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO $($env.DB_USER);

ALTER DEFAULT PRIVILEGES IN SCHEMA public
  GRANT USAGE, SELECT ON SEQUENCES TO $($env.DB_USER);
"@

    $setupScript | & $PsqlPath -U postgres -d $env.DB_NAME 2>&1 | Out-Null

    Print-Success "Database and user created"
}

# Run schema migrations
function Invoke-Migrations {
    param([string]$PsqlPath)

    Write-Host "Running database schema migrations..."

    $env = Get-EnvVariables

    # Run each schema file in order
    Get-ChildItem "schema\*.sql" | Sort-Object Name | ForEach-Object {
        Print-Info "Running $($_.Name)..."
        Get-Content $_.FullName | & $PsqlPath -U postgres -d $env.DB_NAME 2>&1 | Out-Null
    }

    Print-Success "Schema migrations completed"
}

# Verify installation
function Test-Installation {
    param([string]$PsqlPath)

    Write-Host ""
    Write-Host "Verifying installation..."

    $env = Get-EnvVariables

    # Check tables
    $tableCount = & $PsqlPath -U postgres -d $env.DB_NAME -t -c "SELECT COUNT(*) FROM information_schema.tables WHERE table_schema='public' AND table_type='BASE TABLE'" 2>&1
    $tableCount = [int]$tableCount.Trim()

    if ($tableCount -eq 5) {
        Print-Success "All 5 tables created"
    } else {
        Print-Error "Expected 5 tables, found $tableCount"
        exit 1
    }

    # Check pgvector
    $vectorCheck = & $PsqlPath -U postgres -d $env.DB_NAME -t -c "SELECT 1 FROM pg_extension WHERE extname='vector'" 2>&1

    if ($vectorCheck -match "1") {
        Print-Success "pgvector extension enabled"
    } else {
        Print-Error "pgvector extension not found"
        exit 1
    }

    Write-Host ""
    Print-Success "Installation verified successfully!"
}

# Print connection details
function Show-ConnectionInfo {
    $env = Get-EnvVariables

    Write-Host ""
    Write-Host "================================================================" -ForegroundColor Cyan
    Write-Host "Installation Complete!" -ForegroundColor Cyan
    Write-Host "================================================================" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Your connection details (also saved in .env):"
    Write-Host ""
    Write-Host "  Host:     $($env.DB_HOST)"
    Write-Host "  Port:     $($env.DB_PORT)"
    Write-Host "  Database: $($env.DB_NAME)"
    Write-Host "  User:     $($env.DB_USER)"
    Write-Host "  Password: $($env.DB_PASSWORD)"
    Write-Host ""
    Write-Host "Connection string:"
    Write-Host "  postgresql://$($env.DB_USER):$($env.DB_PASSWORD)@$($env.DB_HOST):$($env.DB_PORT)/$($env.DB_NAME)"
    Write-Host ""
    Write-Host "Quick test:"
    Write-Host "  psql -h $($env.DB_HOST) -U $($env.DB_USER) -d $($env.DB_NAME) -c '\dt'"
    Write-Host ""
    Write-Host "✓ Your AgenticLedger database is ready to use!" -ForegroundColor Green
    Write-Host ""
}

# Main installation flow
function Start-Installation {
    $psqlPath = Test-PostgreSQL

    $hasPgVector = Test-PgVector -PsqlPath $psqlPath
    if (-not $hasPgVector) {
        Install-PgVector
        # Restart PostgreSQL to load pgvector
        Restart-Service postgresql-x64-17
        Start-Sleep -Seconds 3
    }

    New-EnvFile
    New-Database -PsqlPath $psqlPath
    Invoke-Migrations -PsqlPath $psqlPath
    Test-Installation -PsqlPath $psqlPath
    Show-ConnectionInfo
}

# Run main installation
Start-Installation
