# Research Document: Universo Platformo Godot - Project Setup & Foundation

**Feature**: 001-project-setup  
**Date**: 2025-11-17  
**Status**: Complete

## Overview

This document consolidates research findings for establishing the foundational architecture of Universo Platformo Godot. All technical decisions and unknowns from the Technical Context have been resolved through analysis of Godot Engine capabilities, community best practices, and reference implementation patterns from Universo Platformo React.

## Research Questions & Findings

### 1. HTTP Server Implementation in Godot 4.3+

**Question**: Which HTTP server implementation should be used for the backend?

**Decision**: Use Godot 4.3's native `HTTPServer` class with fallback to third-party addon if limitations encountered

**Rationale**:
- Godot 4.3+ introduced native `HTTPServer` class in the core engine
- Provides built-in support for handling HTTP requests without external dependencies
- Performance suitable for 100-500 concurrent users (target range)
- If native implementation proves insufficient, community addons available (e.g., `godot-http-server` addon)
- Native implementation ensures long-term compatibility and maintenance

**Alternatives Considered**:
- **Third-party HTTP addon (e.g., godot-http-server)**: Rejected as primary choice because native implementation should be tried first; can serve as fallback
- **External server proxy (Node.js/Python backend with Godot client)**: Rejected because it violates Godot-Native Architecture principle and adds deployment complexity
- **TCP socket-based custom HTTP server**: Rejected due to implementation complexity and security concerns (manual HTTP parsing, security header management)

**Implementation Notes**:
- Native `HTTPServer` methods: `listen()`, `poll()`, `stop()`, `get_response_queue()`
- Request handling via signals or polling mechanism
- Response construction with status codes, headers, body
- MIME type handling for JSON/HTML/file responses
- Concurrent connection management with configurable limits

---

### 2. WebSocket Real-Time Synchronization

**Question**: How should WebSocket communication be implemented for real-time entity synchronization?

**Decision**: Use Godot's native `WebSocketServer` and `WebSocketPeer` classes with JSON message protocol

**Rationale**:
- Native WebSocket support in Godot provides reliable, performant real-time communication
- `WebSocketServer` handles multiple client connections efficiently
- `WebSocketPeer` represents individual client connections with lifecycle management
- JSON message format ensures cross-platform compatibility and debugging ease
- Signal-based event system integrates naturally with Godot's architecture

**Alternatives Considered**:
- **HTTP long-polling**: Rejected due to higher latency (>1s vs <100ms), increased server load, and resource inefficiency
- **Server-Sent Events (SSE)**: Rejected because unidirectional (server→client only), would require separate HTTP requests for client→server updates
- **Custom TCP protocol**: Rejected due to implementation complexity and lack of standard tooling for debugging/monitoring

**Implementation Notes**:
- Message format: `{"type": "entity_update", "entity": "cluster", "action": "create|update|delete", "id": "uuid", "data": {...}, "timestamp": 1699999999, "user_id": "uuid"}`
- Connection lifecycle: connect → authenticate → subscribe to entities → receive updates → disconnect
- Reconnection logic: exponential backoff (1s, 2s, 4s, 8s, 16s, max 30s)
- Message queue: client-side queue (max 100 messages) during disconnection
- Broadcast strategy: server broadcasts to all clients subscribed to entity type

---

### 3. Database Integration - Supabase REST API vs Direct PostgreSQL

**Question**: Should database access use Supabase REST API or direct PostgreSQL connection?

**Decision**: Use Supabase REST API via `HTTPRequest` for initial implementation; evaluate direct PostgreSQL later

**Rationale**:
- Supabase REST API provides auth integration, row-level security, and real-time subscriptions out-of-the-box
- `HTTPRequest` node readily available in Godot without additional dependencies
- REST API abstracts database connection management, pooling, and security
- Easier to implement cross-platform (desktop, web, mobile exports)
- Future migration to direct PostgreSQL possible if performance becomes bottleneck

