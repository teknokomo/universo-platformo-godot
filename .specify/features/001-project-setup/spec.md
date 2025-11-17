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

#### Shared Utility Packages

- **FR-071**: Project MUST have universo-utils package for shared utility functions
- **FR-072**: universo-utils MUST provide namespaced exports for: validation, serialization, math, updl, publish, env utilities
- **FR-073**: Project MUST have universo-types package for shared type definitions and data schemas
- **FR-074**: universo-types MUST define core entities (Cluster, Domain, Resource, User, Session) with validation schemas
- **FR-075**: Project MUST have universo-i18n package for centralized internationalization
- **FR-076**: universo-i18n MUST support language switching, translation loading, and pluralization
- **FR-077**: Shared packages MUST be implemented in scripts/ directory with clear module structure

#### API Client Package

- **FR-078**: Project MUST have universo-api-client package for centralized HTTP communication
- **FR-079**: API client MUST provide methods for: GET, POST, PUT, DELETE, PATCH with automatic error handling
- **FR-080**: API client MUST handle authentication token injection automatically
- **FR-081**: API client MUST support request/response interceptors for logging and error handling
- **FR-082**: API client MUST implement retry logic with exponential backoff (max 3 retries, delays: 1s, 2s, 4s)
- **FR-083**: API client MUST provide typed response parsing using universo-types schemas

#### Template and UI Library Packages

- **FR-084**: Project MUST have universo-template-godot package for reusable UI components
- **FR-085**: UI library MUST provide components: MaterialButton, MaterialCard, MaterialDialog, MaterialInput, MaterialList, DataGrid
- **FR-086**: UI components MUST follow Material Design principles with consistent theming
- **FR-087**: UI library MUST be theme-aware (dark/light mode support)
- **FR-088**: Project MUST support template packages (e.g., template-quiz, template-mmoomm) for reusable feature patterns
- **FR-089**: Template packages MUST be copyable/forkable starting points for new feature implementations

#### API Documentation Package

- **FR-090**: Project MUST have universo-rest-docs package for REST API documentation
- **FR-091**: REST docs MUST be generated automatically from route definitions
- **FR-092**: REST docs MUST include: endpoint paths, HTTP methods, request schemas, response schemas, auth requirements
- **FR-093**: REST docs MUST be accessible via /api/docs endpoint in development mode
- **FR-094**: REST docs MUST support both English and Russian descriptions

#### Analytics Package

- **FR-095**: Project SHOULD have analytics-frt package for usage analytics and metrics
- **FR-095a**: Analytics package structure MUST follow: packages/analytics-frt/base/
- **FR-096**: Analytics MUST track: page views, feature usage, error rates, performance metrics
- **FR-096a**: Analytics MUST implement EventTracker class for capturing user interactions (clicks, navigations, feature usage)
- **FR-096b**: Analytics MUST implement PerformanceMonitor class for FPS, memory usage, load times
- **FR-096c**: Analytics MUST implement ErrorReporter class for exception tracking with stack traces
- **FR-097**: Analytics MUST provide dashboard UI with charts (line, bar, pie) using visualization library
- **FR-097a**: Dashboard scenes MUST include: AnalyticsDashboard.tscn (main), UsageChart.tscn, PerformanceChart.tscn, ErrorList.tscn
- **FR-097b**: Charts MUST use Godot's native 2D drawing API or custom Control nodes for visualization
- **FR-097c**: Dashboard MUST support time range filters: Last Hour, Last Day, Last Week, Last Month, Custom Range
- **FR-098**: Analytics MUST respect user privacy settings (opt-in/opt-out)
- **FR-098a**: First run MUST show analytics consent dialog with clear explanation of data collected
- **FR-098b**: User MUST be able to disable analytics at any time through Settings menu
- **FR-098c**: When analytics disabled, NO data collection MUST occur (verified through code audit)
- **FR-099**: Analytics data MUST be stored separately from application data
- **FR-099a**: Analytics MUST use separate database table or Supabase project for data isolation
- **FR-099b**: Analytics data retention MUST be configurable (default: 90 days, max: 365 days)
- **FR-099c**: Analytics data MUST be anonymized (no personally identifiable information stored)

#### Projects vs Spaces Distinction

