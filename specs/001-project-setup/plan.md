# Implementation Plan: Universo Platformo Godot - Project Setup & Foundation

**Branch**: `001-project-setup` | **Date**: 2025-11-17 | **Spec**: [spec.md](.specify/features/001-project-setup/spec.md)
**Input**: Feature specification from `.specify/features/001-project-setup/spec.md`

**Note**: This is the implementation plan for establishing the foundational structure and core infrastructure of Universo Platformo Godot.

## Summary

Initialize Universo Platformo Godot as a full-stack platform using Godot Engine 4.3+ and GDScript. The project adapts concepts from Universo Platformo React (monorepo with packages, frontend/backend separation, bilingual documentation) to Godot's native paradigms (addon system, scene tree, signals). Primary deliverables include: repository structure with package system, Supabase database integration with abstraction layer, JWT-based authentication with strategy pattern, WebSocket real-time synchronization, and a complete Clusters feature as a template for future development.

## Technical Context

**Language/Version**: GDScript (Godot Engine 4.3+ minimum, latest stable 4.x recommended)  
**Primary Dependencies**: 
- Godot Engine 4.3+ (native HTTPServer, WebSocketServer/Peer classes)
- Supabase (REST API via HTTPRequest for database and auth)
- Third-party addons: HTTP server addon if native insufficient, potential PostgreSQL driver addon

**Storage**: Supabase (PostgreSQL-based) as primary; abstraction layer for future MongoDB/PostgreSQL support  
**Testing**: GUT (Godot Unit Testing framework) for unit/integration tests  
**Target Platform**: 
- Desktop: Linux, Windows, macOS (Godot Editor + client/server modes)
- Export targets: Web (HTML5), Mobile (Android/iOS), Native desktop builds

**Project Type**: Full-stack monorepo (Godot project with package-based addons, frontend/backend separation)  
**Performance Goals**: 
- UI: 60 FPS on integrated graphics (Intel i3/Ryzen 3, 8GB RAM)
- API: <500ms response time at 100 concurrent users
- Database: <3s query completion under normal load
- Server: 100-500 concurrent users per instance (2-core, 4GB RAM)

**Constraints**: 
- Editor load time: <10 seconds on mid-range hardware
- API latency: <100ms at 50 users, <500ms at 100 users
- Real-time sync: <2s update propagation via WebSocket
- Headless mode: Reduced memory footprint (no rendering/audio/physics)

**Scale/Scope**: 
- Initial: 100 concurrent users, 10K records per entity type
- Target: 500 concurrent users, 1M+ records per entity type
- Features: 10-15 major feature packages (Clusters, Metaverses, Spaces, etc.)
- Code: Estimated 50K-100K lines of GDScript across all packages

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

### ✅ I. Godot-Native Architecture
**Status**: PASS  
**Compliance**: Project uses Godot Engine 4.3+, GDScript for all code, native scene tree and signal system. No conflicting frameworks.

### ✅ II. Package-Based Modularity
**Status**: PASS  
**Compliance**: Monorepo structure with `packages/` directory, {feature}-frt/srv naming, base/ subdirectories, Godot addon system (plugin.cfg/plugin.gd), no PNPM/npm.

### ✅ III. Bilingual Documentation
**Status**: PASS  
**Compliance**: All docs in English + Russian with exact parity, line count matching (±2 tolerance), GitHub Issues/PRs use bilingual format with spoilers.

### ✅ IV. Test-First Development
**Status**: PASS  
**Compliance**: TDD with GUT framework, tests written before implementation, Red-Green-Refactor cycle, integration tests for database/API/packages.

### ✅ V. Database Abstraction
**Status**: PASS  
**Compliance**: DatabaseManager abstraction layer, Supabase primary, designed for PostgreSQL/MongoDB future support, no direct DB code outside abstraction.

### ✅ VI. Progressive Feature Development
**Status**: PASS  
**Compliance**: Follows priority order: (1) Repo setup → (2) Base infrastructure → (3) Clusters feature → (4) Replicate to Metaverses → (5) Extended features (Spaces/Canvases).

### ✅ VII. GDScript Best Practices
**Status**: PASS  
**Compliance**: Type hints, static typing, naming conventions (PascalCase/snake_case), signals for communication, Resource system, composition over inheritance, single responsibility.

### ✅ VIII. Security-First Design
**Status**: PASS  
**Compliance**: Auth/authz checks before state changes, secure credential storage (.env, memory-only tokens), input validation at API boundaries, security headers, CORS configuration, rate limiting, threat modeling documented.

**Overall Gate Status**: ✅ PASS - All constitutional principles satisfied. Proceed to Phase 0 research.

## Project Structure

### Documentation (this feature)

```text
specs/001-project-setup/
├── plan.md              # This file (implementation plan)
├── research.md          # Phase 0 output (technology decisions, patterns)
├── data-model.md        # Phase 1 output (entities, relationships, schemas)
├── quickstart.md        # Phase 1 output (getting started guide)
└── contracts/           # Phase 1 output (API contracts, OpenAPI specs)
    ├── database.sql     # Database schema definitions
    ├── api-routes.yaml  # REST API endpoint specifications
    └── websocket.json   # WebSocket message format specifications
```

### Source Code (repository root)