**Alternatives Considered**:
- **Direct PostgreSQL connection via addon**: Considered for future optimization; requires third-party addon (godot-postgres), adds dependency management complexity, harder cross-platform support (especially for web exports)
- **GraphQL with Supabase**: Rejected because REST API simpler for CRUD operations, GraphQL adds unnecessary complexity for this use case
- **ORM/query builder library**: Rejected because limited GDScript ecosystem for ORMs, would need custom implementation

**Implementation Notes**:
- DatabaseManager class wraps HTTPRequest for all DB operations
- Methods: `query(sql, params)`, `insert(table, data)`, `update(table, id, data)`, `delete(table, id)`, `select(table, filters)`
- Authentication: Supabase service role key in `.env` file, JWT tokens for user-scoped operations
- Connection pooling: HTTPRequest pool (5-20 concurrent requests)
- Error handling: retry logic with exponential backoff (3 attempts max)
- Transaction support: use Supabase RPC functions for multi-statement transactions

---

### 4. Authentication Strategy Pattern - JWT Implementation

**Question**: How should authentication be structured to support JWT initially with extensibility for OAuth2/custom providers?

**Decision**: Implement strategy pattern with `BaseAuthStrategy` interface and `JWTAuthStrategy` initial implementation

**Rationale**:
- Strategy pattern enables swapping authentication mechanisms without changing consuming code
- Passport.js-inspired design (from Universo Platformo React) adapted to GDScript
- JWT provides stateless authentication suitable for distributed systems
- Extensibility allows future OAuth2Strategy, APIKeyStrategy, CustomStrategy additions
- Clear separation of concerns: AuthManager orchestrates, strategies implement specifics

**Alternatives Considered**:
- **Hardcoded JWT logic**: Rejected because inflexible, violates open/closed principle, difficult to extend
- **Plugin-based authentication**: Rejected as over-engineered for initial implementation, strategy pattern simpler
- **Session-based authentication**: Rejected because stateful, harder to scale horizontally, doesn't fit WebSocket real-time architecture

**Implementation Notes**:
- **BaseAuthStrategy** (abstract interface):
  - `authenticate(credentials: Dictionary) -> AuthResult`
  - `validate_token(token: String) -> User`
  - `refresh_token(refresh_token: String) -> TokenPair`
  - `revoke_token(token: String) -> bool`

- **JWTAuthStrategy** (initial implementation):
  - HS256 algorithm with 256-bit secret (stored in `.env` as `JWT_SECRET`)
  - Payload: `{user_id, email, roles[], issued_at, expires_at}`
  - Access token: 15-minute expiry
  - Refresh token: 30-day expiry, stored in database table `refresh_tokens`
  - Token validation: signature verification, expiry check, revocation check

- **AuthManager** (orchestrator):
  - Dependency injection: accepts strategy in constructor
  - Methods delegate to active strategy
  - Manages session state in memory: `Dictionary[user_id, SessionData]`
  - Periodic cleanup of expired sessions (every 5 minutes)

---

### 5. Material Design UI Implementation in Godot

**Question**: How should Material Design principles be implemented without external UI framework?

**Decision**: Use Godot's native Control nodes with custom Theme resources following Material Design guidelines

**Rationale**:
- Godot's Control node system is flexible and performant
- Theme resources allow centralized styling (colors, fonts, margins, etc.)
- Material Design guidelines provide clear specifications for component behavior and appearance
- No external dependencies required, maintains Godot-Native Architecture principle
- Custom components can extend base Control nodes (Button, LineEdit, etc.)

**Alternatives Considered**:
- **Port existing Material UI library**: Rejected because no mature Material Design library for Godot, porting React/Flutter libraries is impractical
- **Use Godot's default theme**: Rejected because doesn't follow Material Design aesthetics, inconsistent with Universo Platformo branding
- **Third-party UI framework (e.g., Godot UI Library addon)**: Rejected because adds external dependency, limited Material Design implementations available