- **FR-099d**: Project SHOULD distinguish between Projects (high-level) and Spaces (canvas-level)
- **FR-099e**: Projects package (if implemented) MUST organize multiple Spaces into project containers
- **FR-099f**: Projects entity MUST have: id, name, description, owner_id, space_ids[], created_at, updated_at
- **FR-099g**: Each Space MUST belong to exactly one Project (project_id foreign key)
- **FR-099h**: Projects UI MUST provide: project list, project detail with embedded spaces list, project creation wizard
- **FR-099i**: Projects vs Spaces hierarchy: Projects > Spaces > Nodes/Canvases (3-level structure)
- **FR-099j**: Initial implementation MAY defer Projects package and use Spaces as top-level containers
- **FR-099k**: When Projects deferred, migration path MUST be documented for future Projects integration

#### Space Builder (AI-Assisted Creation)

- **FR-100**: Project MUST have space-builder-frt/srv packages for AI-assisted flow creation
- **FR-101**: Space Builder MUST accept natural language prompts describing desired functionality
- **FR-102**: Space Builder MUST generate node graphs (flows) from prompts using LLM integration
- **FR-103**: Space Builder MUST validate generated flows before saving
- **FR-104**: Space Builder MUST support multiple LLM providers (OpenAI, Anthropic, local models)
- **FR-105**: Space Builder UI MUST include: prompt input field, model selector, generation button, preview pane

#### Publishing System with Exporters

- **FR-106**: Project MUST have publish-frt/srv packages for exporting and sharing content
- **FR-107**: Publishing system MUST support multiple export targets: Web (HTML5), Desktop (native export), Mobile (Android/iOS via Godot export)
- **FR-108**: Publishing system MUST use technology-specific exporter pattern (minipackages within publish package)
- **FR-109**: Each exporter MUST implement: validate(), generate(), package(), deploy() methods
- **FR-110**: Publishing system MUST generate deployment-ready artifacts (ZIP, executable, app bundle)
- **FR-111**: Publishing system MUST provide UI for: export target selection, configuration, progress tracking, download/deploy buttons
- **FR-112**: Publishing system MUST support streaming publication API for real-time export status updates

#### UPDL (Universal Platform Description Language)

- **FR-113**: Project MUST implement UPDL system for describing scenes and logic in technology-agnostic format
- **FR-114**: UPDL MUST be JSON-based with schema validation
- **FR-115**: UPDL MUST describe: entities, transforms (position, rotation, scale), components (mesh, material, physics, script), relationships
- **FR-116**: UPDL processor MUST convert UPDL → Godot scene format (.tscn)
- **FR-117**: UPDL processor MUST convert Godot scene → UPDL format (bidirectional)
- **FR-118**: UPDL MUST support extensions for platform-specific features
- **FR-119**: Project MUST have updl package containing: parser, validator, transformer, serializer

#### Multiplayer Server Package

- **FR-120**: Project SHOULD have multiplayer-server-srv package for dedicated multiplayer functionality
- **FR-120a**: Multiplayer implementation MUST use Godot's native high-level multiplayer API (SceneMultiplayer)
- **FR-120b**: Multiplayer server MUST be headless Godot instance running with --server flag
- **FR-121**: Multiplayer server MUST support room-based architecture (create, join, leave rooms)
- **FR-121a**: Room system MUST use MultiplayerSpawner and MultiplayerSynchronizer for entity replication
- **FR-121b**: Each room MUST be isolated Godot scene loaded dynamically on room creation
- **FR-121c**: Room manager MUST track: room_id, player_ids[], room_state (waiting, active, ended), max_players, created_at
- **FR-122**: Multiplayer server MUST synchronize entity state between clients in same room
- **FR-122a**: State synchronization MUST use Godot's @rpc annotations for remote procedure calls
- **FR-122b**: State sync frequency MUST be configurable (default: 20 ticks per second)
- **FR-122c**: Delta compression MUST be used for bandwidth optimization (only changed properties sent)
- **FR-123**: Multiplayer server MUST handle player authentication and authorization per room
- **FR-123a**: Player join requests MUST validate JWT token before room admission
- **FR-123b**: Room permissions MUST support: owner (full control), participant (standard access), spectator (read-only)
- **FR-124**: Multiplayer server MUST implement anti-cheat measures (server authority, input validation)
- **FR-124a**: Server MUST be authoritative for all game state changes (clients send inputs, not state)
- **FR-124b**: Input validation MUST check: input type validity, rate limiting (max inputs per second), physics constraints
- **FR-124c**: Server MUST implement lag compensation for fair hit detection
- **FR-125**: Multiplayer server MUST support configurable room capacity (2-100 players per room)
- **FR-125a**: Room capacity MUST be enforced at join time (reject if full)
- **FR-125b**: Dynamic scaling MUST be possible (multiple server instances behind load balancer)

#### Package Templates

