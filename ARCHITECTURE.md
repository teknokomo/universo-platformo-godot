# Universo Platformo Godot Architecture

## Overview

This document describes the architecture of Universo Platformo Godot, explaining design decisions, patterns, and the overall structure of the system.

## Design Principles

### 1. Modular Architecture (NON-NEGOTIABLE)

**CRITICAL**: The system MUST be organized into independent, reusable packages in the `packages/` directory. Each feature is self-contained with clear boundaries and interfaces. 

**Implementation Requirement**: ALL functionality (except general launch/build files in the repository root) MUST be implemented within `packages/`. Implementing functionality outside of `packages/` is STRICTLY PROHIBITED and violates the project's core architecture principles.

**Modular Structure Benefits**:
- Independent development and testing of features
- Clear separation of concerns
- Future extraction of packages into separate repositories
- Parallel team development on different packages
- Reusable components across the platform

### 2. Full-Stack GDScript
Both client and server components are written in GDScript, enabling:
- Consistent language and patterns across the stack
- Code sharing between client and server
- Simplified development workflow
- Native Godot integration

### 3. Package-Based Organization (MANDATORY)

Following the monorepo pattern from Universo Platformo React, adapted for Godot's native addon system:
- **ALL packages MUST be in `packages/` directory** - no exceptions
- Frontend (`-frt`) and server (`-srv`) MUST be separate packages
- Base implementation MUST be in `base/` subdirectory within each package
- Shared code MUST be in dedicated packages (e.g., `packages/universo-types`, `packages/universo-utils`)
- Each package is a self-contained Godot plugin with `plugin.cfg` and `plugin.gd`

**Package Naming Convention**:
- Frontend packages: `packages/{feature}-frt/base/`
- Backend packages: `packages/{feature}-srv/base/`
- Shared packages: `packages/{name}/base/` (for types, utilities, etc.)

**Future Migration**: Individual packages will be extracted into separate repositories as the project matures. The current monorepo structure facilitates initial development while preparing for future distributed architecture.

### 4. Extensibility First
The `base/` directory pattern allows for:
- Multiple implementations of the same feature
- Easy technology stack migration
- Plugin-based architecture
- Third-party extensions

## System Architecture

### High-Level Architecture

```
┌─────────────────────────────────────────────────────────┐
│                    Godot Client                         │
│  ┌───────────────────────────────────────────────────┐  │
│  │              UI Layer (Scenes)                     │  │
│  ├───────────────────────────────────────────────────┤  │
│  │         Package Frontend Components               │  │
│  │  (clusters-frt, metaverses-frt, spaces-frt)      │  │
│  ├───────────────────────────────────────────────────┤  │
│  │           Core Services (Autoloads)               │  │
│  │   Config, NetworkManager, DatabaseManager         │  │
│  └───────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────┘
                          │
                          │ Network (ENet/WebSocket)
                          │
┌─────────────────────────────────────────────────────────┐
│              Godot Server (Headless)                    │
│  ┌───────────────────────────────────────────────────┐  │
│  │         Package Server Components                 │  │
│  │  (clusters-srv, metaverses-srv, spaces-srv)      │  │
│  ├───────────────────────────────────────────────────┤  │
│  │           REST API Layer                          │  │
│  ├───────────────────────────────────────────────────┤  │
│  │         Business Logic Layer                      │  │
│  ├───────────────────────────────────────────────────┤  │
│  │         Database Integration                      │  │
│  └───────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────┘
                          │
                          │ Database API
                          │
┌─────────────────────────────────────────────────────────┐
│                    Supabase                             │
│              (PostgreSQL + REST API)                    │
└─────────────────────────────────────────────────────────┘
```

## Core Components

### Autoloads (Global Managers)

#### Config
- **Purpose**: Centralized configuration management
- **Location**: `scripts/autoload/config.gd`
- **Responsibilities**:
  - Load configuration from `config.json`
  - Manage environment variables from `.env`
  - Provide feature flags
  - Runtime settings management

#### DatabaseManager
- **Purpose**: Database operations abstraction
- **Location**: `scripts/autoload/database_manager.gd`
- **Responsibilities**:
  - Connect to Supabase
  - Execute CRUD operations
  - Handle database errors
  - Manage connection state
- **Future**: Support for multiple database backends