**Implementation Notes**:
- **Core Material Components** (in `universo-template-godot` package):
  - `MaterialButton`: extends Button, adds ripple effect, elevation shadows
  - `MaterialCard`: extends Panel, adds elevation, rounded corners, shadow
  - `MaterialDialog`: extends Popup, adds modal overlay, slide-in animation
  - `MaterialInput`: extends LineEdit, adds floating label, helper text, validation styling
  - `MaterialList`: extends VBoxContainer, adds item selection, dividers
  - `DataGrid`: extends Control, adds sortable columns, pagination, filtering

- **Theme Resources**:
  - `material_light.tres`: Light mode colors (primary, secondary, surface, background, error)
  - `material_dark.tres`: Dark mode colors (adjusted luminance for accessibility)
  - Font: Roboto (Google Fonts, included in repo under permissive license)
  - Spacing: 4dp, 8dp, 16dp, 24dp, 32dp grid system
  - Elevation: 0dp, 1dp, 2dp, 4dp, 8dp, 16dp, 24dp shadow styles

- **Color Palette** (Material Design 3):
  - Primary: #6750A4 (purple), Secondary: #625B71 (gray-purple)
  - Surface: #FFFBFE (light), #1C1B1F (dark)
  - Background: #FFFBFE (light), #1C1B1F (dark)
  - Error: #B3261E (red), Success: #4CAF50 (green)

---

### 6. Testing Framework - Godot Unit Testing (GUT)

**Question**: Which testing framework should be used for test-driven development?

**Decision**: Use GUT (Godot Unit Test) framework for all unit, integration, and contract tests

**Rationale**:
- GUT is the de facto standard testing framework for Godot projects
- Mature, actively maintained, extensive documentation
- Supports unit tests, integration tests, parameterized tests, mocking
- Integrates with Godot Editor and CLI for CI/CD automation
- Familiar syntax for developers experienced with xUnit-style frameworks

**Alternatives Considered**:
- **WAT (Godot testing framework)**: Rejected because less mature than GUT, smaller community, fewer features
- **Custom testing framework**: Rejected as reinventing the wheel, would delay development
- **Manual testing only**: Rejected because violates Test-First Development constitutional principle

**Implementation Notes**:
- **Installation**: GUT addon in `addons/gut/` directory, registered in project.godot
- **Test Structure**:
  - `tests/unit/`: Unit tests for individual classes (e.g., `test_database_manager.gd`)
  - `tests/integration/`: Integration tests for package interactions (e.g., `test_clusters_crud.gd`)
  - `tests/contract/`: API contract tests verifying request/response schemas (e.g., `test_api_contracts.gd`)

- **Test Execution**:
  - Editor: GUT panel in bottom panel, run selected tests or all tests
  - CLI: `godot --path . -s addons/gut/gut_cmdln.gd -gtest=tests/` for CI/CD
  - CI/CD: GitHub Actions workflow runs tests on push/PR

- **Naming Conventions**:
  - Test files: `test_<class_name>.gd` (e.g., `test_cluster.gd`)
  - Test methods: `test_<scenario>_<expected_result>()` (e.g., `test_create_cluster_with_valid_data_returns_success()`)

- **Test Lifecycle**:
  - `before_all()`: Setup once before all tests in file
  - `before_each()`: Setup before each test
  - `after_each()`: Cleanup after each test
  - `after_all()`: Cleanup once after all tests

---

### 7. Package Dependency Management with Godot Addon System

**Question**: How should package dependencies be declared and managed without PNPM/npm?

**Decision**: Use Godot's addon system with `plugin.cfg` [dependencies] section and autoload ordering

**Rationale**:
- Godot 4.x supports addon dependencies natively in `plugin.cfg`
- `[dependencies]` section lists required addons by name
- Godot Editor validates dependencies on addon enable
- Autoload system (project.godot) controls initialization order for global services
- No external package manager needed, maintains simplicity