- **FR-126**: Project MUST have TEMPLATE-README.md and TEMPLATE-README-GUIDE.md in packages/ directory
- **FR-127**: Package template MUST include: standard structure, plugin.cfg, plugin.gd, README sections, example code
- **FR-128**: Package creation script MUST generate new package from template with name replacement
- **FR-129**: Template guide MUST document: when to create new package, naming conventions, integration steps

#### Testing and Quality Assurance

- **FR-130**: Project MUST have load testing configuration (e.g., artillery-load-test.gd or equivalent)
- **FR-130a**: Load testing MUST be implemented in GDScript as standalone test runner script
- **FR-130b**: Load test runner MUST support: connection simulation, request generation, response validation
- **FR-130c**: Load test configuration MUST be JSON file: tests/load/load_test_config.json
- **FR-131**: Load testing MUST simulate: 10, 50, 100, 500 concurrent users with realistic scenarios
- **FR-131a**: Test scenarios MUST include: user login, cluster creation, space editing, real-time collaboration, data retrieval
- **FR-131b**: Ramp-up strategy MUST be configurable: linear (add N users per second), exponential (double every N seconds)
- **FR-131c**: Test duration MUST be configurable (default: 5 minutes per load level)
- **FR-132**: Load testing MUST measure: response times, throughput, error rates, resource usage
- **FR-132a**: Metrics collected MUST include: min/max/avg/p95/p99 response times, requests per second, error percentage
- **FR-132b**: Resource monitoring MUST track: CPU usage %, memory usage MB, network throughput MB/s, database connections
- **FR-132c**: Test results MUST be exported to JSON and CSV formats for analysis
- **FR-132d**: Test report MUST generate HTML dashboard with charts visualizing performance over time
- **FR-133**: Project MUST have pre-commit validation hooks (validate code style, documentation sync, tests pass)
- **FR-133a**: Pre-commit hooks MUST be Git hooks in .git/hooks/ (pre-commit, pre-push)
- **FR-133b**: Code style check MUST run gdformat or equivalent GDScript formatter
- **FR-133c**: Documentation sync check MUST validate EN/RU README pairs have matching line counts (±2 tolerance)
- **FR-133d**: Test execution MUST run unit tests for changed packages only (for speed)
- **FR-134**: Project MUST have metrics collection system for monitoring: CPU, memory, network, database performance
- **FR-134a**: Metrics system MUST implement PerformanceMetrics autoload singleton
- **FR-134b**: Metrics MUST be collected every 10 seconds (configurable interval)
- **FR-134c**: Metrics storage MUST support: in-memory buffer (last 1000 data points), database persistence (hourly aggregates)
- **FR-134d**: Metrics dashboard MUST provide real-time graphs using WebSocket push updates
- **FR-135**: Metrics MUST be exportable to standard monitoring tools (Prometheus, Grafana compatible)
- **FR-135a**: Metrics exporter MUST provide /metrics HTTP endpoint in Prometheus text format
- **FR-135b**: Prometheus format MUST include: metric type (counter, gauge, histogram), metric name, labels, value, timestamp
- **FR-135c**: Grafana dashboard JSON MUST be provided in metrics/grafana/dashboard.json for quick setup

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
│   # Core Feature Packages
│   ├── auth-frt/base/          # Authentication frontend (UI scenes)
│   ├── auth-srv/base/          # Authentication backend (API, JWT logic)
│   ├── clusters-frt/base/      # Clusters feature frontend
│   ├── clusters-srv/base/      # Clusters feature backend
│   ├── metaverses-frt/base/    # Metaverses feature frontend
│   ├── metaverses-srv/base/    # Metaverses feature backend
│   ├── spaces-frt/base/        # Spaces feature frontend
│   ├── spaces-srv/base/        # Spaces feature backend
│   ├── uniks-frt/base/         # Uniks (unique resources) frontend
│   ├── uniks-srv/base/         # Uniks backend
│   ├── profile-frt/base/       # User profile management frontend
│   ├── profile-srv/base/       # User profile management backend
│   │
│   # Shared Utility Packages
│   ├── universo-utils/base/    # Shared utility functions (validation, math, env)
│   ├── universo-types/base/    # Shared type definitions and schemas
│   ├── universo-i18n/base/     # Centralized internationalization
│   ├── universo-api-client/base/  # Centralized HTTP client
│   ├── universo-template-godot/base/  # Reusable UI components (Material Design)
│   ├── universo-rest-docs/base/  # REST API documentation generator
│   │
│   # Advanced Feature Packages
│   ├── analytics-frt/base/     # Usage analytics and metrics UI
│   ├── space-builder-frt/base/ # AI-assisted flow creation UI
│   ├── space-builder-srv/base/ # AI-assisted flow creation backend
│   ├── publish-frt/base/       # Publishing system frontend
│   │   └── exporters/          # Technology-specific exporters (minipackages)
│   │       ├── web-html5/      # Web HTML5 exporter
│   │       ├── desktop-native/ # Desktop native exporter
│   │       └── mobile-android/ # Mobile Android exporter
│   ├── publish-srv/base/       # Publishing system backend
│   ├── updl/base/              # Universal Platform Description Language
│   │   ├── parser/             # UPDL parser
│   │   ├── validator/          # Schema validator
│   │   ├── transformer/        # UPDL ↔ Godot transformer
│   │   └── serializer/         # UPDL serializer
│   ├── multiplayer-server-srv/base/  # Dedicated multiplayer server
│   │
│   # Template Packages
│   ├── template-quiz/base/     # Quiz template for reusable patterns
│   ├── template-mmoomm/base/   # MMOOMM template
│   │
│   # Package Creation Templates
│   ├── TEMPLATE-README.md      # Template for package README
│   ├── TEMPLATE-README-GUIDE.md # Guide for creating packages
│   └── package-template/       # Template structure for new packages
│       └── base/
│           ├── plugin.cfg
│           ├── plugin.gd
│           ├── scripts/
│           ├── scenes/
│           ├── README.md
│           └── README-RU.md
│
├── scenes/                     # Shared scenes (Main, ServerMain)
├── scripts/                    # Global autoload scripts
│   ├── autoload/
│   │   ├── config.gd              # Config autoload
│   │   ├── database_manager.gd    # DatabaseManager autoload
│   │   ├── network_manager.gd     # NetworkManager autoload
│   │   ├── api_client.gd          # Global API client
│   │   └── i18n_manager.gd        # Internationalization manager
│   └── utils/                  # Shared utility scripts (loaded by packages)
├── assets/                     # Shared assets
├── themes/                     # UI themes (Material Design inspired)
├── translations/               # i18n translation files (.en.translation, .ru.translation)
├── migrations/                 # Database schema migrations
├── tests/                      # Test suite
│   ├── unit/                   # Unit tests
│   ├── integration/            # Integration tests
│   └── load/                   # Load testing scenarios
├── metrics/                    # Metrics and monitoring
│   └── prometheus/             # Prometheus exporters
├── .env.example               # Environment variable template
├── config.json                # Application configuration
├── artillery-load-test.gd     # Load testing configuration
└── project.godot              # Godot project configuration
```

### Package Architecture Patterns from React Version

#### Shared Utility Pattern (universo-utils)

**Purpose**: Centralize common utility functions to avoid duplication across packages.

**GDScript Implementation**:
```gdscript
# scripts/utils/validation.gd
class_name ValidationUtils
extends RefCounted