#### NetworkManager
- **Purpose**: Multiplayer and networking
- **Location**: `scripts/autoload/network_manager.gd`
- **Responsibilities**:
  - Server creation and management
  - Client connections
  - Peer-to-peer communication
  - RPC handling
  - Network state management

## Package Architecture

> **⚠️ CRITICAL REQUIREMENT**: ALL feature implementation MUST occur within packages in the `packages/` directory. The only exceptions are:
> - `project.godot` - Godot project configuration
> - `scenes/` (root) - Main application entry scenes only (NOT feature scenes)
> - `scripts/` (root) - Only autoload/singleton scripts for global services
> - Build and launch scripts in repository root
>
> Feature logic, UI, data models, and business logic MUST be in appropriate packages. Violating this requirement compromises the project's modular architecture and future maintainability.

### Package Structure

Each feature package follows this structure:

```
packages/{feature}-{type}/base/
├── scenes/              # Godot scenes (.tscn)
├── scripts/             # GDScript files (.gd)
├── resources/           # Godot resources (.tres, .res)
├── assets/              # Feature-specific assets
├── api/                 # REST API endpoints (server only)
├── plugin.cfg           # Plugin metadata
├── plugin.gd            # Plugin entry point
├── README.md            # Documentation (English)
└── README-RU.md        # Documentation (Russian)
```

### Package Types

#### Frontend Packages (`-frt`)
- **Purpose**: Client-side UI and logic
- **Contains**:
  - UI scenes and components
  - Client-side data models
  - User interaction handlers
  - Local state management
- **Example**: `packages/clusters-frt/`

#### Server Packages (`-srv`)
- **Purpose**: Server-side logic and APIs
- **Contains**:
  - Business logic
  - API endpoints
  - Data validation
  - Database operations
  - Server-side state
- **Example**: `packages/clusters-srv/`

#### Shared Packages
- **Purpose**: Common code, types, and utilities used across multiple packages
- **Contains**:
  - Shared data models and types (e.g., `packages/universo-types/`)
  - Utility functions (e.g., `packages/universo-utils/`)
  - Common resources and assets (e.g., `packages/universo-resources/`)
  - Shared validation logic
  - Common constants and enums
- **Naming Convention**: Use descriptive names without `-frt` or `-srv` suffixes
- **Example**: `packages/universo-types/base/`
- **Best Practice**: Create shared packages early when entities/utilities are needed by 2+ packages