**Alternatives Considered**:
- **Manual dependency documentation**: Rejected because error-prone, no enforcement, hard to track
- **External package manager (custom tool)**: Rejected as over-engineered, adds complexity, violates Godot-Native Architecture
- **Git submodules for packages**: Rejected because complicates repository structure, harder to manage than single monorepo

**Implementation Notes**:
- **plugin.cfg format**:
  ```ini
  [plugin]
  name="clusters-frt"
  description="Clusters feature frontend"
  author="Universo Platformo Team"
  version="0.1.0"
  script="plugin.gd"
  
  [dependencies]
  universo-utils="^0.1.0"
  universo-types="^0.1.0"
  universo-api-client="^0.1.0"
  ```

- **Semantic Versioning**:
  - Version format: MAJOR.MINOR.PATCH
  - `^0.1.0`: Compatible with 0.1.x (minor updates allowed)
  - `~0.1.0`: Compatible with 0.1.0 (patch updates only)
  - `0.1.0`: Exact version match

- **Autoload Order** (project.godot):
  ```ini
  [autoload]
  Config="*res://scripts/config.gd"
  Logger="*res://scripts/logger.gd"
  DatabaseManager="*res://scripts/database_manager.gd"
  NetworkManager="*res://scripts/network_manager.gd"
  AuthManager="*res://scripts/auth_manager.gd"
  ```
  Order matters: Config first (loads .env, config.json), then Logger, then service managers

- **Dependency Resolution**:
  - Godot Editor checks dependencies when enabling addon
  - Missing dependencies show error in console, addon enable fails
  - Circular dependencies detected and reported (must be avoided)

---

### 8. Database Migration System

**Question**: How should database schema migrations be versioned and executed?

**Decision**: Implement migration runner with versioned SQL files and tracking table

**Rationale**:
- Schema changes must be version-controlled and repeatable
- Migration files provide clear history of database evolution
- Tracking table (`schema_migrations`) prevents re-running migrations
- SQL files are database-agnostic (works with PostgreSQL, future databases)
- Simple, proven pattern from Rails, Django, Laravel migrations

**Alternatives Considered**:
- **Manual schema updates**: Rejected because error-prone, not repeatable, no rollback capability
- **ORM-based migrations**: Rejected because no mature GDScript ORM exists
- **Supabase dashboard only**: Rejected because doesn't version control schema changes, hard to replicate environments

**Implementation Notes**:
- **Migration File Format**:
  - Location: `migrations/`
  - Naming: `###_description.sql` (e.g., `001_initial_schema.sql`, `002_add_clusters_table.sql`)
  - Structure:
    ```sql
    -- Migration: 001_initial_schema
    -- Description: Create initial database schema
    
    -- Up Migration
    CREATE TABLE IF NOT EXISTS schema_migrations (
      version INTEGER PRIMARY KEY,
      applied_at TIMESTAMP DEFAULT NOW()
    );
    
    -- Down Migration (optional, for rollback)
    -- DROP TABLE IF EXISTS schema_migrations;
    ```

- **MigrationRunner class** (scripts/migration_runner.gd):
  - `run_migrations()`: Executes pending migrations in order
  - `get_applied_migrations()`: Queries `schema_migrations` table
  - `get_pending_migrations()`: Finds unapplied migration files
  - `execute_migration(file_path: String)`: Runs single migration, records in tracking table

- **Execution Flow**:
  1. On application startup (after DatabaseManager init)
  2. MigrationRunner checks `schema_migrations` table (creates if missing)
  3. Lists migration files in `migrations/` directory
  4. Compares applied vs available migrations
  5. Executes pending migrations in numerical order
  6. Records each successful migration in tracking table
  7. Logs results (migrations applied, skipped, errors)

- **Error Handling**:
  - Migration failure logs error, stops execution, prevents application start
  - Manual intervention required to fix migration or database state
  - No automatic rollback (must be done manually to prevent data loss)

---

### 9. Rate Limiting Strategy

**Question**: How should API rate limiting be implemented to prevent abuse?

**Decision**: Token bucket algorithm with in-memory tracking per IP and authenticated user