static func is_valid_email(email: String) -> bool:
    var regex = RegEx.new()
    regex.compile("^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$")
    return regex.search(email) != null

static func is_valid_uuid(uuid: String) -> bool:
    var regex = RegEx.new()
    regex.compile("^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$")
    return regex.search(uuid) != null

# scripts/utils/serialization.gd
class_name SerializationUtils
extends RefCounted

static func to_json_safe(data: Variant) -> String:
    return JSON.stringify(data, "\t")

static func from_json_safe(json_string: String) -> Variant:
    var json = JSON.new()
    var error = json.parse(json_string)
    if error == OK:
        return json.data
    return null

# scripts/utils/math_utils.gd
class_name MathUtils
extends RefCounted

static func clamp_to_range(value: float, min_val: float, max_val: float) -> float:
    return clamp(value, min_val, max_val)

static func lerp_smooth(from: float, to: float, weight: float, delta: float) -> float:
    return lerp(from, to, 1.0 - exp(-weight * delta))
```

**Usage in Packages**:
```gdscript
# In any package script
var is_valid = ValidationUtils.is_valid_email("user@example.com")
var json_str = SerializationUtils.to_json_safe(data)
```

#### Type Definitions Pattern (universo-types)

**Purpose**: Define shared data structures and schemas for type safety and validation.

**GDScript Implementation** (using class_name for types):
```gdscript
# scripts/types/cluster_types.gd
class_name ClusterTypes
extends RefCounted

