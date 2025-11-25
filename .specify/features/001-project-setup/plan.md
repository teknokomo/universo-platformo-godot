# Implementation Plan: Project Setup & Foundation

**Branch**: `001-project-setup` | **Date**: 2025-11-17 | **Spec**: [specs/001-project-setup/](.)
**Input**: Initial project setup and modular architecture establishment

## Summary

Establish the foundation for Universo Platformo Godot with a modular, package-based architecture following Godot Engine's native addon system. This includes setting up core infrastructure, base documentation, and the first feature package (Clusters) as a template for future development. The implementation strictly follows the constitutional requirement that ALL functionality must be organized in self-contained packages within the `packages/` directory.

## Technical Context

**Language/Version**: Godot Engine 4.3+ (minimum), GDScript  
**Primary Dependencies**: 
- REST API Server addon (godot-rest-api-server)
- Supabase addon (supabase-community/godot-engine.supabase)
- JWT library (godot-engine.jwt)
- GUT testing framework (bitwes/Gut)

**Storage**: Supabase (PostgreSQL) via REST API with abstraction layer for future database support  
**Testing**: GUT (Godot Unit Test) with CLI and editor support for TDD workflow  
**Target Platform**: Desktop (Windows/Linux/Mac) + Server (headless Godot)  
**Project Type**: Full-stack Godot monorepo with package-based modular architecture  
**Performance Goals**: 100-500 concurrent users per server instance, <200ms p95 API latency  
**Constraints**: <100MB memory for headless server, Godot 4.3+ compatibility  
**Scale/Scope**: Initial implementation with 3-5 packages (clusters-frt, clusters-srv, universo-types), extensible to 20+ packages

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

### Core Principles Compliance

✅ **I. Godot-Native Architecture**: All components use Godot's native capabilities and GDScript  
✅ **II. Package-Based Modularity (NON-NEGOTIABLE)**: ALL functionality in `packages/` directory  
✅ **III. Bilingual Documentation**: English and Russian with exact structural parity  
✅ **IV. Test-First Development**: TDD with GUT framework  
✅ **V. Database Abstraction**: Supabase with abstraction layer for future expansion  
✅ **VI. Progressive Feature Development**: Clusters feature first, then replication pattern  
✅ **VII. GDScript Best Practices**: Type hints, signals, composition over inheritance  
✅ **VIII. Security-First Design**: JWT authentication, input validation, RBAC  

### Mandatory Package-Based Modularity Check

> **⚠️ CRITICAL GATE**: All functionality must be in `packages/` directory.

- [x] ALL feature functionality is planned for implementation in `packages/` directory
- [x] Frontend and backend components are separated into `-frt` and `-srv` packages
- [x] Each package has a `base/` subdirectory for core implementation
- [x] Shared code is planned in dedicated packages (universo-types, universo-utils)
- [x] NO feature logic is planned for root `scripts/` or `scenes/` directories (only autoloads)
- [x] Package structure follows Godot addon system with `plugin.cfg` and `plugin.gd`

**All checkboxes are checked - plan complies with constitutional requirements.**

## Project Structure

### Documentation (this feature)

```text
specs/001-project-setup/
├── plan.md              # This file (implementation plan)
├── research.md          # Phase 0 output (COMPLETE)
├── data-model.md        # Phase 1 output (COMPLETE)
├── quickstart.md        # Phase 1 output (COMPLETE)
└── contracts/           # Phase 1 output (API contracts)
    ├── auth-api.yaml
    ├── clusters-api.yaml
    └── domains-api.yaml
```

### Source Code (repository root)