**Rationale**:
- Token bucket allows burst traffic while enforcing long-term limits
- In-memory tracking is fast (no database lookups per request)
- Separate limits for IP (unauthenticated) and user (authenticated) provide flexibility
- Simple to implement in GDScript with Dictionary tracking

**Alternatives Considered**:
- **Leaky bucket algorithm**: Rejected because less flexible for burst traffic, token bucket more common
- **Database-backed tracking**: Rejected because adds latency to every request, database becomes bottleneck
- **Third-party rate limiting service**: Rejected because adds external dependency, increases deployment complexity
- **No rate limiting**: Rejected because violates Security-First Design principle, exposes to abuse

**Implementation Notes**:
- **Token Bucket Algorithm**:
  - Each client has bucket with capacity (e.g., 100 tokens)
  - Tokens refill at fixed rate (e.g., 1 token per 0.6 seconds = 100/minute)
  - Each request consumes 1 token
  - Request allowed if tokens available, rejected if bucket empty

- **Rate Limits**:
  - Unauthenticated (by IP): 100 requests/minute, burst 20
  - Authenticated (by user_id): 1000 requests/minute, burst 100
  - WebSocket connections: 10 connections per IP, unlimited per authenticated user

- **Implementation** (in NetworkManager):
  ```gdscript
  var rate_limiters = {}  # Dictionary[String, RateLimiter]
  
  class RateLimiter:
      var capacity: int
      var tokens: float
      var refill_rate: float  # tokens per second
      var last_refill: float  # timestamp
  
  func check_rate_limit(client_id: String, limit_config: Dictionary) -> bool:
      if not rate_limiters.has(client_id):
          rate_limiters[client_id] = create_limiter(limit_config)
      
      var limiter = rate_limiters[client_id]
      refill_tokens(limiter)
      
      if limiter.tokens >= 1.0:
          limiter.tokens -= 1.0
          return true
      else:
          return false  # Rate limit exceeded
  ```

- **HTTP Response** (when rate limited):
  - Status: 429 Too Many Requests
  - Headers: `Retry-After: 60` (seconds until tokens available)
  - Body: `{"error": "ERROR_RATE_LIMIT_EXCEEDED", "retry_after": 60}`

---

### 10. Conflict Resolution for Real-Time Sync

**Question**: How should conflicts be resolved when multiple clients update the same entity simultaneously?

**Decision**: Last Write Wins (LWW) with timestamp comparison; manual resolution UI for unresolvable conflicts

**Rationale**:
- LWW is simple, deterministic, and understood by developers
- Timestamp comparison provides clear conflict resolution rule
- Manual resolution UI handles edge cases where automatic resolution unacceptable
- Suitable for typical use cases where conflicts are rare

**Alternatives Considered**:
- **Operational Transformation (OT)**: Rejected because complex to implement, overkill for entity-level updates (more suitable for collaborative text editing)
- **Conflict-free Replicated Data Types (CRDTs)**: Rejected because complex, limited GDScript libraries, not needed for this use case
- **First Write Wins**: Rejected because less intuitive than LWW, users expect latest changes to persist
- **Manual resolution only**: Rejected because creates bad UX for common cases with clear resolution

**Implementation Notes**:
- **Optimistic UI Updates**:
  1. User edits entity in UI
  2. UI immediately reflects change (optimistic)
  3. Entity marked as "pending" (gray indicator)
  4. WebSocket sends update to server
  5. Server processes update, broadcasts to clients
  6. UI receives confirmation, marks entity as "confirmed" (indicator removed)

- **Conflict Detection**:
  - Each entity has `updated_at` timestamp
  - Client sends update with client timestamp
  - Server compares client timestamp vs server's latest timestamp
  - If server timestamp newer: conflict detected

- **Conflict Resolution - LWW**:
  - Server: `if client_timestamp > server_timestamp: apply_update() else: reject_update()`
  - Rejected update sends conflict message to client: `{"type": "conflict", "entity": "cluster", "id": "uuid", "server_data": {...}, "client_data": {...}}`
  - Client UI: Show conflict dialog with server vs client data, user chooses which to keep or manually merges