class Cluster:
    var id: String
    var name: String
    var description: String
    var owner_id: String
    var created_at: int
    var updated_at: int
    
    func _init(data: Dictionary = {}):
        id = data.get("id", "")
        name = data.get("name", "")
        description = data.get("description", "")
        owner_id = data.get("owner_id", "")
        created_at = data.get("created_at", Time.get_unix_time_from_system())
        updated_at = data.get("updated_at", Time.get_unix_time_from_system())
    
    func to_dict() -> Dictionary:
        return {
            "id": id,
            "name": name,
            "description": description,
            "owner_id": owner_id,
            "created_at": created_at,
            "updated_at": updated_at
        }
    
    func validate() -> Dictionary:
        var errors = []
        if name.is_empty():
            errors.append("Name is required")
        if name.length() > 255:
            errors.append("Name must be less than 255 characters")
        if owner_id.is_empty():
            errors.append("Owner ID is required")
        return {
            "valid": errors.is_empty(),
            "errors": errors
        }
```

#### API Client Pattern (universo-api-client)

**Purpose**: Centralized HTTP client with automatic error handling, auth injection, and retry logic.

**GDScript Implementation**:
```gdscript
# scripts/autoload/api_client.gd
extends Node

const MAX_RETRIES = 3
const RETRY_DELAYS = [1.0, 2.0, 4.0]  # Exponential backoff

var base_url: String = ""
var auth_token: String = ""
var request_interceptors: Array[Callable] = []
var response_interceptors: Array[Callable] = []

func _ready():
    base_url = Config.get_value("api.base_url", "http://localhost:8080")

func set_auth_token(token: String) -> void:
    auth_token = token

func get_request(endpoint: String, params: Dictionary = {}) -> Dictionary:
    return _request("GET", endpoint, params)

func post_request(endpoint: String, body: Dictionary = {}) -> Dictionary:
    return _request("POST", endpoint, body)

func put_request(endpoint: String, body: Dictionary = {}) -> Dictionary:
    return _request("PUT", endpoint, body)

func delete_request(endpoint: String) -> Dictionary:
    return _request("DELETE", endpoint)

func _request(method: String, endpoint: String, data: Dictionary = {}, retry_count: int = 0) -> Dictionary:
    var http = HTTPRequest.new()
    add_child(http)
    
    var url = base_url + endpoint
    if method == "GET" and not data.is_empty():
        url += "?" + _dict_to_query_string(data)
    
    var headers = [
        "Content-Type: application/json",
        "Accept: application/json"
    ]
    
    if not auth_token.is_empty():
        headers.append("Authorization: Bearer " + auth_token)
    
    # Apply request interceptors
    for interceptor in request_interceptors:
        var result = interceptor.call(method, url, headers, data)
        if result.has("headers"):
            headers = result.headers
        if result.has("data"):
            data = result.data
    
    var body = ""
    if method in ["POST", "PUT", "PATCH"] and not data.is_empty():
        body = JSON.stringify(data)
    
    var error = http.request(url, headers, HTTPClient.METHOD_GET if method == "GET" else HTTPClient.METHOD_POST, body)
    
    if error != OK:
        http.queue_free()
        return {"success": false, "error": "Request failed to initiate", "code": error}
    
    var response = await http.request_completed
    http.queue_free()
    
    var result = response[0]
    var response_code = response[1]
    var response_headers = response[2]
    var response_body = response[3]
    
    var parsed_response = _parse_response(response_body)
    
    # Apply response interceptors
    for interceptor in response_interceptors:
        parsed_response = interceptor.call(response_code, parsed_response)
    
    # Retry logic for 5xx errors or network errors
    if response_code >= 500 or result != HTTPRequest.RESULT_SUCCESS:
        if retry_count < MAX_RETRIES:
            await get_tree().create_timer(RETRY_DELAYS[retry_count]).timeout
            return await _request(method, endpoint, data, retry_count + 1)
    
    return {
        "success": response_code >= 200 and response_code < 300,
        "code": response_code,
        "data": parsed_response,
        "error": parsed_response.get("error", "") if response_code >= 400 else ""
    }

func _dict_to_query_string(params: Dictionary) -> String:
    var parts = []
    for key in params:
        parts.append(str(key) + "=" + str(params[key]))
    return "&".join(parts)

func _parse_response(body: PackedByteArray) -> Variant:
    var json = JSON.new()
    var error = json.parse(body.get_string_from_utf8())
    if error == OK:
        return json.data
    return {}
```

#### Internationalization Package Pattern (universo-i18n)

**Purpose**: Centralized translation management with language switching and pluralization.

**GDScript Implementation**:
```gdscript
# scripts/autoload/i18n_manager.gd
extends Node

const SUPPORTED_LOCALES = ["en", "ru"]
var current_locale: String = "en"
var translations: Dictionary = {}