```text
# Godot monorepo with mandatory package-based structure
packages/
├── auth-frt/                  # Authentication frontend package
│   └── base/
│       ├── scenes/            # UI scenes (login, register, password reset)
│       ├── scripts/           # Client-side auth logic
│       ├── plugin.cfg         # Plugin metadata
│       ├── plugin.gd          # Plugin entry point
│       ├── README.md          # English documentation
│       └── README-RU.md       # Russian documentation
│
├── auth-srv/                  # Authentication backend package
│   └── base/
│       ├── scripts/           # Auth service logic
│       ├── api/               # Auth API endpoints
│       ├── plugin.cfg         # Plugin metadata
│       ├── plugin.gd          # Plugin entry point
│       ├── README.md          # English documentation
│       └── README-RU.md       # Russian documentation
│
├── clusters-frt/              # Clusters frontend package
│   └── base/
│       ├── scenes/            # UI scenes for clusters
│       ├── scripts/           # Client-side logic
│       │   ├── cluster_list.gd
│       │   ├── cluster_detail.gd
│       │   └── cluster_create.gd
│       ├── resources/         # UI themes and resources
│       ├── plugin.cfg         # Plugin metadata
│       ├── plugin.gd          # Plugin entry point
│       ├── README.md          # English documentation
│       └── README-RU.md       # Russian documentation
│
├── clusters-srv/              # Clusters backend package
│   └── base/
│       ├── scripts/           # Server-side logic
│       │   ├── cluster_service.gd
│       │   ├── domain_service.gd
│       │   └── resource_service.gd
│       ├── api/               # REST API endpoints
│       │   ├── clusters_endpoint.gd
│       │   ├── domains_endpoint.gd
│       │   └── resources_endpoint.gd
│       ├── models/            # Data models
│       │   ├── cluster.gd
│       │   ├── domain.gd
│       │   └── resource.gd
│       ├── plugin.cfg         # Plugin metadata
│       ├── plugin.gd          # Plugin entry point
│       ├── README.md          # English documentation
│       └── README-RU.md       # Russian documentation
│
├── universo-types/            # Shared types package
│   └── base/
│       ├── scripts/           # Common data models
│       │   ├── user.gd
│       │   ├── session.gd
│       │   ├── role.gd
│       │   └── permission.gd
│       ├── plugin.cfg         # Plugin metadata
│       ├── plugin.gd          # Plugin entry point
│       ├── README.md          # English documentation
│       └── README-RU.md       # Russian documentation
│
├── universo-utils/            # Shared utilities package
│   └── base/
│       ├── scripts/           # Utility functions
│       │   ├── validator.gd
│       │   ├── logger.gd
│       │   └── crypto.gd
│       ├── plugin.cfg         # Plugin metadata
│       ├── plugin.gd          # Plugin entry point
│       ├── README.md          # English documentation
│       └── README-RU.md       # Russian documentation
│
├── universo-api-client/       # Shared API client package
│   └── base/
│       ├── scripts/           # HTTP client logic
│       │   └── api_client.gd
│       ├── plugin.cfg         # Plugin metadata
│       ├── plugin.gd          # Plugin entry point
│       ├── README.md          # English documentation
│       └── README-RU.md       # Russian documentation
│
├── universo-template-godot/   # UI component library
│   └── base/
│       ├── components/        # Reusable UI components
│       │   ├── material_button.tscn
│       │   ├── material_card.tscn
│       │   ├── material_dialog.tscn
│       │   ├── material_input.tscn
│       │   ├── material_list.tscn
│       │   └── data_grid.tscn
│       ├── plugin.cfg
│       ├── plugin.gd
│       ├── README.md
│       └── README-RU.md
│
├── universo-i18n/             # Internationalization package
│   └── base/
│       ├── scripts/
│       │   └── i18n_service.gd
│       ├── plugin.cfg
│       ├── plugin.gd
│       ├── README.md
│       └── README-RU.md
│
├── universo-rest-docs/        # API documentation package
│   └── base/
│       ├── scripts/
│       │   └── rest_docs_generator.gd
│       ├── api/
│       │   └── rest_docs_endpoint.gd
│       ├── plugin.cfg
│       ├── plugin.gd
│       ├── README.md
│       └── README-RU.md
│
└── package-template/          # Template for new packages

# Repository root (ONLY infrastructure files, NO feature logic)
scenes/
└── main.tscn                  # Main entry scene ONLY

scripts/
└── autoload/                  # ONLY global singletons
    ├── config.gd              # Configuration manager
    ├── database_manager.gd    # Database abstraction
    ├── network_manager.gd     # Network/multiplayer manager
    └── auth_manager.gd        # Authentication manager

tests/
├── unit/                      # Unit tests for packages
│   ├── test_cluster_service.gd
│   ├── test_domain_service.gd
│   └── test_auth_manager.gd
├── integration/               # Integration tests
│   ├── test_clusters_api.gd
│   └── test_database.gd
└── contract/                  # API contract tests
    └── test_clusters_contract.gd

.github/
├── instructions/              # GitHub workflow instructions
└── workflows/                 # CI/CD workflows

.specify/
├── memory/                    # Project memory (constitution)
├── templates/                 # Planning templates
└── scripts/                   # Planning scripts

project.godot                  # Godot project configuration
config.json                    # Application configuration
.env.example                   # Environment variables template
```

