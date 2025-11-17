# Quickstart Guide: Universo Platformo Godot

**Feature**: 001-project-setup  
**Date**: 2025-11-17  
**Status**: Complete

## Overview

This quickstart guide provides step-by-step instructions for setting up and running Universo Platformo Godot locally. It covers installing prerequisites, configuring the database, running the application in both client and server modes, and creating your first cluster.

---

## Prerequisites

### Required Software

1. **Godot Engine 4.3+** (latest stable 4.x recommended)
   - Download from: https://godotengine.org/download
   - Verify installation: `godot --version` (should show 4.3 or higher)

2. **Git** (for cloning the repository)
   - Download from: https://git-scm.com/downloads
   - Verify installation: `git --version`

3. **Supabase Account** (for database)
   - Sign up at: https://supabase.com
   - Create a new project
   - Note: Project URL and API keys (anon key and service role key)

### System Requirements

**Development Machine**:
- OS: Linux, Windows, or macOS
- CPU: Intel i5/Ryzen 5 or better (for editor performance)
- RAM: 16GB recommended (8GB minimum)
- Storage: 5GB free space (for Godot, project, and dependencies)
- Graphics: Integrated graphics sufficient

**Target Hardware** (for running the application):
- CPU: Intel i3/Ryzen 3 or better
- RAM: 8GB
- Graphics: Integrated graphics (Intel UHD, AMD Radeon Vega, etc.)

---

## Installation

### Step 1: Clone the Repository

```bash
git clone https://github.com/teknokomo/universo-platformo-godot.git
cd universo-platformo-godot
```

### Step 2: Configure Environment Variables

1. Copy the example environment file:
   ```bash
   cp .env.example .env
   ```

2. Edit `.env` with your favorite text editor:
   ```bash
   nano .env  # or vim, code, etc.
   ```

3. Fill in the required values:
   ```env
   # Database (Supabase)
   SUPABASE_URL=https://your-project.supabase.co
   SUPABASE_ANON_KEY=your-anon-key-here
   SUPABASE_SERVICE_ROLE_KEY=your-service-role-key-here
   
   # Authentication
   JWT_SECRET=generate-a-secure-256-bit-secret-here
   JWT_EXPIRY=900  # 15 minutes in seconds
   REFRESH_TOKEN_EXPIRY=2592000  # 30 days
   
   # Server
   SERVER_HOST=0.0.0.0
   SERVER_PORT=8080
   WS_PORT=8081
   
   # Application
   ENVIRONMENT=development
   LOG_LEVEL=INFO
   ```

   **Generating JWT_SECRET**: Use a secure random generator:
   ```bash
   # Linux/macOS
   openssl rand -base64 32
   
   # Or online generator: https://generate-secret.vercel.app/32
   ```

### Step 3: Set Up Database Schema

1. Open Supabase dashboard: https://app.supabase.com
2. Navigate to your project → SQL Editor
3. Open `specs/001-project-setup/contracts/database.sql` in a text editor
4. Copy the entire SQL content
5. Paste into Supabase SQL Editor and click "Run"
6. Verify tables created: Go to "Table Editor" tab, should see tables: `users`, `clusters`, `domains`, `resources`, etc.

**Alternative (CLI method)**:
```bash
# If you have Supabase CLI installed
supabase db push --schema specs/001-project-setup/contracts/database.sql
```

### Step 4: Open Project in Godot Editor

1. Launch Godot Engine
2. Click "Import" button
3. Navigate to cloned repository directory
4. Select `project.godot` file
5. Click "Import & Edit"
6. Wait for initial project import (may take 30-60 seconds)

**First-time import** will:
- Parse all GDScript files
- Import assets (themes, translations, icons)
- Load addons (packages)
- Validate project configuration

### Step 5: Install GUT Testing Framework (Optional but Recommended)

1. Download GUT from Asset Library:
   - In Godot Editor: **AssetLib** tab → Search "GUT" → Download → Install