func _ready():
    _load_translations()
    current_locale = Config.get_value("ui.locale", "en")
    TranslationServer.set_locale(current_locale)

func _load_translations():
    for locale in SUPPORTED_LOCALES:
        var translation = Translation.new()
        translation.locale = locale
        TranslationServer.add_translation(translation)
        
        # Load translation files
        var path = "res://translations/%s.translation" % locale
        if ResourceLoader.exists(path):
            var loaded = ResourceLoader.load(path) as Translation
            if loaded:
                TranslationServer.add_translation(loaded)

func set_locale(locale: String) -> void:
    if locale in SUPPORTED_LOCALES:
        current_locale = locale
        TranslationServer.set_locale(locale)
        Config.set_value("ui.locale", locale)
        locale_changed.emit(locale)

func get_current_locale() -> String:
    return current_locale

func tr_with_context(key: String, context: String = "") -> String:
    return TranslationServer.translate(key, context)

signal locale_changed(locale: String)
```

#### Publishing System with Exporter Pattern

**Purpose**: Export Godot projects to multiple platforms with technology-specific exporters.

**Architecture**:
```
publish-frt/base/
├── exporters/                  # Minipackages for each export target
│   ├── web_html5/
│   │   ├── exporter.gd        # HTML5 export logic
│   │   ├── template.html      # HTML template
│   │   └── config.json        # Exporter configuration
│   ├── desktop_native/
│   │   ├── exporter.gd        # Desktop export logic
│   │   └── config.json
│   └── mobile_android/
│       ├── exporter.gd        # Android export logic
│       └── config.json
├── ui/
│   ├── export_dialog.tscn
│   └── export_dialog.gd
└── api/
    └── publication_api.gd
```

**Base Exporter Interface**:
```gdscript
# publish-frt/base/exporters/base_exporter.gd
class_name BaseExporter
extends RefCounted

func validate() -> Dictionary:
    # Override: Validate export requirements
    return {"valid": false, "errors": ["Not implemented"]}

func generate() -> Dictionary:
    # Override: Generate export files
    return {"success": false, "error": "Not implemented"}

func package() -> Dictionary:
    # Override: Package export into distributable
    return {"success": false, "path": ""}

func deploy() -> Dictionary:
    # Override: Deploy to platform (optional)
    return {"success": false, "error": "Not implemented"}
```

**Example HTML5 Exporter**:
```gdscript
# publish-frt/base/exporters/web_html5/exporter.gd
class_name HTML5Exporter
extends BaseExporter

func validate() -> Dictionary:
    # Check if HTML5 export template is installed
    var template_path = "res://.godot/export_templates/html5/"
    if not DirAccess.dir_exists_absolute(template_path):
        return {
            "valid": false,
            "errors": ["HTML5 export template not installed"]
        }
    return {"valid": true, "errors": []}

func generate() -> Dictionary:
    # Use Godot's export system
    var export_preset = _get_html5_preset()
    if not export_preset:
        return {"success": false, "error": "HTML5 export preset not configured"}
    
    var output_path = "user://exports/web/index.html"
    var error = EditorExportPlatform.export_project(export_preset, output_path, true)
    
    if error != OK:
        return {"success": false, "error": "Export failed with code: " + str(error)}
    
    return {"success": true, "path": output_path}

func package() -> Dictionary:
    # ZIP the exported files
    var export_dir = "user://exports/web/"
    var zip_path = "user://exports/web_export.zip"
    
    # Use ZIPPacker to create archive
    var zip = ZIPPacker.new()
    zip.open(zip_path)
    
    var dir = DirAccess.open(export_dir)
    for file in dir.get_files():
        zip.start_file(file)
        var file_data = FileAccess.get_file_as_bytes(export_dir + file)
        zip.write_file(file_data)
        zip.close_file()
    
    zip.close()
    
    return {"success": true, "path": zip_path}

func _get_html5_preset() -> EditorExportPreset:
    # Find or create HTML5 export preset
    # This is editor-only API, adapt for runtime if needed
    return null