```text
universo-platformo-godot/
├── .specify/                    # Specification system
│   ├── features/001-project-setup/  # Feature specs (tracked separately)
│   ├── memory/constitution.md   # Project constitution
│   ├── scripts/                 # Planning automation scripts
│   └── templates/               # Spec templates
│
├── packages/                    # Feature packages (Godot addons)
│   ├── universo-utils/          # Shared utility functions
│   │   ├── base/
│   │   │   ├── plugin.cfg
│   │   │   ├── plugin.gd
│   │   │   └── scripts/         # validation, serialization, math, etc.
│   │   └── README.md / README-RU.md
│   │
│   ├── universo-types/          # Shared type definitions
│   │   ├── base/
│   │   │   └── scripts/         # Entity classes, schemas
│   │   └── README.md / README-RU.md
│   │
│   ├── universo-i18n/           # Internationalization
│   │   ├── base/
│   │   │   ├── scripts/         # Translation manager
│   │   │   └── translations/    # .en.translation, .ru.translation
│   │   └── README.md / README-RU.md
│   │
│   ├── universo-api-client/     # HTTP client for API communication
│   │   ├── base/
│   │   │   └── scripts/         # APIClient class, interceptors
│   │   └── README.md / README-RU.md
│   │
│   ├── universo-template-godot/ # Reusable UI components
│   │   ├── base/
│   │   │   ├── scenes/          # Material Design components
│   │   │   ├── scripts/         # Component logic
│   │   │   └── themes/          # Material theme resources
│   │   └── README.md / README-RU.md
│   │
│   ├── clusters-frt/            # Clusters feature frontend
│   │   ├── base/
│   │   │   ├── plugin.cfg
│   │   │   ├── plugin.gd
│   │   │   ├── scenes/          # List, Detail, Filter scenes
│   │   │   └── scripts/         # UI controllers, state management
│   │   └── README.md / README-RU.md
│   │
│   ├── clusters-srv/            # Clusters feature backend
│   │   ├── base/
│   │   │   ├── plugin.cfg
│   │   │   ├── plugin.gd
│   │   │   ├── api/             # REST endpoints
│   │   │   ├── services/        # Business logic
│   │   │   ├── models/          # Entity models
│   │   │   └── repositories/    # Data access layer
│   │   └── README.md / README-RU.md
│   │
│   └── [future packages: metaverses-frt/srv, spaces-frt/srv, etc.]
│
├── scripts/                     # Global autoload scripts
│   ├── config.gd                # Configuration manager (autoload)
│   ├── logger.gd                # Logging system (autoload)
│   ├── database_manager.gd      # Database abstraction (autoload)
│   ├── network_manager.gd       # HTTP/WebSocket manager (autoload)
│   ├── auth_manager.gd          # Authentication manager (autoload)
│   └── migration_runner.gd      # Database migration system
│
├── scenes/                      # Root application scenes
│   ├── main.tscn                # Main entry point (client mode)
│   ├── server.tscn              # Server entry point (headless mode)
│   └── dashboard.tscn           # Main dashboard UI
│
├── themes/                      # Global theme resources
│   ├── material_light.tres      # Material Design light theme
│   └── material_dark.tres       # Material Design dark theme
│
├── translations/                # Global translation files
│   ├── en.translation           # English translations
│   └── ru.translation           # Russian translations
│
├── migrations/                  # Database migration SQL files
│   ├── 001_initial_schema.sql
│   ├── 002_auth_tables.sql
│   └── [versioned migration files]
│
├── tests/                       # Test suite (GUT framework)
│   ├── unit/                    # Unit tests for individual classes
│   ├── integration/             # Integration tests for packages
│   ├── contract/                # API contract tests
│   └── test_runner.gd           # GUT test runner configuration
│
├── .github/                     # GitHub configuration
│   ├── instructions/            # Development guidelines
│   │   ├── github-issues.md
│   │   ├── github-labels.md
│   │   ├── github-pr.md
│   │   └── i18n-docs.md
│   └── workflows/               # CI/CD workflows
│
├── project.godot                # Godot project configuration
├── config.json                  # Application configuration
├── .env.example                 # Environment variables template
├── .gitignore                   # Git ignore rules
├── validate.sh                  # Validation script
├── README.md / README-RU.md     # Project documentation
├── CONTRIBUTING.md / CONTRIBUTING-RU.md
├── ARCHITECTURE.md / ARCHITECTURE-RU.md
└── FEATURE_PARITY.md / FEATURE_PARITY-RU.md
```

**Structure Decision**: 
- **Monorepo with Package-Based Modularity**: All features organized as Godot addons in `packages/` directory
- **Frontend/Backend Separation**: Each feature split into `-frt` (frontend scenes/UI) and `-srv` (backend API/logic) packages
- **Shared Utilities**: Core packages (universo-utils, universo-types, universo-i18n, etc.) provide common functionality
- **Godot-Native Architecture**: Leverages Godot's addon system, autoload scripts for global services, scene tree for UI
- **Testing Integration**: Separate `tests/` directory using GUT framework for comprehensive test coverage
- **Bilingual Support**: All documentation duplicated in English and Russian at repository root and package level

## Complexity Tracking

> **No constitutional violations - this section left empty per template guidance**

*All constitutional principles are satisfied without requiring justification for complexity or deviations.*