- **Conflict Resolution UI**:
  - Dialog with side-by-side comparison (server version | client version)
  - Highlighting of differing fields
  - Options: "Keep Server Version", "Keep My Version", "Merge Manually"
  - Merge Manually: Editable fields pre-filled with client data, can copy from server data
  - After resolution, send new update with current timestamp

---

## Technology Stack Summary

### Core Technologies (Finalized)
- **Godot Engine**: 4.3+ minimum, latest stable 4.x recommended
- **Language**: GDScript (100% of codebase)
- **Database**: Supabase (PostgreSQL-based) via REST API
- **Testing**: GUT (Godot Unit Test) framework
- **Package Management**: Godot native addon system (plugin.cfg)

### Backend Infrastructure
- **HTTP Server**: Godot native `HTTPServer` class
- **WebSocket**: Godot native `WebSocketServer` and `WebSocketPeer`
- **Authentication**: JWT tokens with strategy pattern (HS256 algorithm)
- **Authorization**: Role-Based Access Control (RBAC)
- **Rate Limiting**: Token bucket algorithm, in-memory tracking

### Frontend Infrastructure
- **UI Framework**: Godot Control nodes with custom themes
- **Design System**: Material Design 3 principles
- **UI Components**: Custom Material components in `universo-template-godot` package
- **Themes**: Light/Dark mode with Material color palette
- **Internationalization**: Godot translation system (.en.translation, .ru.translation)

### Development Tools
- **Version Control**: Git monorepo
- **Documentation**: Markdown (English + Russian)
- **CI/CD**: GitHub Actions (planned)
- **Validation**: Custom `validate.sh` script for documentation/structure checks

## Implementation Priority

### Phase 1: Foundation (Weeks 1-2)
1. Repository structure setup (packages/, scripts/, scenes/, themes/, translations/, migrations/)
2. Core documentation (README, CONTRIBUTING, ARCHITECTURE - bilingual)
3. Autoload scripts (Config, Logger, DatabaseManager, NetworkManager, AuthManager)
4. Shared utility packages (universo-utils, universo-types, universo-i18n, universo-api-client)
5. Database migration system implementation
6. .env.example and config.json templates

### Phase 2: Infrastructure (Weeks 3-4)
7. HTTP server implementation with routing
8. WebSocket server implementation with message protocol
9. JWT authentication strategy implementation
10. RBAC authorization system
11. Rate limiting implementation
12. Material Design theme resources (light/dark)
13. UI component library (universo-template-godot)

### Phase 3: First Feature - Clusters (Weeks 5-6)
14. Database schema for Clusters/Domains/Resources
15. clusters-srv package (API, services, models, repositories)
16. clusters-frt package (UI scenes, controllers, state management)
17. Real-time sync implementation for Clusters
18. Comprehensive test suite (unit, integration, contract)
19. Bilingual package documentation

### Phase 4: Validation & Documentation (Week 7)
20. Validation script enhancements
21. Quickstart guide (English + Russian)
22. API documentation generation
23. Security audit and threat model documentation
24. Performance testing and optimization
25. Final documentation review and synchronization check

## Next Steps

1. ✅ Research completed - all technical unknowns resolved
2. → **Proceed to Phase 1: Design & Contracts** - Create `data-model.md`, `contracts/`, and `quickstart.md`
3. → **Run agent context update** - Execute `.specify/scripts/bash/update-agent-context.sh copilot` to add technology decisions to agent context
4. → **Re-evaluate Constitution Check** - Verify all principles still satisfied with detailed design
5. → **Phase 2: Task Breakdown** - Create `tasks.md` with detailed implementation checklist (NOT part of `/speckit.plan` command)

---

**Research Status**: ✅ COMPLETE  
**Gate Status**: ✅ PASS - Ready to proceed to Phase 1  
**Date Completed**: 2025-11-17