```

#### UPDL (Universal Platform Description Language) Pattern

**Purpose**: Describe scenes in technology-agnostic JSON format for cross-platform export.

**UPDL Schema Example**:
```json
{
  "version": "1.0",
  "scene": {
    "name": "MainScene",
    "entities": [
      {
        "id": "entity_001",
        "name": "Player",
        "transform": {
          "position": [0, 0, 0],
          "rotation": [0, 0, 0],
          "scale": [1, 1, 1]
        },
        "components": [
          {
            "type": "Mesh",
            "properties": {
              "mesh": "res://models/player.glb",
              "material": "res://materials/player_mat.tres"
            }
          },
          {
            "type": "Script",
            "properties": {
              "script": "res://scripts/player_controller.gd"
            }
          },
          {
            "type": "PhysicsBody",
            "properties": {
              "mass": 1.0,
              "gravity_scale": 1.0
            }
          }
        ]
      }
    ],
    "relationships": [
      {
        "parent": "entity_001",
        "child": "entity_002",
        "type": "parent_child"
      }
    ]
  }
}
```

**UPDL Processor**:
```gdscript
# packages/updl/base/scripts/updl_processor.gd
class_name UPDLProcessor
extends RefCounted

func parse(updl_json: String) -> Dictionary:
    var json = JSON.new()
    var error = json.parse(updl_json)
    if error != OK:
        return {"success": false, "error": "Invalid JSON"}
    return {"success": true, "data": json.data}

func validate(updl_data: Dictionary) -> Dictionary:
    var errors = []
    if not updl_data.has("version"):
        errors.append("Missing version field")
    if not updl_data.has("scene"):
        errors.append("Missing scene field")
    # Add more validation rules
    return {"valid": errors.is_empty(), "errors": errors}

func to_godot_scene(updl_data: Dictionary) -> Node:
    # Convert UPDL to Godot scene tree
    var root = Node.new()
    root.name = updl_data.scene.get("name", "Scene")
    
    for entity_data in updl_data.scene.get("entities", []):
        var entity_node = _create_entity_from_updl(entity_data)
        root.add_child(entity_node)
    
    return root

func from_godot_scene(scene: Node) -> Dictionary:
    # Convert Godot scene to UPDL
    var updl = {
        "version": "1.0",
        "scene": {
            "name": scene.name,
            "entities": []
        }
    }
    
    for child in scene.get_children():
        var entity_data = _entity_to_updl(child)
        updl.scene.entities.append(entity_data)
    
    return updl

func _create_entity_from_updl(entity_data: Dictionary) -> Node:
    var node = Node3D.new() if entity_data.has("transform") else Node.new()
    node.name = entity_data.get("name", "Entity")
    
    # Apply transform if present
    if entity_data.has("transform") and node is Node3D:
        var t = entity_data.transform
        node.position = Vector3(t.position[0], t.position[1], t.position[2])
        node.rotation_degrees = Vector3(t.rotation[0], t.rotation[1], t.rotation[2])
        node.scale = Vector3(t.scale[0], t.scale[1], t.scale[2])
    
    # Add components
    for component in entity_data.get("components", []):
        _add_component_to_node(node, component)
    
    return node

func _entity_to_updl(node: Node) -> Dictionary:
    var entity = {
        "id": str(node.get_instance_id()),
        "name": node.name,
        "components": []
    }
    
    if node is Node3D:
        entity["transform"] = {
            "position": [node.position.x, node.position.y, node.position.z],
            "rotation": [node.rotation_degrees.x, node.rotation_degrees.y, node.rotation_degrees.z],
            "scale": [node.scale.x, node.scale.y, node.scale.z]
        }
    
    # Extract components
    # Add logic to identify and serialize components
    
    return entity

func _add_component_to_node(node: Node, component: Dictionary) -> void:
    var type = component.get("type", "")
    var properties = component.get("properties", {})
    
    match type:
        "Mesh":
            if node is Node3D:
                var mesh_instance = MeshInstance3D.new()
                if properties.has("mesh"):
                    mesh_instance.mesh = load(properties.mesh)
                node.add_child(mesh_instance)
        "Script":
            if properties.has("script"):
                var script = load(properties.script)
                node.set_script(script)
        "PhysicsBody":
            # Add physics body component
            pass
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

### Dependency Version Management Pattern

**React Version Uses**: PNPM Catalog feature for centralized dependency version management

**Godot Adaptation**: Create `dependency_catalog.gd` for tracking third-party addon versions

**Purpose**: Single source of truth for addon versions to ensure consistency across project

