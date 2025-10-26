#!/bin/bash

# ================================================================
# AgenticLedger Customer Database Setup Script
# For Linux and macOS
# ================================================================

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}================================================================${NC}"
echo -e "${BLUE}AgenticLedger Customer Database Setup${NC}"
echo -e "${BLUE}================================================================${NC}"
echo ""

# Function to print colored messages
print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_error() {
    echo -e "${RED}✗ $1${NC}"
}

print_info() {
    echo -e "${BLUE}ℹ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠ $1${NC}"
}

# Check if PostgreSQL is installed
check_postgresql() {
    echo "Checking for PostgreSQL..."
    if command -v psql &> /dev/null; then
        PG_VERSION=$(psql --version | awk '{print $3}')
        print_success "PostgreSQL $PG_VERSION found"
        return 0
    else
        print_error "PostgreSQL not found"
        echo ""
        echo "Please install PostgreSQL 14 or higher:"
        echo "  - Ubuntu/Debian: sudo apt-get install postgresql postgresql-contrib"
        echo "  - CentOS/RHEL: sudo yum install postgresql-server postgresql-contrib"
        echo "  - macOS: brew install postgresql@17"
        echo ""
        exit 1
    fi
}

# Check if pgvector is installed
check_pgvector() {
    echo "Checking for pgvector extension..."
    if psql -U postgres -c "SELECT 1 FROM pg_available_extensions WHERE name='vector'" 2>/dev/null | grep -q 1; then
        print_success "pgvector extension available"
        return 0
    else
        print_warning "pgvector not found, will attempt to install"
        install_pgvector
    fi
}

# Install pgvector
install_pgvector() {
    echo "Installing pgvector..."

    # Check OS
    if [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS
        if command -v brew &> /dev/null; then
            brew install pgvector
            print_success "pgvector installed via Homebrew"
        else
            print_error "Homebrew not found. Please install pgvector manually."
            exit 1
        fi
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        # Linux - compile from source
        print_info "Compiling pgvector from source..."
        cd /tmp
        git clone --branch v0.8.1 https://github.com/pgvector/pgvector.git
        cd pgvector
        make
        sudo make install
        cd ..
        rm -rf pgvector
        print_success "pgvector compiled and installed"
    else
        print_error "Unsupported OS for automatic pgvector installation"
        exit 1
    fi
}

# Generate secure password
generate_password() {
    openssl rand -base64 32 | tr -d "=+/" | cut -c1-32
}

# Create .env file
create_env_file() {
    if [ -f .env ]; then
        print_warning ".env file already exists, skipping creation"
        return 0
    fi

    echo "Creating .env file..."

    # Generate secure passwords
    DB_PASSWORD=$(generate_password)
    POSTGRES_PASSWORD=$(generate_password)
    PGADMIN_PASSWORD=$(generate_password)

    cat > .env <<EOF
# AgenticLedger Customer Database Configuration
# Generated: $(date)

# Database Configuration
DB_HOST=localhost
DB_PORT=5432
DB_NAME=agenticledger_customer_db
DB_USER=platform_user
DB_PASSWORD=$DB_PASSWORD

# PostgreSQL Admin
POSTGRES_PASSWORD=$POSTGRES_PASSWORD

# pgAdmin Configuration (optional)
PGADMIN_EMAIL=admin@agenticledger.local
PGADMIN_PASSWORD=$PGADMIN_PASSWORD
PGADMIN_PORT=5050

# Application Configuration
APP_ENV=production
APP_PORT=3000

# Security
SSL_MODE=disable

# Backup Configuration
BACKUP_RETENTION_DAYS=30
BACKUP_SCHEDULE="0 2 * * *"
EOF

    chmod 600 .env
    print_success ".env file created with secure passwords"
}

# Create database
create_database() {
    echo "Creating database..."

    # Load environment variables
    source .env

    # Create database and user
    sudo -u postgres psql <<EOF
-- Create database
CREATE DATABASE ${DB_NAME};

-- Connect to database
\\c ${DB_NAME}

-- Enable pgvector
CREATE EXTENSION IF NOT EXISTS vector;

-- Create user
CREATE USER ${DB_USER} WITH PASSWORD '${DB_PASSWORD}';

-- Grant permissions
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO ${DB_USER};
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO ${DB_USER};

ALTER DEFAULT PRIVILEGES IN SCHEMA public
  GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO ${DB_USER};

ALTER DEFAULT PRIVILEGES IN SCHEMA public
  GRANT USAGE, SELECT ON SEQUENCES TO ${DB_USER};
EOF

    print_success "Database and user created"
}

# Run schema migrations
run_migrations() {
    echo "Running database schema migrations..."

    # Load environment variables
    source .env

    # Run each schema file in order
    for sql_file in schema/*.sql; do
        if [ -f "$sql_file" ]; then
            print_info "Running $(basename $sql_file)..."
            sudo -u postgres psql -d ${DB_NAME} -f "$sql_file"
        fi
    done

    print_success "Schema migrations completed"
}

# Verify installation
verify_installation() {
    echo ""
    echo "Verifying installation..."

    source .env

    # Check tables
    TABLE_COUNT=$(sudo -u postgres psql -d ${DB_NAME} -t -c "SELECT COUNT(*) FROM information_schema.tables WHERE table_schema='public' AND table_type='BASE TABLE'")

    if [ "$TABLE_COUNT" -eq 5 ]; then
        print_success "All 5 tables created"
    else
        print_error "Expected 5 tables, found $TABLE_COUNT"
        exit 1
    fi

    # Check pgvector
    if sudo -u postgres psql -d ${DB_NAME} -t -c "SELECT 1 FROM pg_extension WHERE extname='vector'" | grep -q 1; then
        print_success "pgvector extension enabled"
    else
        print_error "pgvector extension not found"
        exit 1
    fi

    echo ""
    print_success "Installation verified successfully!"
}

# Print connection details
print_connection_info() {
    source .env

    echo ""
    echo -e "${BLUE}================================================================${NC}"
    echo -e "${BLUE}Installation Complete!${NC}"
    echo -e "${BLUE}================================================================${NC}"
    echo ""
    echo "Your connection details (also saved in .env):"
    echo ""
    echo "  Host:     ${DB_HOST}"
    echo "  Port:     ${DB_PORT}"
    echo "  Database: ${DB_NAME}"
    echo "  User:     ${DB_USER}"
    echo "  Password: ${DB_PASSWORD}"
    echo ""
    echo "Connection string:"
    echo "  postgresql://${DB_USER}:${DB_PASSWORD}@${DB_HOST}:${DB_PORT}/${DB_NAME}"
    echo ""
    echo "Quick test:"
    echo "  psql -h ${DB_HOST} -U ${DB_USER} -d ${DB_NAME} -c '\\dt'"
    echo ""
    echo -e "${GREEN}✓ Your AgenticLedger database is ready to use!${NC}"
    echo ""
}

# Main installation flow
main() {
    check_postgresql
    check_pgvector
    create_env_file
    create_database
    run_migrations
    verify_installation
    print_connection_info
}

# Run main installation
main