2. Or manually:
   ```bash
   cd universo-platformo-godot
   git clone https://github.com/bitwes/Gut.git addons/gut
   ```
3. Enable in Project Settings:
   - **Project → Project Settings → Plugins** → Enable "Gut"

---

## Running the Application

### Client Mode (with UI)

**Method 1: From Godot Editor**
1. Open project in Godot Editor
2. Press **F5** or click "Run Project" button (play icon in top-right)
3. Application window opens with main dashboard

**Method 2: From Command Line**
```bash
godot --path /path/to/universo-platformo-godot
```

**Expected Behavior**:
- Window opens showing Universo Platformo dashboard
- Left sidebar with navigation menu (Clusters, Metaverses, Spaces, etc.)
- Top bar with user profile and settings
- Main area shows welcome screen or default view

**Troubleshooting**:
- **Error: "Database connection failed"**: Check `.env` file, verify Supabase URL and keys
- **Error: "Scene not found"**: Verify `scenes/main.tscn` exists
- **Blank window**: Check console output for script errors

### Server Mode (Headless)

**Purpose**: Run backend API and WebSocket server without UI (for production deployment)

**Command**:
```bash
godot --path /path/to/universo-platformo-godot --headless --script scripts/server.gd
```

**Alternative using flag**:
```bash
godot --path /path/to/universo-platformo-godot -- --server
```

**Expected Behavior**:
- Console output shows:
  ```
  [INFO] Universo Platformo Godot - Server Mode
  [INFO] Loading configuration from .env and config.json
  [INFO] Database connection established
  [INFO] Running migrations... 0 pending
  [INFO] HTTP server listening on 0.0.0.0:8080
  [INFO] WebSocket server listening on 0.0.0.0:8081
  [INFO] Server ready to accept connections
  ```

**Testing Server**:
```bash
# Test HTTP endpoint
curl http://localhost:8080/api/health

# Expected response:
# {"status": "ok", "timestamp": 1699999999}
```

**Stopping Server**:
- Press **Ctrl+C** in terminal (sends SIGTERM)
- Server performs graceful shutdown:
  - Closes active connections
  - Saves pending data
  - Logs shutdown event

---

## Creating Your First Cluster

### Via UI (Client Mode)

1. **Launch Application** (Client Mode)
2. **Register/Login**:
   - First time: Click "Register" → Enter email, password, display name → Submit
   - Returning: Click "Login" → Enter email, password → Submit
3. **Navigate to Clusters**:
   - Click "Clusters" in left sidebar
   - Click "+ New Cluster" button (top-right)
4. **Create Cluster**:
   - Name: `My First Cluster`
   - Description: `A test cluster for quickstart`
   - Public: Unchecked (private)
   - Click "Create"
5. **Verify Creation**:
   - Cluster appears in list
   - Click cluster name to view details
   - Should show: Name, Description, Created date, Owner (you)

### Via API (cURL)

1. **Register User**:
   ```bash
   curl -X POST http://localhost:8080/api/auth/register \
     -H "Content-Type: application/json" \
     -d '{
       "email": "test@example.com",
       "password": "SecurePass123",
       "display_name": "Test User"
     }'
   ```

   **Response**:
   ```json
   {
     "user": {
       "id": "550e8400-e29b-41d4-a716-446655440000",
       "email": "test@example.com",
       "display_name": "Test User",
       ...
     },
     "access_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
     "refresh_token": "...",
     "expires_at": 1700000900
   }
   ```

2. **Save Access Token** (for subsequent requests):
   ```bash
   export ACCESS_TOKEN="your-access-token-here"
   ```