**Implementation**:
```gdscript
# scripts/dependency_catalog.gd
class_name DependencyCatalog
extends RefCounted

const CATALOG = {
    # Testing
    "gut": {
        "version": "9.3.0",
        "url": "https://github.com/bitwes/Gut",
        "description": "Godot Unit Testing framework"
    },
    
    # HTTP Server (if using third-party)
    "gdserv": {
        "version": "2.0.0",
        "url": "https://github.com/you-win/gdserv",
        "description": "HTTP server for Godot"
    },
    
    # UI Components
    "material_maker": {
        "version": "1.3.0",
        "url": "https://github.com/RodZill4/material-maker",
        "description": "Material creation tools"
    },
    
    # Utilities
    "json_beautifier": {
        "version": "1.0.0",
        "url": "https://github.com/Beepyy/JSON-Beautifier",
        "description": "JSON formatting utility"
    }
}

static func get_addon_info(addon_name: String) -> Dictionary:
    return CATALOG.get(addon_name, {})

static func get_addon_version(addon_name: String) -> String:
    var info = get_addon_info(addon_name)
    return info.get("version", "unknown")

static func list_addons() -> Array:
    return CATALOG.keys()

static func validate_addon_version(addon_name: String, installed_version: String) -> bool:
    var expected_version = get_addon_version(addon_name)
    return installed_version == expected_version
```

**Usage in project.godot**:
```ini
[addons]
gut = { version = "9.3.0", enabled = true }
gdserv = { version = "2.0.0", enabled = true }
```

**Documentation in addon installation guide** (`docs/addon-management.md`):
```markdown
# Addon Management

All third-party addons are cataloged in `scripts/dependency_catalog.gd`.

## Installing a New Addon

1. Find addon in catalog: `DependencyCatalog.get_addon_info("gut")`
2. Download from URL
3. Extract to `addons/{addon_name}/`
4. Enable in Project Settings → Plugins
5. Verify version matches catalog

## Updating an Addon

1. Update version in `dependency_catalog.gd`
2. Download new version
3. Replace files in `addons/{addon_name}/`
4. Test for breaking changes
5. Update documentation if API changed
```

### Package Creation from Template Pattern

**React Version Has**: TEMPLATE-README.md and TEMPLATE-README-GUIDE.md for standardized package creation

**Godot Adaptation**: Create package template directory with creation script

**Package Template Structure**:
```
packages/package-template/base/
├── plugin.cfg
├── plugin.gd
├── scripts/
│   └── example_script.gd
├── scenes/
│   └── example_scene.tscn
├── resources/
├── assets/
├── README.md
└── README-RU.md
```

**Creation Script**:
```gdscript
# tools/create_package.gd
extends ScriptExtended

func create_package(package_name: String, package_type: String) -> void:
    # package_type: "frt" or "srv"
    var template_dir = "res://packages/package-template/base/"
    var target_dir = "res://packages/%s-%s/base/" % [package_name, package_type]
    
    # Copy template directory
    var dir = DirAccess.open(template_dir)
    if dir:
        dir.make_dir_recursive(target_dir)
        _copy_dir_recursive(template_dir, target_dir)
        
        # Replace placeholders in files
        _replace_placeholders(target_dir, package_name, package_type)
        
        print("Package created: " + target_dir)
    else:
        push_error("Template directory not found")

func _copy_dir_recursive(from: String, to: String) -> void:
    var dir = DirAccess.open(from)
    if dir:
        dir.list_dir_begin()
        var file_name = dir.get_next()
        
        while file_name != "":
            var from_path = from + "/" + file_name
            var to_path = to + "/" + file_name
            
            if dir.current_is_dir():
                DirAccess.make_dir_absolute(to_path)
                _copy_dir_recursive(from_path, to_path)
            else:
                dir.copy(from_path, to_path)
            
            file_name = dir.get_next()
        
        dir.list_dir_end()

func _replace_placeholders(dir: String, package_name: String, package_type: String) -> void:
    # Replace {PACKAGE_NAME}, {PACKAGE_TYPE}, {PACKAGE_DISPLAY_NAME} in files
    var files_to_process = ["plugin.cfg", "README.md", "README-RU.md", "plugin.gd"]
    
    for file_name in files_to_process:
        var file_path = dir + "/" + file_name
        if FileAccess.file_exists(file_path):
            var file = FileAccess.open(file_path, FileAccess.READ)
            var content = file.get_as_text()
            file.close()
            
            # Replace placeholders
            content = content.replace("{PACKAGE_NAME}", package_name)
            content = content.replace("{PACKAGE_TYPE}", package_type)
            content = content.replace("{PACKAGE_DISPLAY_NAME}", _to_display_name(package_name))
            
            # Write back
            file = FileAccess.open(file_path, FileAccess.WRITE)
            file.store_string(content)
            file.close()

func _to_display_name(package_name: String) -> String:
    return package_name.capitalize()
```

**Usage**:
```bash
# From command line (if script exposed as tool)
godot --script tools/create_package.gd --package-name metaverses --package-type frt
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