**Reference**: See [Universo Platformo React](https://github.com/teknokomo/universo-platformo-react) for examples of shared entity patterns and package organization.

### Communication Patterns

#### Client ↔ Server Communication

1. **Real-time (Multiplayer API)**:
   ```gdscript
   # Client sends
   NetworkManager.send_to_server(data)
   
   # Server receives via RPC
   @rpc("any_peer")
   func handle_client_request(data):
       pass
   ```

2. **HTTP REST API** (Future):
   ```gdscript
   # Client makes HTTP request
   var http = HTTPRequest.new()
   http.request("https://api/clusters")
   
   # Server handles via REST endpoint
   func handle_get_clusters(request):
       return clusters_data
   ```

#### Package ↔ Package Communication

1. **Signals** (Event-driven):
   ```gdscript
   # Package A emits
   signal resource_updated(resource_id)
   
   # Package B connects
   PackageA.resource_updated.connect(_on_resource_updated)
   ```

2. **Direct Calls** (When appropriate):
   ```gdscript
   var cluster_manager = ClusterManager.new()
   var result = cluster_manager.get_cluster(id)
   ```

3. **Autoload Access** (Global state):
   ```gdscript
   var db_connected = DatabaseManager.is_connected
   NetworkManager.send_to_all(data)
   ```

## Feature Implementations

### Clusters System

**Entities**: Clusters → Domains → Resources

```
Cluster
├── Domain 1
│   ├── Resource A
│   ├── Resource B
│   └── Resource C
└── Domain 2
    ├── Resource D
    └── Resource E
```

**Packages**:
- `packages/clusters-frt/` - UI for managing clusters, domains, resources
- `packages/clusters-srv/` - Business logic and data persistence

### Metaverses System

**Entities**: Metaverses → Sections → Entities

```
Metaverse
├── Section 1
│   ├── Entity A
│   └── Entity B
└── Section 2
    └── Entity C
```

**Packages**:
- `packages/metaverses-frt/` - Virtual world UI and interactions
- `packages/metaverses-srv/` - World state management

### Spaces & Canvases

**Entities**: Spaces → Canvases → Nodes

```
Space
├── Canvas 1
│   ├── LangChain Node
│   ├── UPDL Node
│   └── Custom Node
└── Canvas 2
    └── Flow Nodes
```

**Packages**:
- `packages/spaces-frt/` - Visual programming interface
- `packages/spaces-srv/` - Node execution engine
- `packages/canvases-frt/` - Canvas rendering and editing
- `packages/canvases-srv/` - Canvas data management

### Uniks System

**Entities**: Extended hierarchy with unique resources

**Packages**:
- `packages/uniks-frt/` - Unique resource UI
- `packages/uniks-srv/` - Unique resource logic

## Data Flow

### Typical Request Flow

1. **User Interaction** → UI Scene
2. **UI Event** → Frontend Package Script
3. **Network Request** → NetworkManager
4. **Server Receives** → Server Package
5. **Business Logic** → Server Package Scripts
6. **Database Operation** → DatabaseManager → Supabase
7. **Response** → Network → Client
8. **UI Update** → Frontend Package → Scene

### State Management

#### Client State
- Local to each client
- Managed by frontend packages
- Synchronized via NetworkManager

#### Server State
- Authoritative game state
- Managed by server packages
- Persisted to database

#### Shared State
- Configuration (Config autoload)
- Network status (NetworkManager)
- Database connection (DatabaseManager)

## Networking Architecture

### Client-Server Model

```
Multiple Clients ← → Single Authoritative Server ← → Database
```

### Network Modes

1. **Server Mode** (Headless):
   - No rendering
   - Authoritative logic
   - State management
   - Database operations

2. **Client Mode**:
   - Full UI rendering
   - User input handling
   - Local state prediction
   - Server synchronization

3. **Standalone Mode**:
   - Local development
   - Single-player testing
   - No network required

## Database Architecture

### Current: Supabase

- PostgreSQL database
- REST API access
- Real-time subscriptions
- Authentication

### Database Schema Pattern

Each feature has its own tables:

```sql
-- Clusters System
clusters (id, name, description, created_at, updated_at)
domains (id, cluster_id, name, type, created_at, updated_at)
resources (id, domain_id, name, data, created_at, updated_at)

-- Metaverses System
metaverses (id, name, description, created_at, updated_at)
sections (id, metaverse_id, name, data, created_at, updated_at)
entities (id, section_id, type, data, created_at, updated_at)
```

### Future Database Support

The DatabaseManager is designed to support multiple backends:
- PostgreSQL (direct)
- MongoDB
- SQLite (local)
- Other cloud databases

## Security Considerations

### Authentication
- Planned custom authentication system
- Session management
- Token-based API access

### Authorization
- Role-based access control (RBAC)
- Resource-level permissions
- Package-level security

### Network Security
- Encrypted connections (TLS)
- Input validation
- SQL injection prevention
- XSS protection

## Performance Optimization

### Client Performance
- Scene instancing
- Object pooling
- LOD (Level of Detail)
- Lazy loading

### Server Performance
- Efficient state updates
- Database query optimization
- Connection pooling
- Caching strategies

### Network Performance
- Delta compression
- State interpolation
- Prediction and reconciliation
- Bandwidth management

## Scalability

### Horizontal Scaling
- Multiple server instances
- Load balancing
- Session persistence
- Database replication

### Vertical Scaling
- Resource optimization
- Efficient algorithms
- Memory management
- CPU utilization

## Shared Utility Packages Pattern

### universo-utils Package

**Purpose**: Centralized utility functions to avoid code duplication across feature packages.

**Location**: `scripts/utils/` (or `packages/universo-utils/base/` for package structure)

**Modules**:

1. **Validation** (`validation.gd`):
   ```gdscript
   class_name ValidationUtils
   static func is_valid_email(email: String) -> bool
   static func is_valid_uuid(uuid: String) -> bool
   static func is_valid_url(url: String) -> bool
   ```

2. **Serialization** (`serialization.gd`):
   ```gdscript
   class_name SerializationUtils
   static func to_json_safe(data: Variant) -> String
   static func from_json_safe(json_string: String) -> Variant
   static func to_base64(data: PackedByteArray) -> String
   static func from_base64(base64_string: String) -> PackedByteArray
   ```

3. **Math Utilities** (`math_utils.gd`):
   ```gdscript
   class_name MathUtils
   static func lerp_smooth(from: float, to: float, weight: float, delta: float) -> float
   static func map_range(value: float, in_min: float, in_max: float, out_min: float, out_max: float) -> float
   ```

4. **Environment Utilities** (`env.gd`):
   ```gdscript
   class_name EnvUtils
   static func get_api_base_url() -> String
   static func is_development() -> bool
   static func is_production() -> bool
   ```

### universo-types Package

**Purpose**: Shared type definitions and data schemas for consistency across packages.

**Location**: `scripts/types/` (or `packages/universo-types/base/`)

**Pattern**: Each entity type has its own class with validation methods.

```gdscript
class_name ClusterTypes
extends RefCounted

class Cluster:
    var id: String
    var name: String
    var description: String
    var owner_id: String
    var created_at: int
    var updated_at: int
    
    func to_dict() -> Dictionary: pass
    func validate() -> Dictionary: pass
    func from_dict(data: Dictionary) -> void: pass
```

**Benefits**:
- Type safety with GDScript type hints
- Consistent validation across packages
- Easy serialization/deserialization
- Central location for schema changes

### universo-api-client Package

**Purpose**: Centralized HTTP client with automatic error handling, authentication, and retry logic.

**Location**: `scripts/autoload/api_client.gd`

**Features**:
- Automatic JWT token injection
- Request/response interceptors
- Exponential backoff retry (max 3 retries)
- Standardized error handling
- Typed responses using universo-types

**Architecture**:
```gdscript
extends Node

var base_url: String
var auth_token: String
var request_interceptors: Array[Callable]
var response_interceptors: Array[Callable]

func get_request(endpoint: String, params: Dictionary) -> Dictionary
func post_request(endpoint: String, body: Dictionary) -> Dictionary
func put_request(endpoint: String, body: Dictionary) -> Dictionary
func delete_request(endpoint: String) -> Dictionary
```

### universo-i18n Package

**Purpose**: Centralized internationalization with language switching and translation management.

**Location**: `scripts/autoload/i18n_manager.gd`

**Features**:
- Language switching (English/Russian initially)
- Translation file loading (.translation format)
- Pluralization support
- Context-aware translations
- Fallback language (English)

**Integration with Godot**:
Uses Godot's native `TranslationServer` for efficiency:
```gdscript
extends Node

const SUPPORTED_LOCALES = ["en", "ru"]
var current_locale: String = "en"

func set_locale(locale: String) -> void:
    TranslationServer.set_locale(locale)
    locale_changed.emit(locale)

signal locale_changed(locale: String)
```

## Advanced Package Patterns

### Publishing System Architecture

**Purpose**: Export Godot projects to multiple platforms with technology-specific exporters.

**Structure**:
```
packages/publish-frt/base/
├── exporters/                  # Minipackages (technology-specific)
│   ├── web_html5/
│   │   ├── exporter.gd        # HTML5 export logic
│   │   ├── template.html
│   │   └── config.json
│   ├── desktop_native/
│   │   ├── exporter.gd
│   │   └── config.json
│   └── mobile_android/
│       ├── exporter.gd
│       └── config.json
├── ui/
│   ├── export_dialog.tscn     # Main export UI
│   └── progress_view.tscn     # Export progress
└── api/
    └── publication_api.gd      # API client for publish server
```

**Exporter Interface**:
All exporters implement the `BaseExporter` interface:
```gdscript
class_name BaseExporter
extends RefCounted

func validate() -> Dictionary          # Check export prerequisites
func generate() -> Dictionary          # Generate export files
func package() -> Dictionary           # Package into distributable
func deploy() -> Dictionary            # Deploy to platform (optional)
```

**Streaming Publication**:
- Real-time export progress via WebSocket
- Allows UI to show live status updates
- Supports cancellation of long-running exports

### UPDL (Universal Platform Description Language)

**Purpose**: Describe scenes in technology-agnostic JSON format for cross-platform export.

**Architecture**:
```
packages/updl/base/
├── parser/
│   └── updl_parser.gd         # Parse UPDL JSON
├── validator/
│   └── schema_validator.gd    # Validate against schema
├── transformer/
│   ├── to_godot.gd           # UPDL → Godot scene
│   └── from_godot.gd         # Godot scene → UPDL
└── serializer/
    └── updl_serializer.gd     # Serialize to JSON
```

**UPDL Schema** (JSON):
```json
{
  "version": "1.0",
  "scene": {
    "name": "MainScene",
    "entities": [
      {
        "id": "entity_001",
        "name": "Player",
        "transform": {"position": [0,0,0], "rotation": [0,0,0], "scale": [1,1,1]},
        "components": [
          {"type": "Mesh", "properties": {"mesh": "res://models/player.glb"}},
          {"type": "Script", "properties": {"script": "res://scripts/player.gd"}}
        ]
      }
    ]
  }
}
```

**Use Cases**:
- Save scenes in version control friendly format (JSON vs binary .tscn)
- Export to other platforms (Unity, Unreal, web engines)
- Generate scenes programmatically
- AI-assisted scene generation (Space Builder)

### Space Builder (AI-Assisted Creation)

**Purpose**: Generate node graphs/flows from natural language prompts using LLMs.

**Packages**:
- `space-builder-frt/`: UI for prompt input, model selection, preview
- `space-builder-srv/`: LLM integration, graph validation

**Workflow**:
1. User enters natural language prompt (e.g., "Create a 3D platformer player controller")
2. Space Builder sends prompt to LLM (OpenAI, Anthropic, or local model)
3. LLM generates UPDL or node graph JSON
4. System validates generated structure
5. User previews and can edit before accepting
6. Generated structure is saved as scene/flow

**Integration Points**:
- Uses UPDL for scene generation
- Integrates with publishing system for immediate export
- Supports template-based generation (learn from existing patterns)

### Multiplayer Server Architecture

**Purpose**: Dedicated multiplayer functionality using Godot's native networking.

**Package**: `packages/multiplayer-server-srv/base/`

**Architecture**:
```
Room-Based System:
- Players create or join rooms
- Each room has isolated state
- Server is authoritative for all game logic
```

**Key Components**:
1. **Room Manager**: Create, list, join, leave rooms
2. **State Synchronization**: Sync entity positions, rotations, properties
3. **Authentication**: Verify JWT tokens before room entry
4. **Anti-Cheat**: Server-side validation of all player inputs

**Communication**:
- ENet for reliable, ordered messages (game state)
- WebSocket for real-time updates (chat, events)
- HTTP REST API for room management (create, list)

## Package Templates and Tools

### Package Template System

**Purpose**: Standardize package creation with consistent structure.

**Location**: `packages/package-template/base/`

**Template Structure**:
```
package-template/base/
├── plugin.cfg                 # With placeholders: {PACKAGE_NAME}, {PACKAGE_TYPE}
├── plugin.gd                  # Entry point template
├── scripts/
│   └── example_script.gd
├── scenes/
│   └── example_scene.tscn
├── README.md                  # Template with sections
└── README-RU.md              # Russian template
```

**Creation Tool**:
Script `tools/create_package.gd` that:
1. Copies template directory
2. Replaces placeholders with actual package name
3. Updates plugin.cfg metadata
4. Creates both README files

**Usage**:
```bash
godot --script tools/create_package.gd --package-name metaverses --package-type frt
```

### Dependency Catalog

**Purpose**: Track third-party addon versions (similar to PNPM catalog).

**Location**: `scripts/dependency_catalog.gd`

**Pattern**:
```gdscript
class_name DependencyCatalog

const CATALOG = {
    "gut": {
        "version": "9.3.0",
        "url": "https://github.com/bitwes/Gut",
        "description": "Unit testing framework"
    },
    # ... more addons
}

static func get_addon_version(addon_name: String) -> String
static func validate_addon_version(addon_name: String, installed: String) -> bool
```

**Benefits**:
- Single source of truth for addon versions
- Easy to update dependencies across project
- Documentation of where addons come from
- Version validation on project load

## Testing and Quality Assurance

### Load Testing

**Purpose**: Simulate concurrent users to test performance and scalability.

**Configuration**: `artillery-load-test.gd` or similar

**Scenarios**:
- 10 concurrent users (baseline)
- 50 concurrent users (moderate load)
- 100 concurrent users (target capacity)
- 500 concurrent users (stress test)

**Metrics Collected**:
- Response times (p50, p95, p99)
- Throughput (requests/second)
- Error rates
- Resource usage (CPU, memory, network)

### Pre-Commit Validation

**Purpose**: Ensure code quality before committing.

**Git Hooks**: `.git/hooks/pre-commit`

**Checks**:
1. Code style (gdlint or similar)
2. Documentation sync (README.md and README-RU.md line counts match)
3. Unit tests pass (GUT framework)
4. No debug print statements
5. plugin.cfg files are valid

### Metrics Collection

**Purpose**: Monitor system performance in production.

**Location**: `metrics/` directory

**Architecture**:
- Prometheus-compatible metrics export
- Custom Godot metrics exporter
- Tracks: CPU, memory, network, database query times
- Dashboard integration (Grafana or similar)

**Key Metrics**:
- Request latency
- Database query times
- Active connections
- Error rates
- Memory usage per package

## Development Workflow

### Adding a New Feature

1. **Specification**: Create specification using `/speckit.specify`
2. **Issue**: Create GitHub issue with labels
3. **Packages**: Create `-frt` and `-srv` packages
4. **Implementation**: Develop scenes and scripts
5. **Integration**: Connect with autoloads and other packages
6. **Testing**: Manual and automated testing
7. **Documentation**: Update READMEs (English and Russian)
8. **PR**: Submit pull request for review

### Testing Strategy

1. **Unit Tests**: Individual script testing
2. **Integration Tests**: Package interaction testing
3. **System Tests**: End-to-end feature testing
4. **Network Tests**: Client-server interaction
5. **Performance Tests**: Load and stress testing

## Migration from React Version

### What We Adopt from React Implementation

**Core Architecture Patterns**:
- ✅ Monorepo structure with packages/ directory
- ✅ Package organization (-frt/-srv split)
- ✅ Base implementation pattern (base/ subdirectory)
- ✅ Supabase integration for database
- ✅ Bilingual documentation (English/Russian)
- ✅ Feature separation (frontend/backend packages)

**Shared Utility Pattern**:
- ✅ universo-utils for common functions
- ✅ universo-types for data schemas
- ✅ universo-i18n for internationalization
- ✅ universo-api-client for HTTP communication

**Advanced Features**:
- ✅ Publishing system with exporters
- ✅ UPDL (Universal Platform Description Language)
- ✅ Space Builder (AI-assisted creation)
- ✅ Multiplayer server architecture
- ✅ Analytics package for metrics
- ✅ Template packages for reusable patterns

**Development Tools**:
- ✅ Package template system
- ✅ Dependency catalog
- ✅ Load testing configuration
- ✅ Pre-commit validation hooks
- ✅ Metrics collection system

### What We Adapt (Godot-Specific Implementations)

**Package Management**:
- 🔄 PNPM workspaces → Godot addon system
- 🔄 npm packages → GDScript plugins
- 🔄 package.json → plugin.cfg
- 🔄 PNPM catalog → DependencyCatalog.gd

**Frontend Framework**:
- 🔄 React components → Godot scenes (.tscn)
- 🔄 JSX → Scene tree in Godot Editor
- 🔄 React hooks → Godot signals
- 🔄 Redux → Autoload singletons + signals
- 🔄 Material UI → Custom theme resources + Control nodes

**Backend Framework**:
- 🔄 Express.js → Godot HTTPServer (native 4.3+)
- 🔄 Express routes → HTTP request handlers
- 🔄 Express middleware → Interceptor pattern
- 🔄 Socket.io → WebSocketServer (native Godot)
- 🔄 Passport.js strategies → BaseAuthStrategy pattern

**Build & Development Tools**:
- 🔄 TypeScript → GDScript with type hints
- 🔄 Turbo → Godot auto-load system (no build needed)
- 🔄 ESLint → gdlint
- 🔄 Husky → Git hooks (directly)
- 🔄 Jest/Vitest → GUT (Godot Unit Test)

**Data & Networking**:
- 🔄 TypeORM → GDScript classes with typed dictionaries
- 🔄 Axios → HTTPRequest node
- 🔄 Zod validation → Custom validation functions
- 🔄 JSON → JSON + .tres resources

**UI Components**:
- 🔄 MUI Data Grid → Custom ItemList/Tree
- 🔄 MUI Charts → Custom Control nodes with drawing
- 🔄 CodeMirror → CodeEdit (native Godot)
- 🔄 ReactFlow → GraphEdit (native Godot)
- 🔄 react-markdown → RichTextLabel with BBCode

### What We Don't Include (Not Applicable)

**React/Node.js Specific**:
- ❌ Documentation folder `docs/` (will be separate repo)
- ❌ AI agent rules folders (user creates as needed)
- ❌ Legacy Flowise code (clean implementation)
- ❌ Non-Godot tooling (Webpack, Vite, etc.)
- ❌ React-specific optimizations (memo, useMemo)
- ❌ Express middleware ecosystem
- ❌ npm/PNPM configuration files

**Development Tools**:
- ❌ Husky (using direct Git hooks)
- ❌ TypeScript compiler
- ❌ Babel transpiler
- ❌ webpack/Vite bundler

### Key Architectural Decisions

**Why Godot Native APIs Over Third-Party**:
1. **HTTPServer**: Use Godot 4.3+ native HTTPServer instead of addon
   - Better performance
   - No external dependencies
   - Native integration with Godot networking

2. **WebSocket**: Use native WebSocketServer/WebSocketPeer
   - More reliable than third-party addons
   - Better integration with Godot's networking
   - ENet available for game-specific networking

3. **UI Framework**: Use native Control nodes + themes
   - No need for React-like framework
   - Scene system is more powerful for games
   - Theme resources provide Material Design easily

4. **Type System**: Use GDScript type hints
   - Native to language
   - Editor integration (autocomplete, validation)
   - Runtime performance benefits
   - No separate type definition files needed

**Why Different Package Structure**:
- React needs build step → packages have dist/ folders
- Godot auto-loads → no dist/ needed, direct .gd files
- React needs node_modules → Godot uses native addons
- React needs package.json → Godot uses plugin.cfg

**Why Different State Management**:
- React: Unidirectional data flow (Redux)
- Godot: Signal-based event system + autoload singletons
- Godot's approach is more suitable for game architecture
- Signals provide loose coupling between packages

### Advantages of Godot Implementation

**Performance**:
- Native code execution vs JavaScript
- Better 3D rendering performance
- Lower memory footprint for game workloads
- Efficient networking with ENet

**Export Capabilities**:
- 10+ platforms from single codebase
- Native mobile apps (not just web wrapper)
- Console support (Nintendo Switch, PlayStation, Xbox)
- Desktop executables (Windows, Linux, macOS)

**Game Development Features**:
- Built-in physics engines (2D and 3D)
- Animation system
- Particle systems
- Shader language
- Audio engine
- Asset import pipeline

**Development Experience**:
- Visual scene editor (no need for JSX)
- Built-in debugger and profiler
- Inspector for live property editing
- Integrated documentation
- No build step required

### Challenges and Solutions

**Challenge 1: No Package Manager**
- **Solution**: Custom DependencyCatalog + addon system
- **Benefit**: Simpler dependency management, no lock files

**Challenge 2: No TypeScript-like Types**
- **Solution**: GDScript type hints + universo-types classes
- **Benefit**: Runtime type checking, editor integration

**Challenge 3: Different HTTP Server**
- **Solution**: Wrap native HTTPServer with Express-like API
- **Benefit**: Familiar API for developers from web background

**Challenge 4: No Material UI Library**
- **Solution**: universo-template-godot with themed components
- **Benefit**: Lighter weight, Godot-optimized

**Challenge 5: Multiplayer Complexity**
- **Solution**: Use Godot's built-in high-level multiplayer API
- **Benefit**: Less code, better performance, battle-tested

## Future Enhancements

### Short Term
- Complete Clusters implementation
- REST API server in GDScript
- Authentication system
- Database abstraction layer

### Medium Term
- Metaverses implementation
- Spaces and Canvases
- Visual node editor
- LangChain integration

### Long Term
- Multiple database backends
- Advanced multiplayer features
- Mobile platform support
- VR/AR capabilities
- Blockchain integration

## References

- [Godot Engine Documentation](https://docs.godotengine.org/)
- [GDScript Style Guide](https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_styleguide.html)
- [Universo Platformo React](https://github.com/teknokomo/universo-platformo-react)
- [Supabase Documentation](https://supabase.com/docs)

---

This architecture is designed to be flexible and evolve as the project grows. Contributions and improvements are welcome!