**Structure Decision**: We use Option 4 (Godot monorepo with package-based structure) as this is mandatory per the constitution. All features are implemented as Godot addon packages in `packages/`, with clear separation between frontend (`-frt`) and backend (`-srv`) components. Shared code goes in dedicated packages (`universo-types`, `universo-utils`, `universo-api-client`, `universo-template-godot`, `universo-i18n`, `universo-rest-docs`). The repository root contains ONLY infrastructure files: main entry scene, autoload singletons, tests, and configuration.

## Complexity Tracking

> **Fill ONLY if Constitution Check has violations that must be justified**

No constitutional violations. All requirements are met:
- Package-based modularity strictly enforced
- Godot-native architecture throughout
- Bilingual documentation planned
- Test-first development approach
- Database abstraction layer included
- Security-first design with JWT and RBAC

## Implementation Phases

### Phase 0: Research (COMPLETE ✅)
- All technical clarifications resolved
- Best practices documented for Godot full-stack development
- See `research.md` for complete findings

### Phase 1: Design & Contracts (COMPLETE ✅)
- Data models defined for infrastructure and Clusters feature
- Entity relationships established
- Database schema created
- See `data-model.md` for complete design

### Phase 2: Initial Implementation (CURRENT)
- Set up package structure in `packages/`
- Implement base packages (universo-types, universo-utils, universo-api-client)
- Create autoload singletons (Config, DatabaseManager, NetworkManager, AuthManager)
- Implement first feature: Clusters (clusters-frt, clusters-srv)
- Implement authentication UI: (auth-frt, auth-srv)
- Write comprehensive tests
- Create bilingual documentation

### Phase 3: Shared Packages
- Implement UI component library (universo-template-godot)
- Implement internationalization package (universo-i18n)
- Implement API documentation package (universo-rest-docs)

### Phase 4: Testing & Validation
- Unit tests for all packages
- Integration tests for API and database
- Contract tests for API compliance
- Manual testing of UI and workflows

### Phase 5: Documentation & CI/CD
- Complete README files in English and Russian
- API documentation
- Developer guides
- Setup GitHub Actions for automated testing

## Reference Implementation

The package organization and shared entity patterns are inspired by [Universo Platformo React](https://github.com/teknokomo/universo-platformo-react), adapted for Godot's native addon system. Key differences:
- Godot addon system replaces PNPM workspaces
- `plugin.cfg` and `plugin.gd` replace `package.json`
- GDScript replaces React/Express stack
- Same modular philosophy and future repository extraction strategy

## Next Steps

1. Implement base packages structure
2. Create autoload singletons
3. Implement Clusters feature packages
4. Write tests for all components
5. Create bilingual documentation
6. Setup CI/CD pipeline
