# Feature Specification: Universo Platformo Godot - Project Setup & Foundation

**Feature Branch**: `copilot/setup-universo-platformo-godot-again`  
**Created**: 2025-11-16  
**Updated**: 2025-11-16 (Enhanced with comprehensive requirements)  
**Status**: Enhanced Draft  
**Input**: Initialize Universo Platformo Godot implementation from scratch, following patterns from Universo Platformo React while adapting for Godot Engine and GDScript

**Reference Implementation**: [Universo Platformo React](https://github.com/teknokomo/universo-platformo-react) - conceptual reference, not for direct copying

## Clarifications

### Session 2025-11-16

- Q: which databases to prioritize for future support? → A: PostgreSQL and MongoDB (following web standards)
- Q: which authentication methods to support - basic auth, OAuth, JWT? → A: JWT tokens with Passport.js-inspired strategy pattern
- Q: how should mode switching be implemented? → A: Command-line arguments with --server flag for headless mode
- Q: what variations in entity count are expected? → A: 3-level hierarchy standard (like Clusters), but support 2-5 levels for flexibility
- Q: real-time sync strategy? → A: WebSocket-based signals with optimistic UI updates and conflict resolution

### Session 2025-11-16 (Enhancement Phase)

- Q: How to replace PNPM for Godot? → A: Use Godot's native addon system; no separate package manager needed. Packages are Godot addons managed through project settings
- Q: Material UI equivalent for Godot? → A: Use Godot's built-in Control nodes with custom theme resources following Material Design principles
- Q: Passport.js equivalent scope? → A: Implement authentication strategy pattern in GDScript supporting JWT (initial), with extensibility for OAuth2 and custom providers
- Q: Full-stack GDScript scope? → A: Backend services handle HTTP/WebSocket servers (using GDScript HTTP server or third-party addons), API logic, database access; target: 100-500 concurrent users per server instance

## User Scenarios & Testing

### User Story 1 - Repository Structure Setup (Priority: P1)

As a developer, I need the repository to have proper structure matching the Universo Platformo pattern so I can start implementing features in a consistent way.

**Why this priority**: Foundation for all future development work

**Independent Test**: Can clone repository, open in Godot Editor, and see organized package structure with clear frontend/backend separation

**Acceptance Scenarios**:

1. **Given** a fresh clone, **When** opening in Godot, **Then** project loads without errors and shows organized package structure
2. **Given** the repository, **When** checking packages/, **Then** find frontend (-frt) and backend (-srv) packages with base/ subdirectories

---

### User Story 2 - Bilingual Documentation (Priority: P1)

As a contributor (English or Russian speaking), I need comprehensive documentation in both languages so I can understand and contribute to the project.

**Why this priority**: Essential for team collaboration and onboarding

**Independent Test**: Can read README, CONTRIBUTING, and ARCHITECTURE docs in both English and Russian with identical content structure

**Acceptance Scenarios**:

1. **Given** repository root, **When** opening README.md and README-RU.md, **Then** both files have identical structure and line counts (±2 lines tolerance)
2. **Given** any documentation file, **When** comparing English and Russian versions, **Then** all sections match in order and content

---

### User Story 3 - Package System Foundation (Priority: P2)

As a developer, I need a working package/addon system so I can develop modular features that follow the Universo Platformo architecture.

**Why this priority**: Enables modular development approach

**Independent Test**: Can create a new package following the template and enable it in Godot

**Acceptance Scenarios**:

1. **Given** packages directory, **When** creating new feature package, **Then** can create {feature}-frt/base/ and {feature}-srv/base/ with plugin.cfg
2. **Given** a package with plugin.cfg, **When** opening project settings, **Then** package appears in available plugins list

---

### User Story 4 - Database Integration Layer (Priority: P2)

As a developer, I need database abstraction so I can store and retrieve data using Supabase with extensibility for other databases.

**Why this priority**: Required for any data persistence features

**Independent Test**: Can configure Supabase credentials and perform basic CRUD operations

**Acceptance Scenarios**:

1. **Given** .env file with Supabase credentials, **When** application starts, **Then** DatabaseManager successfully connects
2. **Given** DatabaseManager, **When** calling query methods, **Then** operations complete with proper error handling

---

### User Story 5 - Core Features Implementation (Priority: P3)

As a developer, I need the first feature (Clusters) fully implemented so I can use it as a template for other features.

**Why this priority**: Provides concrete example for future development

**Independent Test**: Can create, read, update, and delete clusters through both UI and server

**Acceptance Scenarios**:

1. **Given** running application, **When** accessing Clusters UI, **Then** can perform all CRUD operations
2. **Given** Clusters feature, **When** examining code structure, **Then** find clear separation between frontend scenes/scripts and backend API/logic

---

### Edge Cases

- What happens when Godot version is incompatible with project requirements?
- How does system handle missing or invalid Supabase credentials?
- What happens when a package plugin.cfg is malformed?
- How does documentation update process ensure both language versions stay synchronized?
- What happens when network connection fails during database operations?

## Requirements

### Functional Requirements

#### Repository Structure

- **FR-001**: Repository MUST use monorepo structure with packages/ directory for all feature modules
- **FR-002**: Each feature MUST be split into {feature}-frt (frontend) and {feature}-srv (backend) packages
- **FR-003**: Each package MUST contain base/ subdirectory for primary implementation
- **FR-004**: Repository MUST have scenes/, scripts/, assets/, themes/, translations/ directories
- **FR-005**: Repository MUST NOT include docs/ directory (separate repository)
- **FR-006**: Repository MUST NOT pre-create AI agent rules directories (user creates as needed)

#### Package Organization

- **FR-007**: Each package MUST have plugin.cfg configuration file
- **FR-008**: Each package MUST have plugin.gd entry point script
- **FR-009**: Frontend packages MUST contain scenes/ and scripts/ subdirectories
- **FR-010**: Backend packages MUST contain scripts/ and api/ subdirectories
- **FR-011**: Each package MUST have bilingual README documentation

#### Documentation Standards

- **FR-012**: All documentation MUST be created in English first as primary standard
- **FR-013**: Russian documentation MUST be exact translation with identical structure
- **FR-014**: English and Russian versions MUST have same number of lines (±2 tolerance)
- **FR-015**: Documentation MUST include README, CONTRIBUTING, and ARCHITECTURE files
- **FR-016**: GitHub Issues MUST use bilingual format with `<details><summary>In Russian</summary>` structure

#### Technology Stack

- **FR-017**: Project MUST use Godot Engine 4.3+ (minimum version 4.3, recommend latest stable 4.x)
- **FR-017a**: Project MUST document minimum Godot version in README and validate on startup
- **FR-018**: All code MUST be written in GDScript for both frontend and backend
- **FR-019**: Project MUST support Supabase as primary database
- **FR-020**: Database layer MUST be extensible to support additional databases in future (priority: PostgreSQL and MongoDB after Supabase)
- **FR-021**: Authentication system MUST be implemented in GDScript using JWT tokens with Passport.js-inspired strategy pattern for extensibility
- **FR-021a**: HTTP server MUST be implemented using GDScript HTTPServer (Godot 4.3+ native class) or suitable third-party addon if native implementation insufficient
- **FR-021b**: WebSocket communication MUST use Godot's native WebSocketServer/WebSocketPeer classes
- **FR-021c**: UI MUST use Godot's built-in Control nodes with custom theme resources following Material Design principles (no external UI library required)

#### Core Infrastructure

- **FR-022**: Project MUST have autoload scripts for global services (Config, DatabaseManager, NetworkManager)
- **FR-023**: Project MUST have .env.example file with required environment variables
- **FR-024**: Project MUST have config.json for application configuration
- **FR-025**: Project MUST support both client and headless server modes via command-line arguments (--server flag for headless)

#### Initial Features

- **FR-026**: Clusters feature MUST implement three-entity hierarchy: Clusters / Domains / Resources
- **FR-027**: Future features MUST follow same pattern (e.g., Metaverses / Sections / Entities), supporting 2-5 level hierarchies based on feature needs
- **FR-028**: Each feature MUST support full CRUD operations
- **FR-029**: Features MUST sync between client and server using WebSocket-based signals with optimistic UI updates and conflict resolution

#### Package Management & Architecture

- **FR-030**: Packages MUST use Godot's native addon system (no PNPM or npm equivalent needed)
- **FR-031**: Each package MUST be registered in project.godot as a Godot plugin
- **FR-032**: Package dependencies MUST be declared in plugin.cfg under [dependencies] section
- **FR-033**: Packages MUST follow semantic versioning (MAJOR.MINOR.PATCH) in plugin.cfg
- **FR-034**: Split features into separate -frt/-srv packages WHEN feature has both UI and server logic; combine into single package WHEN feature is UI-only or server-only
- **FR-035**: Package loading order MUST be managed through Godot's autoload system for critical services
- **FR-036**: Each package MUST be independently testable (can run tests without loading entire project)

#### Database Integration

- **FR-037**: Supabase connection MUST use REST API via HTTPRequest for initial implementation (evaluate direct PostgreSQL connection in future)
- **FR-038**: DatabaseManager MUST provide unified interface: query(sql, params), insert(table, data), update(table, id, data), delete(table, id), select(table, filters)
- **FR-039**: Database schema migrations MUST be versioned SQL files in migrations/ directory, executed in order
- **FR-040**: Migration system MUST track applied migrations in database table (schema_migrations with version, applied_at columns)
- **FR-041**: Database operations MUST support transactions via begin_transaction(), commit(), rollback() methods
- **FR-042**: Query builder MUST be provided for common operations; raw SQL MUST be supported for complex queries
- **FR-043**: Connection pooling MUST maintain 5-20 concurrent connections (configurable via config.json)

#### Authentication & Authorization

- **FR-044**: JWT tokens MUST use HS256 algorithm with 256-bit secret key (stored in .env as JWT_SECRET)
- **FR-045**: JWT payload MUST include: user_id, email, roles[], issued_at, expires_at (15-minute expiry)
- **FR-046**: Token refresh MUST be supported via refresh_token (30-day expiry) stored in separate table
- **FR-047**: Authentication flow: (1) Login with credentials → (2) Receive access_token + refresh_token → (3) Use access_token for API calls → (4) Refresh before expiry
- **FR-048**: AuthenticationManager MUST implement strategy pattern: BaseAuthStrategy class, JWTAuthStrategy, OAuth2Strategy (future), CustomStrategy (extensibility)
- **FR-049**: Session management MUST store active sessions in memory (Dictionary[user_id, SessionData]) with periodic cleanup of expired sessions
- **FR-050**: Authorization MUST use Role-Based Access Control (RBAC): Users → Roles → Permissions mapping
- **FR-051**: Permission system MUST support format: "resource:action" (e.g., "clusters:create", "users:delete", "domains:read")
- **FR-052**: Authorization checks MUST occur at API endpoint level before business logic execution

#### Configuration Management

- **FR-053**: .env.example MUST document ALL required environment variables:
  ```
  # Database
  SUPABASE_URL=https://xxx.supabase.co
  SUPABASE_ANON_KEY=eyJxxx
  SUPABASE_SERVICE_ROLE_KEY=eyJxxx
  
  # Authentication
  JWT_SECRET=your-256-bit-secret
  JWT_EXPIRY=900  # 15 minutes in seconds
  REFRESH_TOKEN_EXPIRY=2592000  # 30 days
  
  # Server
  SERVER_HOST=0.0.0.0
  SERVER_PORT=8080
  WS_PORT=8081
  
  # Application
  ENVIRONMENT=development  # development, staging, production
  LOG_LEVEL=INFO  # DEBUG, INFO, WARN, ERROR
  ```
- **FR-054**: config.json MUST have JSON schema:
  ```json
  {
    "app": {
      "name": "Universo Platformo Godot",
      "version": "0.1.0",
      "description": "Full-stack platform built with Godot Engine"
    },
    "database": {
      "connection_pool_size": 10,
      "query_timeout_seconds": 30,
      "retry_attempts": 3
    },
    "server": {
      "max_concurrent_connections": 100,
      "request_timeout_seconds": 60,
      "enable_cors": true,
      "cors_origins": ["http://localhost", "https://yourdomain.com"]
    },
    "features": {
      "enabled_packages": ["clusters", "metaverses", "auth"]
    }
  }
  ```
- **FR-055**: Config validation MUST occur on startup, failing with clear error messages if invalid
- **FR-056**: Headless server mode (--server flag) MUST:
  - Disable rendering (set DisplayServer to headless)
  - Skip loading UI scenes
  - Reduce memory footprint by disabling audio, 3D rendering, physics
  - Log to file only (no console UI)
  - Support graceful shutdown on SIGTERM/SIGINT
- **FR-057**: Startup sequence MUST follow order: (1) Load .env → (2) Parse config.json → (3) Initialize autoloads (Config, Logger, DatabaseManager, NetworkManager) → (4) Run migrations → (5) Load enabled packages → (6) Start HTTP/WebSocket servers OR launch UI

#### Real-Time Synchronization

- **FR-058**: WebSocket message format MUST be JSON:
  ```json
  {
    "type": "entity_update",
    "entity": "cluster",
    "action": "create|update|delete",
    "id": "uuid",
    "data": {...},
    "timestamp": 1699999999,
    "user_id": "uuid"
  }
  ```
- **FR-059**: Optimistic UI updates MUST:
  - Immediately reflect change in local UI
  - Mark entity as "pending" until server confirms
  - Rollback on server rejection with user notification
  - Show conflict resolution UI when server state differs
- **FR-060**: Conflict resolution strategy MUST be "Last Write Wins" with timestamp comparison; user can manually resolve if automatic resolution fails
- **FR-061**: Reconnection logic MUST use exponential backoff: 1s, 2s, 4s, 8s, 16s, max 30s between attempts
- **FR-062**: Client MUST queue outgoing messages during disconnection and send on reconnect (max 100 messages, discard oldest if exceeded)
- **FR-063**: Server MUST broadcast entity changes to all connected clients subscribed to that entity type

#### Feature Development Patterns

- **FR-064**: Clusters feature MUST serve as template for replication with these components:
  - Frontend: List scene (shows all items), Detail scene (CRUD form), Filter panel
  - Backend: API routes (GET /clusters, POST /clusters, PUT /clusters/:id, DELETE /clusters/:id)
  - Data layer: Database table, Entity model class, Repository class (data access)
  - Services: Business logic layer, Validation, Authorization checks
- **FR-065**: Entity relationships MUST support:
  - One-to-Many: Parent entity has Array of child IDs, child has parent_id field
  - Many-to-Many: Junction table with both entity IDs, helper methods for association
- **FR-066**: Entity validation MUST include:
  - Required fields check (name, created_by minimum)
  - Data type validation (string length, number ranges)
  - Business rule validation (unique names within parent, valid state transitions)
  - Validation errors MUST return HTTP 400 with structured JSON error response

#### Documentation Process

- **FR-067**: GitHub Issue bilingual format example:
  ```markdown
  # [EN] Issue Title
  
  Description in English...
  
  **Expected Behavior**: ...
  **Actual Behavior**: ...
  
  <details>
  <summary>In Russian / На русском</summary>
  
  # [RU] Заголовок задачи
  
  Описание на русском...
  
  **Ожидаемое поведение**: ...
  **Фактическое поведение**: ...
  
  </details>
  ```
- **FR-068**: Documentation synchronization MUST:
  - Update English version first
  - Create/update Russian version immediately after
  - Run validation script to verify line count matching (±2 tolerance)
  - Block PR merge if documentation versions don't match
- **FR-069**: Documentation review process MUST include bilingual reviewer who verifies:
  - Line count matches (automated)
  - Section structure matches (automated)
  - Content meaning matches (manual review)
  - Technical terms translated consistently (use translation glossary)
- **FR-070**: Technical terminology translation MUST follow glossary in docs/glossary.md (create if missing):
  - Consistent translations for key terms (e.g., "package" = "пакет", "cluster" = "кластер")
  - Keep English terms when no good Russian equivalent (e.g., "commit", "pull request")

### Key Entities

#### Package
- Represents a modular feature module (frontend or backend)
- Attributes: name, type (frt/srv), plugin configuration, scripts, scenes
- Relationships: Frontend package pairs with backend package for same feature

#### Cluster (example feature entity)
- Represents top-level organizational unit
- Attributes: id, name, description, owner, created_at
- Relationships: Contains multiple Domains

#### Domain (example feature entity)
- Represents logical grouping within Cluster
- Attributes: id, name, cluster_id, configuration
- Relationships: Belongs to Cluster, contains Resources

#### Resource (example feature entity)
- Represents individual asset or component
- Attributes: id, name, domain_id, type, data
- Relationships: Belongs to Domain

### Non-Functional Requirements

#### Performance

- **NFR-001**: Godot project MUST load in editor in under 10 seconds on mid-range development hardware (Intel i5/Ryzen 5, 16GB RAM, SSD)
- **NFR-002**: Database queries MUST complete within 3 seconds under normal load (100 concurrent users, 10K records per table)
- **NFR-003**: UI scenes MUST render at 60 FPS on target hardware (Intel i3/Ryzen 3, 8GB RAM, integrated graphics)

#### Scalability

- **NFR-004**: System MUST support at least 100 concurrent client connections on 2-core server with 4GB RAM
- **NFR-005**: Database design MUST support growing to 1M+ records per entity type (Clusters and Metaverses have highest scale requirements)

#### Maintainability

- **NFR-006**: All GDScript code MUST follow GDScript style guide
- **NFR-007**: Functions MUST have docstring comments
- **NFR-008**: Code MUST use static typing where possible
- **NFR-009**: Package structure MUST allow independent development and testing

#### Reliability

- **NFR-010**: Database operations MUST include error handling and retry logic (exponential backoff, max 3 retries)
- **NFR-011**: Server MUST log all errors to file system with daily rotation
- **NFR-012**: Client MUST handle server disconnection gracefully with local caching and reconnection attempts

#### Security

- **NFR-013**: Database credentials MUST be stored in .env file (not committed) with file permissions 600 (owner read/write only)
- **NFR-014**: API endpoints MUST validate all input data using schema validation and sanitization (strip HTML, prevent SQL injection)
- **NFR-015**: Authentication tokens MUST be securely stored in memory (never persisted to disk) and transmitted over HTTPS/WSS only
- **NFR-016**: Authorization checks MUST verify user permissions before executing any state-changing operation
- **NFR-017**: Rate limiting MUST restrict API requests to 100 requests/minute per IP address, 1000 requests/minute per authenticated user
- **NFR-018**: HTTP server MUST set security headers: X-Content-Type-Options: nosniff, X-Frame-Options: DENY, Content-Security-Policy: default-src 'self'
- **NFR-019**: CORS MUST be configurable with whitelist of allowed origins (no wildcard * in production)
- **NFR-020**: Threat model MUST document identified risks:
  - Authentication bypass attempts → Mitigated by JWT validation, rate limiting
  - SQL injection → Mitigated by parameterized queries, input sanitization
  - XSS attacks → Mitigated by content security policy, output encoding
  - DDoS attacks → Mitigated by rate limiting, connection limits
  - Credential theft → Mitigated by HTTPS/WSS only, secure token storage

#### Error Handling & Internationalization

- **NFR-021**: Error messages MUST be internationalized using Godot's translation system (tr() function)
- **NFR-022**: Error message keys MUST follow format: "ERROR_CATEGORY_SPECIFIC" (e.g., "ERROR_AUTH_INVALID_TOKEN", "ERROR_DB_CONNECTION_FAILED")
- **NFR-023**: Translation files MUST be provided for English (.en.translation) and Russian (.ru.translation)
- **NFR-024**: Graceful degradation MUST handle partial system failures:
  - Database unavailable → Show cached data, queue writes, display "offline mode" warning
  - Authentication service down → Allow read-only access for public resources
  - WebSocket disconnected → Fall back to HTTP polling for updates

#### Performance Targets & Degradation

- **NFR-025**: System MUST maintain acceptable performance (defined below) until reaching 80% of capacity limits
- **NFR-026**: Performance degradation approaching limits (80-100% capacity) MUST:
  - Log warnings for monitoring
  - Reject new connections with HTTP 503 (Service Unavailable)
  - Prioritize existing user requests over new requests
- **NFR-027**: Performance under load:
  - 50 concurrent users: <100ms API response time, 60 FPS UI
  - 100 concurrent users: <500ms API response time, 60 FPS UI
  - 150+ concurrent users: Graceful degradation with warnings

## Success Criteria

### Measurable Outcomes

- **SC-001**: Developer can clone repository and open in Godot Editor without errors within 5 minutes
- **SC-002**: All documentation files (English and Russian) have matching structure within 2-line tolerance
- **SC-003**: Validation script (validate.sh) passes all structure and documentation checks
- **SC-004**: Example feature (Clusters) demonstrates complete CRUD operations through both UI and API
- **SC-005**: New developer can create additional feature package by following existing Clusters pattern
- **SC-006**: Repository follows all guidelines from .github/instructions/ (issues, labels, PR, i18n-docs)
- **SC-007**: Project can run in both client mode (with UI) and headless server mode
- **SC-008**: Database operations complete successfully with Supabase configuration
- **SC-009**: Authentication flow completes successfully from login to authorized API request
- **SC-010**: WebSocket real-time updates reflect on all connected clients within 2 seconds
- **SC-011**: Bilingual documentation validation script passes with zero errors
- **SC-012**: Security checklist validation passes (HTTPS/WSS only, rate limiting active, CORS configured)
- **SC-013**: Package dependency graph has no circular dependencies (validated by automated script)

## Architecture & Patterns

### Monorepo Structure vs. Godot Addon System

**Resolution of PNPM/Monorepo Pattern**: Unlike Universo Platformo React which uses PNPM workspaces, Godot Engine has no equivalent package manager. Instead:

- **Godot's Approach**: Packages are native Godot plugins/addons managed through `project.godot` configuration
- **No Separate Build Step**: Godot automatically loads all enabled plugins on startup
- **Dependency Declaration**: Use `plugin.cfg` [dependencies] section to declare package dependencies
- **Loading Order**: Control via autoload system in `project.godot` for global services

**Directory Structure**:
```
universo-platformo-godot/
├── packages/
│   ├── auth-frt/base/          # Authentication frontend (UI scenes)
│   ├── auth-srv/base/          # Authentication backend (API, JWT logic)
│   ├── clusters-frt/base/      # Clusters feature frontend
│   ├── clusters-srv/base/      # Clusters feature backend
│   └── database-srv/base/      # Database abstraction layer
├── scenes/                     # Shared scenes (Main, ServerMain)
├── scripts/                    # Global autoload scripts
│   ├── config.gd              # Config autoload
│   ├── database_manager.gd    # DatabaseManager autoload
│   └── network_manager.gd     # NetworkManager autoload
├── assets/                     # Shared assets
├── themes/                     # UI themes (Material Design inspired)
├── translations/               # i18n translation files
├── migrations/                 # Database schema migrations
├── .env.example               # Environment variable template
├── config.json                # Application configuration
└── project.godot              # Godot project configuration
```

### Material UI Equivalent Pattern

**Resolution**: Godot doesn't have Material UI library. Instead, use native Godot approach:

- **Built-in Controls**: Use Godot's Control nodes (Button, LineEdit, Panel, etc.)
- **Theme Resources**: Create custom theme resources (`themes/material_theme.tres`) following Material Design principles:
  - Color palette (primary, secondary, surface, background, error colors)
  - Typography (font sizes, weights matching Material Design scale)
  - Component styles (button shapes, elevation shadows, ripple effects)
- **Style Components**: Create reusable styled scenes (MaterialButton.tscn, MaterialCard.tscn) that other UI inherits from
- **No Third-Party Library Needed**: Godot's theming system is powerful enough for Material Design implementation

### Authentication Strategy Pattern

**Passport.js Equivalent in GDScript**:

```gdscript
# Base class for authentication strategies
class_name BaseAuthStrategy
extends RefCounted

func authenticate(credentials: Dictionary) -> Dictionary:
    # Returns {success: bool, user_id: String, error: String}
    push_error("authenticate() must be implemented by subclass")
    return {success = false, error = "Not implemented"}

func validate_token(token: String) -> Dictionary:
    # Returns {valid: bool, payload: Dictionary, error: String}
    push_error("validate_token() must be implemented by subclass")
    return {valid = false, error = "Not implemented"}

# JWT Strategy implementation
class_name JWTAuthStrategy
extends BaseAuthStrategy

func authenticate(credentials: Dictionary) -> Dictionary:
    var email = credentials.get("email", "")
    var password = credentials.get("password", "")
    
    # Verify credentials with database
    var user = await DatabaseManager.verify_user(email, password)
    if not user:
        return {success = false, error = "Invalid credentials"}
    
    # Generate JWT token
    var token = generate_jwt(user.id, user.email, user.roles)
    var refresh_token = generate_refresh_token(user.id)
    
    return {
        success = true,
        user_id = user.id,
        access_token = token,
        refresh_token = refresh_token
    }

func validate_token(token: String) -> Dictionary:
    # JWT validation logic
    var payload = decode_jwt(token)
    if not payload or is_expired(payload):
        return {valid = false, error = "Invalid or expired token"}
    
    return {valid = true, payload = payload}
```

**Extensibility**: Add `OAuth2Strategy`, `APIKeyStrategy`, or custom strategies by extending `BaseAuthStrategy`.

### Full-Stack GDScript Scope

**Backend Services Scope**: GDScript backend services handle:

1. **HTTP Server**: REST API endpoints using Godot's HTTPServer class
2. **WebSocket Server**: Real-time communication using WebSocketServer
3. **Business Logic**: Service layer for features (ClusterService, UserService, etc.)
4. **Data Access**: Repository pattern for database operations
5. **Authentication**: JWT validation, session management
6. **Authorization**: Permission checking before operations

**Scale Target**: 100-500 concurrent users per server instance on 4-core 8GB server

**What GDScript Backend Does NOT Handle**:
- Advanced load balancing (use nginx/HAProxy in front)
- Distributed caching (use Redis separately if needed)
- Message queues (use RabbitMQ/Redis separately if needed)
- Full-text search (use Elasticsearch separately if needed)

**Deployment Model**: Multiple server instances behind load balancer for higher scale

## Migration & Adaptation Guidelines

### React/Express to Godot/GDScript Pattern Mapping

| React/Express Pattern | Godot/GDScript Equivalent | Notes |
|-----------------------|---------------------------|-------|
| Express routes (`app.get('/api/clusters')`) | HTTPServer request handlers (match path, call handler function) | Similar pattern, different API |
| React components (`.jsx`) | Godot scenes (`.tscn`) + scripts (`.gd`) | Scene tree replaces JSX structure |
| Redux state management | Godot signals + autoload singletons | Signals for events, autoloads for global state |
| npm packages | Godot plugins in `packages/` | No package manager, manual management |
| Passport.js strategies | BaseAuthStrategy pattern (see above) | Custom implementation |
| Material UI components | Themed Control nodes | Native approach |
| Axios HTTP client | HTTPRequest node | Native Godot class |
| Socket.io | WebSocketPeer/WebSocketServer | Native Godot classes |
| TypeScript types | GDScript type hints | Static typing available |
| Jest tests | GUT (Godot Unit Test) addon | Third-party testing framework |

### Avoiding React Implementation Flaws

**Do NOT Copy**:
- `docs/` folder structure → Will be separate repository
- AI agent configuration files → User creates as needed
- Legacy Flowise code → Not applicable to Godot
- Over-abstraction patterns → Keep it simple for Godot

**DO Adopt**:
- Package-based modularity concept
- Bilingual documentation approach
- Entity hierarchy patterns (Clusters/Domains/Resources)
- Authentication strategy pattern concept
- Configuration management approach

### Validation of "Best Godot Patterns"

**Approach**:
1. **Reference Godot Documentation**: Follow official Godot best practices guide
2. **Community Review**: Check Godot community forums, Discord for patterns
3. **Performance Testing**: Profile code with Godot's built-in profiler
4. **Code Review**: All PRs reviewed for Godot idioms (signals over callbacks, scene composition over deep inheritance)
5. **Static Analysis**: Use gdlint tool for style guide enforcement

### Keeping Parity with React Version

**Monitoring Process**:
1. **Regular Reviews**: Check Universo Platformo React repository weekly for new features
2. **Issue Tracking**: Create issues in this repository mirroring new React features
3. **Priority Assessment**: Evaluate if new feature applies to Godot version
4. **Adaptation Planning**: Create spec for Godot implementation using `/speckit.specify` workflow
5. **Documentation**: Reference original React feature issue/PR in Godot implementation issue

**Feature Parity Tracking**: Maintain `FEATURE_PARITY.md` document:
```markdown
# Feature Parity with Universo Platformo React

## Implemented
- [x] Clusters (React: PR#123, Godot: PR#5)
- [x] Authentication (React: PR#100, Godot: PR#3)

## Planned
- [ ] Metaverses (React: PR#150, Godot: Issue#10)
- [ ] Spaces/Canvases (React: in progress)

## Not Applicable
- [ ] React-specific optimizations (memo, useMemo)
- [ ] Express middleware patterns
```

## Dependencies & Assumptions

### External Dependencies

**Universo Platformo React Reference**:
- Repository: https://github.com/teknokomo/universo-platformo-react
- Reference Commit: Latest on main branch (track moving target)
- Usage: Conceptual reference only, not for direct code copying
- Review Frequency: Weekly for new features

**Godot Engine Assumptions**:
- Minimum Version: 4.3 (provides HTTPServer, mature addon system)
- Stability: Assumes stable release (not alpha/beta)
- Capabilities: Assumes full GDScript support for HTTP/WebSocket servers
- Validation: Test server capabilities in proof-of-concept before committing to architecture

**Supabase Assumptions**:
- API Stability: Assumes REST API remains backward compatible
- PostgreSQL Version: Assumes PostgreSQL 14+ features available
- Authentication: Assumes Supabase Auth API available (may switch to custom JWT later)

**Third-Party Addons** (if needed):
- GUT (Godot Unit Test): For automated testing
- gdlint: For code style enforcement
- Any addons MUST be vetted for: license compatibility, active maintenance, Godot 4.3+ support

### Project Assumptions

1. **Development Team**: Assumes developers familiar with Godot or willing to learn
2. **Scale**: Assumes 100-500 concurrent users sufficient for initial deployment
3. **Deployment**: Assumes Linux server environment for headless server mode
4. **Database**: Assumes Supabase sufficient for initial scale (can migrate to self-hosted PostgreSQL later)
5. **Translation**: Assumes bilingual team members available for documentation review
6. **Reference Implementation**: Assumes React version continues development (not abandoned)

## Appendices

### Appendix A: Environment Variable Reference

See FR-053 for complete `.env.example` contents.

### Appendix B: Configuration Schema

See FR-054 for complete `config.json` schema.

### Appendix C: WebSocket Message Format

See FR-058 for complete WebSocket message format.

### Appendix D: GitHub Issue Bilingual Template

See FR-067 for complete bilingual issue template.

### Appendix E: Glossary (Translation Reference)

Common technical terms for consistent English-Russian translation:

| English Term | Russian Translation | Notes |
|--------------|---------------------|-------|
| Package | Пакет | Software package/module |
| Cluster | Кластер | Feature entity, not server cluster |
| Domain | Домен | Logical grouping, not DNS domain |
| Resource | Ресурс | Asset or component |
| Metaverse | Метавселенная | Keep concept clear |
| Section | Секция | Part of metaverse |
| Entity | Сущность | Generic data object |
| Commit | Commit | Keep English term |
| Pull Request | Pull Request (PR) | Keep English term |
| Issue | Issue / Задача | Use both |
| Backend | Бэкенд | Transliteration acceptable |
| Frontend | Фронтенд | Transliteration acceptable |
| Addon | Аддон / Плагин | Both acceptable |
| Scene | Сцена | Godot scene |
| Node | Узел | Godot node |
| Signal | Сигнал | Godot signal |

---

**Version History**:
- v1.0 (2025-11-16): Initial specification
- v2.0 (2025-11-16): Enhanced with comprehensive requirements addressing all checklist gaps