3. **Create Cluster**:
   ```bash
   curl -X POST http://localhost:8080/api/clusters \
     -H "Content-Type: application/json" \
     -H "Authorization: Bearer $ACCESS_TOKEN" \
     -d '{
       "name": "My First Cluster",
       "description": "A test cluster for quickstart",
       "is_public": false
     }'
   ```

   **Response**:
   ```json
   {
     "id": "a1b2c3d4-e5f6-7890-abcd-ef1234567890",
     "name": "My First Cluster",
     "description": "A test cluster for quickstart",
     "owner_id": "550e8400-e29b-41d4-a716-446655440000",
     "created_at": 1699999999,
     "updated_at": 1699999999,
     "is_public": false,
     "metadata": {}
   }
   ```

4. **List Clusters**:
   ```bash
   curl -X GET http://localhost:8080/api/clusters \
     -H "Authorization: Bearer $ACCESS_TOKEN"
   ```

---

## Running Tests

### Unit Tests

**Run all unit tests**:
```bash
godot --path /path/to/universo-platformo-godot -s addons/gut/gut_cmdln.gd -gtest=tests/unit/
```

**Run specific test file**:
```bash
godot --path . -s addons/gut/gut_cmdln.gd -gtest=tests/unit/test_database_manager.gd
```

### Integration Tests

**Run all integration tests**:
```bash
godot --path . -s addons/gut/gut_cmdln.gd -gtest=tests/integration/
```

### Contract Tests (API)

**Run API contract tests**:
```bash
godot --path . -s addons/gut/gut_cmdln.gd -gtest=tests/contract/
```

### All Tests

**Run entire test suite**:
```bash
godot --path . -s addons/gut/gut_cmdln.gd -gtest=tests/
```

**Expected Output**:
```
====================================
GUT v9.x.x
Running tests...
====================================

Unit Tests (tests/unit/)
  test_config.gd
    ✓ test_load_env_file_success (0.05s)
    ✓ test_load_config_json_success (0.03s)
    ...
  test_database_manager.gd
    ✓ test_connect_to_supabase_success (0.12s)
    ✓ test_query_users_table_success (0.08s)
    ...

Integration Tests (tests/integration/)
  test_clusters_crud.gd
    ✓ test_create_cluster_success (0.15s)
    ✓ test_read_cluster_success (0.10s)
    ...

====================================
Total: 47 tests
Passed: 47
Failed: 0
====================================
```

---

## Validation

### Run Validation Script

The repository includes a validation script to check structure and documentation:

```bash
./validate.sh
```

**What it checks**:
- Repository structure (required directories exist)
- Bilingual documentation (English/Russian line count match)
- Package structure (plugin.cfg files present)
- .env.example completeness
- Godot project configuration

**Expected Output**:
```
[✓] Repository structure valid
[✓] Documentation structure valid
  - README.md / README-RU.md: 215 lines (within ±2 tolerance)
  - CONTRIBUTING.md / CONTRIBUTING-RU.md: 198 lines (within ±2 tolerance)
  - ARCHITECTURE.md / ARCHITECTURE-RU.md: 312 lines (within ±2 tolerance)
[✓] Package structure valid
  - universo-utils: plugin.cfg present
  - universo-types: plugin.cfg present
  - clusters-frt: plugin.cfg present
  - clusters-srv: plugin.cfg present
[✓] Configuration files valid
  - .env.example complete
  - config.json valid JSON
[✓] All checks passed
```

---

## Next Steps

### Explore the Clusters Feature

1. **Create Domains within Cluster**:
   - Open cluster details
   - Click "+ New Domain"
   - Name: `Development Domain`
   - Create

2. **Add Resources to Domain**:
   - Open domain details
   - Click "+ New Resource"
   - Name: `Project Documentation`
   - Type: `link`
   - Data: `{"url": "https://docs.example.com"}`
   - Create

3. **Real-Time Sync Test**:
   - Open application in two browser windows (or two client instances)
   - Create/update cluster in one window
   - Verify update appears in other window within 2 seconds

### Implement a New Feature

Follow the Clusters feature as a template:

