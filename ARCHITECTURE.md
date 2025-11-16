# Universo Platformo Godot Architecture

## Overview

This document describes the architecture of Universo Platformo Godot, explaining design decisions, patterns, and the overall structure of the system.

## Design Principles

### 1. Modular Architecture
The system is organized into independent, reusable packages. Each feature is self-contained with clear boundaries and interfaces.

### 2. Full-Stack GDScript
Both client and server components are written in GDScript, enabling:
- Consistent language and patterns across the stack
- Code sharing between client and server
- Simplified development workflow
- Native Godot integration

### 3. Package-Based Organization
Following the monorepo pattern from Universo Platformo React, adapted for Godot:
- Packages in `packages/` directory
- Frontend (`-frt`) and server (`-srv`) separation
- Base implementation in `base/` subdirectory

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

### What We Adopt
- ✅ Monorepo structure
- ✅ Package organization
- ✅ Base implementation pattern
- ✅ Supabase integration
- ✅ Bilingual documentation
- ✅ Feature separation (frontend/backend)

### What We Adapt
- 🔄 PNPM → Godot addons system
- 🔄 npm packages → GDScript plugins
- 🔄 React components → Godot scenes
- 🔄 Express server → GDScript HTTP server
- 🔄 Passport.js → Custom auth
- 🔄 Material UI → Godot UI themes

### What We Don't Include
- ❌ Documentation folder (`docs/`)
- ❌ AI agent rules folders
- ❌ Legacy Flowise code
- ❌ Non-Godot tooling

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