1. **Create Feature Spec**: `.specify/features/002-your-feature/spec.md`
2. **Generate Plan**: Run `.specify/scripts/bash/setup-plan.sh`
3. **Design Data Model**: Add entities to `data-model.md`
4. **Implement Backend** (`packages/your-feature-srv/`):
   - Models (entity classes)
   - Repositories (data access)
   - Services (business logic)
   - API endpoints (HTTP routes)
5. **Implement Frontend** (`packages/your-feature-frt/`):
   - Scenes (UI layouts)
   - Scripts (controllers, state management)
6. **Write Tests**: Unit, integration, contract tests
7. **Document**: README.md (English + Russian)

### Deploy to Production

**Preparation**:
1. Update `.env` with production Supabase credentials
2. Change `ENVIRONMENT=production`
3. Set `LOG_LEVEL=ERROR` or `WARN`
4. Generate strong `JWT_SECRET` (different from development)

**Export Godot Project**:
1. Godot Editor → **Project → Export**
2. Add export template for target platform (Linux, Windows, macOS)
3. Configure export settings:
   - Enable "Embed PCK" (for single executable)
   - Set export path: `builds/universo-platformo-godot-server`
4. Click "Export Project"

**Run on Server**:
```bash
# Copy exported binary to server
scp builds/universo-platformo-godot-server user@server:/opt/universo/

# SSH into server
ssh user@server

# Run in headless mode with systemd
sudo systemctl start universo-platformo-godot

# Check status
sudo systemctl status universo-platformo-godot
```

**Systemd Unit File** (`/etc/systemd/system/universo-platformo-godot.service`):
```ini
[Unit]
Description=Universo Platformo Godot Server
After=network.target

[Service]
Type=simple
User=universo
WorkingDirectory=/opt/universo
ExecStart=/opt/universo/universo-platformo-godot-server --headless --server
Restart=on-failure
RestartSec=10s

[Install]
WantedBy=multi-user.target
```

---

## Troubleshooting

### Common Issues

**Issue: "Godot Editor won't open project"**
- **Cause**: Incompatible Godot version (< 4.3)
- **Solution**: Update Godot to 4.3 or later

**Issue: "Database connection failed"**
- **Cause**: Incorrect Supabase credentials in `.env`
- **Solution**: Verify `SUPABASE_URL` and keys in Supabase dashboard

**Issue: "JWT token invalid"**
- **Cause**: `JWT_SECRET` mismatch or token expired
- **Solution**: Re-login to get fresh token, verify `JWT_SECRET` consistent across restarts

**Issue: "WebSocket connection refused"**
- **Cause**: Server not running or firewall blocking port 8081
- **Solution**: Ensure server running in headless mode, check firewall rules

**Issue: "Test failures"**
- **Cause**: Database not initialized or environment mismatch
- **Solution**: Run database migration, set `ENVIRONMENT=development` for tests

### Getting Help

**Documentation**:
- Architecture: `ARCHITECTURE.md` / `ARCHITECTURE-RU.md`
- Contributing: `CONTRIBUTING.md` / `CONTRIBUTING-RU.md`
- Feature Parity (React comparison): `FEATURE_PARITY.md` / `FEATURE_PARITY-RU.md`

**Community**:
- GitHub Issues: https://github.com/teknokomo/universo-platformo-godot/issues
- Discussions: https://github.com/teknokomo/universo-platformo-godot/discussions

**Reference Implementation**:
- Universo Platformo React: https://github.com/teknokomo/universo-platformo-react

---

## Summary

You have successfully:
- ✅ Installed Godot Engine 4.3+ and prerequisites
- ✅ Cloned and configured Universo Platformo Godot
- ✅ Set up Supabase database with schema
- ✅ Run the application in client and server modes
- ✅ Created your first cluster via UI and API
- ✅ Run tests to verify functionality
- ✅ Validated repository structure and documentation

**Next**: Explore the codebase, implement new features following the Clusters pattern, and contribute back to the project!

---

**Status**: ✅ COMPLETE  
**Last Updated**: 2025-11-17
