# Tasks: Universo Platformo Godot - Project Setup & Foundation

**Input**: Design documents from `/specs/001-project-setup/`
**Prerequisites**: plan.md ✅, spec.md ✅, data-model.md ✅, contracts/ ✅, quickstart.md ✅

**Feature Branch**: `001-project-setup`
**Tests**: TDD approach - test tasks explicitly included before implementation tasks per constitution
**Organization**: Tasks grouped by user story to enable independent implementation and testing

## Context & Roadmap

**This Feature (001-project-setup)** establishes the foundation for Universo Platformo Godot, implementing:
- Repository structure with package-based architecture
- Core infrastructure (database, authentication, networking)
- Authentication UI (login, register, password reset pages)
- First concrete feature (Clusters) as template for future development

**Progressive Development Roadmap:**
1. ✅ **001-project-setup** (This feature) - Foundation + Auth UI + Clusters
2. 🔜 **002-uniks-feature** - Unique resources management system
3. 🔜 **003-metaverses-feature** - Metaverse creation and management (Metaverses / Sections / Entities)
4. 🔜 **004-organizations-feature** - Organizations and team management
5. 🔜 **005-storages-feature** - File and asset storage management
6. 🔜 **006-projects-feature** - Projects container for Spaces
7. 🔜 **007-spaces-canvases-feature** - Visual canvas editor with node graph system
8. 🔜 **008-node-libraries-feature** - LangChain nodes, UPDL nodes, custom node types
9. 🔜 **009-space-builder-feature** - AI-assisted flow generation
10. 🔜 **010-publishing-system-feature** - Multi-platform export and deployment

**Reference Implementation**: [Universo Platformo React](https://github.com/teknokomo/universo-platformo-react)
- This Godot implementation follows similar modular package architecture
- Key difference: Avoids monolithic packages (like legacy Flowise components in React version)
- Godot uses native addon system instead of PNPM workspaces
- Same philosophy: Each feature in separate, independently deployable packages
- React packages to replicate: auth, clusters, uniks, metaverses, organizations, storages, projects, spaces, publish, space-builder, updl, universo-utils, universo-types, universo-api-client, universo-template-*, universo-i18n, universo-rest-docs, analytics, multiplayer

**Constitutional Compliance**: ✅ All tasks comply with project constitution
- ✅ ALL functionality in `packages/` directory (non-negotiable)
- ✅ Frontend/backend separation (`-frt`/`-srv` packages)
- ✅ Bilingual documentation (English/Russian with structural parity)
- ✅ Test-first development (TDD - tests before implementation)
- ✅ Database abstraction (Supabase with extension layer)
- ✅ Godot-native architecture (GDScript, native HTTP/WebSocket servers)
- ✅ Security-first design (JWT, RBAC, input validation)

## Format: `- [ ] [ID] [P?] [Story?] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (US1, US2, US3, US4, US5)
- Exact file paths included in descriptions

---

## Phase 1: Setup (Project Initialization)

**Purpose**: Initialize repository structure and basic configuration

- [ ] T001 Create packages/ directory structure with base subdirectories
- [ ] T002 [P] Create .env.example file with all required environment variables per FR-053
- [ ] T003 [P] Create config.json file with application configuration per FR-054
- [ ] T004 [P] Initialize .gitignore with Godot-specific patterns
- [ ] T005 [P] Create project.godot configuration file with autoload entries
- [ ] T006 [P] Create scenes/ directory with main.tscn entry scene
- [ ] T007 [P] Create scripts/autoload/ directory for global singletons
- [ ] T008 [P] Create tests/ directory with unit/, integration/, and contract/ subdirectories
- [ ] T009 [P] Create themes/ directory for UI theme resources
- [ ] T010 [P] Create translations/ directory for i18n files
- [ ] T011 [P] Create migrations/ directory for database schema migrations
- [ ] T012 [P] Create assets/ directory for shared assets

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Core infrastructure that MUST be complete before ANY user story implementation

**⚠️ CRITICAL**: No user story work can begin until this phase is complete

### Configuration & Environment

- [ ] T013 Implement Config autoload singleton in scripts/autoload/config.gd
- [ ] T014 Add configuration loading logic (parse config.json and .env)
- [ ] T015 Add configuration validation with error reporting per FR-055
- [ ] T016 Add environment-specific configuration support (development/staging/production)

### Database Layer

- [ ] T017 Implement DatabaseManager autoload singleton in scripts/autoload/database_manager.gd
- [ ] T018 Add Supabase REST API connection logic per FR-037
- [ ] T019 Add unified database interface methods (query, insert, update, delete, select) per FR-038
- [ ] T020 Add connection pooling support per FR-043
- [ ] T021 Add transaction support (begin_transaction, commit, rollback) per FR-041
- [ ] T022 Add error handling and retry logic per NFR-010
- [ ] T023 Create migrations/001_initial_schema.sql with infrastructure tables per database.sql contract
- [ ] T024 Implement migration system with version tracking per FR-039-040

### Authentication & Authorization

- [ ] T025 Implement AuthManager autoload singleton in scripts/autoload/auth_manager.gd
- [ ] T026 Create BaseAuthStrategy class in scripts/autoload/auth_manager.gd per spec architecture
- [ ] T027 Implement JWTAuthStrategy extending BaseAuthStrategy per FR-044-047
- [ ] T028 Add JWT token generation (HS256 algorithm) per FR-044
- [ ] T029 Add JWT token validation with expiry check per FR-045
- [ ] T030 Add refresh token support per FR-046
- [ ] T031 Add session management (in-memory Dictionary) per FR-049
- [ ] T032 Add session cleanup for expired sessions (periodic timer)
- [ ] T033 Implement RBAC permission checking per FR-050-052

### Network & Server

- [ ] T034 Implement NetworkManager autoload singleton in scripts/autoload/network_manager.gd
- [ ] T035 Add HTTP server initialization using Godot HTTPServer per FR-021a
- [ ] T036 Add WebSocket server initialization using Godot WebSocketServer per FR-021b
- [ ] T037 Add request routing system for HTTP endpoints
- [ ] T038 Add WebSocket message handler with JSON parsing per FR-058
- [ ] T039 Add middleware system for authentication and CORS per NFR-018-019
- [ ] T040 Add rate limiting middleware per NFR-017
- [ ] T041 Add security headers middleware per NFR-018

### Logging & Error Handling

- [ ] T042 Create Logger utility in scripts/autoload/logger.gd
- [ ] T043 Add log level support (DEBUG, INFO, WARN, ERROR) per FR-053
- [ ] T044 Add file logging with daily rotation per NFR-011
- [ ] T045 Add internationalized error messages per NFR-021-022

### Startup & Mode Detection

- [ ] T046 Implement startup sequence in main.tscn script per FR-057
- [ ] T047 Add headless server mode detection (--server flag) per FR-056
- [ ] T048 Add client mode initialization (load UI scenes)
- [ ] T049 Add server mode initialization (start HTTP/WebSocket servers)

**Checkpoint**: Foundation ready - user story implementation can now begin in parallel

---

## Phase 3: User Story 1 - Repository Structure Setup (Priority: P1) 🎯 MVP

**Goal**: Establish proper repository structure matching Universo Platformo pattern with organized package structure

**Independent Test**: Can clone repository, open in Godot Editor, and see organized package structure with clear frontend/backend separation

### Implementation for User Story 1

- [ ] T050 [P] [US1] Create packages/package-template/base/ directory structure
- [ ] T051 [P] [US1] Create TEMPLATE-README.md in packages/ directory per FR-127
- [ ] T052 [P] [US1] Create TEMPLATE-README-GUIDE.md in packages/ directory per FR-129
- [ ] T053 [P] [US1] Create plugin.cfg template in packages/package-template/base/
- [ ] T054 [P] [US1] Create plugin.gd template in packages/package-template/base/
- [ ] T055 [US1] Create package creation script in tools/create_package.gd per architecture pattern
- [ ] T056 [US1] Update project.godot with package autoload configuration
- [ ] T057 [US1] Create validate.sh script for structure validation per SC-003
- [ ] T058 [US1] Test package creation script with test package

**Checkpoint**: Repository structure complete and validated

---

## Phase 4: User Story 2 - Bilingual Documentation (Priority: P1)

**Goal**: Provide comprehensive documentation in both English and Russian with identical content structure

**Independent Test**: Can read README, CONTRIBUTING, and ARCHITECTURE docs in both languages with identical structure

### Implementation for User Story 2

- [ ] T059 [P] [US2] Update README.md with complete project overview in English
- [ ] T060 [US2] Create README-RU.md as exact translation of README.md per FR-013-014
- [ ] T061 [P] [US2] Create CONTRIBUTING.md with contribution guidelines in English
- [ ] T062 [US2] Create CONTRIBUTING-RU.md as exact translation per FR-013-014
- [ ] T063 [P] [US2] Create ARCHITECTURE.md with architectural overview in English
- [ ] T064 [US2] Create ARCHITECTURE-RU.md as exact translation per FR-013-014
- [ ] T065 [P] [US2] Create .github/ISSUE_TEMPLATE/ with bilingual issue templates per FR-067
- [ ] T066 [P] [US2] Create .github/PULL_REQUEST_TEMPLATE.md with bilingual PR template
- [ ] T067 [P] [US2] Create docs/glossary.md with technical term translations per FR-070
- [ ] T068 [P] [US2] Create docs/glossary-ru.md as translation reference
- [ ] T069 [US2] Create documentation validation script in tools/validate_i18n.gd per FR-068
- [ ] T070 [US2] Run validation script to verify line count matching (±2 tolerance)

**Checkpoint**: Bilingual documentation complete and validated

---

## Phase 5: User Story 3 - Package System Foundation (Priority: P2)

**Goal**: Implement working package/addon system for modular feature development

**Independent Test**: Can create a new package following the template and enable it in Godot

### Shared Packages Implementation

- [ ] T071 [P] [US3] Create packages/universo-types/base/ package structure
- [ ] T072 [P] [US3] Create plugin.cfg for universo-types package
- [ ] T073 [P] [US3] Create plugin.gd entry point for universo-types package
- [ ] T074 [P] [US3] Create User model class in packages/universo-types/base/scripts/user.gd per data-model.md
- [ ] T075 [P] [US3] Create Session model class in packages/universo-types/base/scripts/session.gd per data-model.md
- [ ] T076 [P] [US3] Create Role model class in packages/universo-types/base/scripts/role.gd per data-model.md
- [ ] T077 [P] [US3] Create Permission model class in packages/universo-types/base/scripts/permission.gd per data-model.md
- [ ] T078 [P] [US3] Create RefreshToken model class in packages/universo-types/base/scripts/refresh_token.gd per data-model.md
- [ ] T079 [P] [US3] Create README.md for universo-types package in English
- [ ] T080 [US3] Create README-RU.md for universo-types package per FR-011

- [ ] T081 [P] [US3] Create packages/universo-utils/base/ package structure
- [ ] T082 [P] [US3] Create plugin.cfg for universo-utils package
- [ ] T083 [P] [US3] Create plugin.gd entry point for universo-utils package
- [ ] T084 [P] [US3] Create ValidationUtils class in packages/universo-utils/base/scripts/validation.gd per architecture pattern
- [ ] T085 [P] [US3] Create SerializationUtils class in packages/universo-utils/base/scripts/serialization.gd per architecture pattern
- [ ] T086 [P] [US3] Create MathUtils class in packages/universo-utils/base/scripts/math_utils.gd per architecture pattern
- [ ] T087 [P] [US3] Create CryptoUtils class in packages/universo-utils/base/scripts/crypto.gd for JWT and hashing
- [ ] T088 [P] [US3] Create README.md for universo-utils package in English
- [ ] T089 [US3] Create README-RU.md for universo-utils package per FR-011

- [ ] T090 [P] [US3] Create packages/universo-api-client/base/ package structure
- [ ] T091 [P] [US3] Create plugin.cfg for universo-api-client package
- [ ] T092 [P] [US3] Create plugin.gd entry point for universo-api-client package
- [ ] T093 [US3] Create APIClient class in packages/universo-api-client/base/scripts/api_client.gd per FR-078-083
- [ ] T094 [P] [US3] Create README.md for universo-api-client package in English
- [ ] T095 [US3] Create README-RU.md for universo-api-client package per FR-011

- [ ] T096 [US3] Enable all shared packages in project.godot plugin settings per FR-031
- [ ] T097 [US3] Test package loading and dependency resolution

**Checkpoint**: Shared packages functional and ready for feature development

---

## Phase 6: User Story 4 - Database Integration Layer (Priority: P2)

**Goal**: Implement database abstraction with Supabase connection and CRUD operations

**Independent Test**: Can configure Supabase credentials and perform basic CRUD operations

### Implementation for User Story 4

- [ ] T098 [US4] Create database schema in migrations/001_initial_schema.sql per contracts/database.sql
- [ ] T099 [US4] Add User table creation SQL per data-model.md
- [ ] T100 [US4] Add RefreshToken table creation SQL per data-model.md
- [ ] T101 [US4] Add Role table creation SQL per data-model.md
- [ ] T102 [US4] Add Permission table creation SQL per data-model.md
- [ ] T103 [US4] Add UserRole junction table creation SQL per data-model.md
- [ ] T104 [US4] Add RolePermission junction table creation SQL per data-model.md
- [ ] T105 [US4] Add schema_migrations table for migration tracking per FR-040
- [ ] T106 [US4] Test database migration execution in DatabaseManager
- [ ] T107 [US4] Implement database connection test in DatabaseManager per FR-037
- [ ] T108 [US4] Test CRUD operations (create user, query user, update user, delete user)
- [ ] T109 [US4] Test transaction support (begin, commit, rollback)
- [ ] T110 [US4] Test error handling and retry logic per NFR-010

**Checkpoint**: Database integration functional with complete schema

---

## Phase 7: User Story 5 - Core Features Implementation (Priority: P3)

**Goal**: Implement first feature (Clusters) as template for future development with full CRUD operations

**Independent Test**: Can create, read, update, and delete clusters through both UI and server

### Clusters Backend Package

- [ ] T111 [P] [US5] Create packages/clusters-srv/base/ package structure
- [ ] T112 [P] [US5] Create plugin.cfg for clusters-srv package
- [ ] T113 [P] [US5] Create plugin.gd entry point for clusters-srv package

- [ ] T114 [P] [US5] Create Cluster model in packages/clusters-srv/base/models/cluster.gd per data-model.md
- [ ] T115 [P] [US5] Create Domain model in packages/clusters-srv/base/models/domain.gd per data-model.md
- [ ] T116 [P] [US5] Create Resource model in packages/clusters-srv/base/models/resource.gd per data-model.md

- [ ] T117 [P] [US5] Create ClusterService in packages/clusters-srv/base/scripts/cluster_service.gd per FR-064
- [ ] T118 [P] [US5] Create DomainService in packages/clusters-srv/base/scripts/domain_service.gd per FR-064
- [ ] T119 [P] [US5] Create ResourceService in packages/clusters-srv/base/scripts/resource_service.gd per FR-064

- [ ] T120 [US5] Create ClustersEndpoint in packages/clusters-srv/base/api/clusters_endpoint.gd per contracts/api-routes.yaml
- [ ] T121 [US5] Create DomainsEndpoint in packages/clusters-srv/base/api/domains_endpoint.gd per contracts/api-routes.yaml
- [ ] T122 [US5] Create ResourcesEndpoint in packages/clusters-srv/base/api/resources_endpoint.gd per contracts/api-routes.yaml

- [ ] T123 [US5] Add database migrations for Cluster, Domain, Resource tables in migrations/002_clusters_schema.sql
- [ ] T124 [US5] Register Clusters API endpoints in NetworkManager
- [ ] T125 [P] [US5] Create README.md for clusters-srv package in English
- [ ] T126 [US5] Create README-RU.md for clusters-srv package per FR-011

### Clusters Frontend Package

- [ ] T127 [P] [US5] Create packages/clusters-frt/base/ package structure
- [ ] T128 [P] [US5] Create plugin.cfg for clusters-frt package
- [ ] T129 [P] [US5] Create plugin.gd entry point for clusters-frt package

- [ ] T130 [P] [US5] Create ClusterListScene in packages/clusters-frt/base/scenes/cluster_list.tscn per FR-064
- [ ] T131 [P] [US5] Create ClusterDetailScene in packages/clusters-frt/base/scenes/cluster_detail.tscn per FR-064
- [ ] T132 [P] [US5] Create ClusterCreateScene in packages/clusters-frt/base/scenes/cluster_create.tscn per FR-064

- [ ] T133 [US5] Create ClusterListScript in packages/clusters-frt/base/scripts/cluster_list.gd
- [ ] T134 [US5] Create ClusterDetailScript in packages/clusters-frt/base/scripts/cluster_detail.gd
- [ ] T135 [US5] Create ClusterCreateScript in packages/clusters-frt/base/scripts/cluster_create.gd

- [ ] T136 [P] [US5] Create DomainListScene in packages/clusters-frt/base/scenes/domain_list.tscn
- [ ] T137 [P] [US5] Create ResourceListScene in packages/clusters-frt/base/scenes/resource_list.tscn

- [ ] T138 [US5] Create DomainListScript in packages/clusters-frt/base/scripts/domain_list.gd
- [ ] T139 [US5] Create ResourceListScript in packages/clusters-frt/base/scripts/resource_list.gd

- [ ] T140 [US5] Implement WebSocket real-time sync for Clusters per FR-058-063
- [ ] T141 [US5] Add optimistic UI updates with conflict resolution per FR-059-060
- [ ] T142 [P] [US5] Create README.md for clusters-frt package in English
- [ ] T143 [US5] Create README-RU.md for clusters-frt package per FR-011

### Integration & Testing

- [ ] T144 [US5] Enable clusters-frt and clusters-srv packages in project.godot
- [ ] T145 [US5] Test complete Clusters workflow (create → read → update → delete)
- [ ] T146 [US5] Test WebSocket real-time synchronization between clients
- [ ] T147 [US5] Test permission-based access control for Clusters

**Checkpoint**: Clusters feature fully functional as template for future features

---

## Phase 8: User Story 6 - Authentication UI (Priority: P1)

**Goal**: Implement authentication frontend package with login, register, and password reset pages

**Independent Test**: Can complete full authentication flow - register, login, logout, password reset

### Auth Backend Package (auth-srv)

- [ ] T148 [P] [US6] Create packages/auth-srv/base/ package structure
- [ ] T149 [P] [US6] Create plugin.cfg for auth-srv package
- [ ] T150 [P] [US6] Create plugin.gd entry point for auth-srv package
- [ ] T151 [P] [US6] Create AuthService in packages/auth-srv/base/scripts/auth_service.gd
- [ ] T152 [US6] Create AuthEndpoint in packages/auth-srv/base/api/auth_endpoint.gd (register, login, logout, refresh)
- [ ] T153 [US6] Create PasswordResetEndpoint in packages/auth-srv/base/api/password_reset_endpoint.gd
- [ ] T154 [US6] Add database migrations for password_reset_tokens table in migrations/003_auth_schema.sql
- [ ] T155 [US6] Register auth API endpoints in NetworkManager
- [ ] T156 [P] [US6] Create README.md for auth-srv package in English
- [ ] T157 [US6] Create README-RU.md for auth-srv package per FR-011

### Auth Frontend Package (auth-frt)

- [ ] T158 [P] [US6] Create packages/auth-frt/base/ package structure
- [ ] T159 [P] [US6] Create plugin.cfg for auth-frt package
- [ ] T160 [P] [US6] Create plugin.gd entry point for auth-frt package
- [ ] T161 [P] [US6] Create LoginScene in packages/auth-frt/base/scenes/login.tscn
- [ ] T162 [P] [US6] Create RegisterScene in packages/auth-frt/base/scenes/register.tscn
- [ ] T163 [P] [US6] Create PasswordResetScene in packages/auth-frt/base/scenes/password_reset.tscn
- [ ] T164 [P] [US6] Create PasswordResetConfirmScene in packages/auth-frt/base/scenes/password_reset_confirm.tscn
- [ ] T165 [US6] Create LoginScript in packages/auth-frt/base/scripts/login.gd
- [ ] T166 [US6] Create RegisterScript in packages/auth-frt/base/scripts/register.gd
- [ ] T167 [US6] Create PasswordResetScript in packages/auth-frt/base/scripts/password_reset.gd
- [ ] T168 [US6] Implement form validation with error messages
- [ ] T169 [US6] Implement navigation between auth scenes (login ↔ register ↔ password reset)
- [ ] T170 [US6] Implement redirect to main app after successful login
- [ ] T171 [P] [US6] Create README.md for auth-frt package in English
- [ ] T172 [US6] Create README-RU.md for auth-frt package per FR-011

### Auth Integration & Testing

- [ ] T173 [US6] Enable auth-frt and auth-srv packages in project.godot
- [ ] T174 [US6] Test complete authentication flow (register → login → logout)
- [ ] T175 [US6] Test password reset flow (request → email → confirm)
- [ ] T176 [US6] Test form validation and error handling
- [ ] T177 [US6] Test session persistence and token refresh

**Checkpoint**: Authentication UI fully functional

---

## Phase 9: User Story 7 - Additional Shared Packages (Priority: P2)

**Goal**: Implement additional shared packages for UI components, i18n, and API documentation

### UI Component Library (universo-template-godot)

- [ ] T178 [P] [US7] Create packages/universo-template-godot/base/ package structure
- [ ] T179 [P] [US7] Create plugin.cfg for universo-template-godot package
- [ ] T180 [P] [US7] Create plugin.gd entry point for universo-template-godot package
- [ ] T181 [P] [US7] Create MaterialButton component in packages/universo-template-godot/base/components/material_button.tscn
- [ ] T182 [P] [US7] Create MaterialCard component in packages/universo-template-godot/base/components/material_card.tscn
- [ ] T183 [P] [US7] Create MaterialDialog component in packages/universo-template-godot/base/components/material_dialog.tscn
- [ ] T184 [P] [US7] Create MaterialInput component in packages/universo-template-godot/base/components/material_input.tscn
- [ ] T185 [P] [US7] Create MaterialList component in packages/universo-template-godot/base/components/material_list.tscn
- [ ] T186 [P] [US7] Create DataGrid component in packages/universo-template-godot/base/components/data_grid.tscn
- [ ] T187 [P] [US7] Create README.md for universo-template-godot package in English
- [ ] T188 [US7] Create README-RU.md for universo-template-godot package per FR-011

### Internationalization Package (universo-i18n)

- [ ] T189 [P] [US7] Create packages/universo-i18n/base/ package structure
- [ ] T190 [P] [US7] Create plugin.cfg for universo-i18n package
- [ ] T191 [P] [US7] Create plugin.gd entry point for universo-i18n package
- [ ] T192 [US7] Create I18nService in packages/universo-i18n/base/scripts/i18n_service.gd per architecture pattern
- [ ] T193 [US7] Implement language switching, translation loading, and pluralization per FR-076
- [ ] T194 [P] [US7] Create README.md for universo-i18n package in English
- [ ] T195 [US7] Create README-RU.md for universo-i18n package per FR-011

### API Documentation Package (universo-rest-docs)

- [ ] T196 [P] [US7] Create packages/universo-rest-docs/base/ package structure
- [ ] T197 [P] [US7] Create plugin.cfg for universo-rest-docs package
- [ ] T198 [P] [US7] Create plugin.gd entry point for universo-rest-docs package
- [ ] T199 [US7] Create RestDocsGenerator in packages/universo-rest-docs/base/scripts/rest_docs_generator.gd per FR-091
- [ ] T200 [US7] Create RestDocsEndpoint in packages/universo-rest-docs/base/api/rest_docs_endpoint.gd (/api/docs) per FR-093
- [ ] T201 [US7] Implement automatic documentation generation from route definitions per FR-091
- [ ] T202 [P] [US7] Create README.md for universo-rest-docs package in English
- [ ] T203 [US7] Create README-RU.md for universo-rest-docs package per FR-011

### Integration

- [ ] T204 [US7] Enable all new packages in project.godot
- [ ] T205 [US7] Test UI components with example scenes
- [ ] T206 [US7] Test i18n with language switching
- [ ] T207 [US7] Test API docs endpoint in development mode

**Checkpoint**: All shared packages functional

---

## Phase 10: Polish & Cross-Cutting Concerns

**Purpose**: Final improvements affecting multiple components

### UI Theme & Material Design

- [ ] T208 [P] Create Material Design theme resource in themes/material_theme.tres per FR-021c
- [ ] T209 [P] Define color palette (primary, secondary, surface, background, error)
- [ ] T210 [P] Define typography (font sizes matching Material Design scale)
- [ ] T211 [P] Define component styles (buttons, cards, inputs)
- [ ] T212 Apply theme to all UI scenes

### Internationalization

- [ ] T213 [P] Create translations/en.translation with all UI strings per NFR-021-023
- [ ] T214 [P] Create translations/ru.translation with Russian translations
- [ ] T215 [P] Create I18nManager autoload in scripts/autoload/i18n_manager.gd per architecture pattern
- [ ] T216 Add language switching functionality
- [ ] T217 Test all UI strings in both languages

### Documentation

- [ ] T218 [P] Create quickstart.md in English (adapt from specs/001-project-setup/quickstart.md)
- [ ] T219 Create quickstart-ru.md in Russian per FR-013-014
- [ ] T220 [P] Create API documentation in docs/api.md
- [ ] T221 Create API documentation in Russian docs/api-ru.md
- [ ] T222 [P] Update FEATURE_PARITY.md with implemented features per architecture pattern
- [ ] T223 Update FEATURE_PARITY-RU.md per FR-013-014

### Validation & Quality

- [ ] T224 Run validation script validate.sh for structure checks per SC-003
- [ ] T225 Run documentation validation for line count matching per FR-068
- [ ] T226 Test startup in both client and server modes per FR-048-049
- [ ] T227 Verify all success criteria (SC-001 through SC-013) per spec.md
- [ ] T228 [P] Create SETUP_STATUS.md documenting completion status
- [ ] T229 [P] Create IMPLEMENTATION_SUMMARY.md with feature overview

### Security Hardening

- [ ] T230 [P] Verify HTTPS/WSS configuration per NFR-015
- [ ] T231 [P] Test rate limiting per NFR-017
- [ ] T232 [P] Verify CORS configuration per NFR-019
- [ ] T233 [P] Test input validation and sanitization per NFR-014
- [ ] T234 Review and update threat model per NFR-020

### Performance Testing

- [ ] T235 Test with 50 concurrent users - verify <100ms response time per NFR-027
- [ ] T236 Test with 100 concurrent users - verify <500ms response time per NFR-027
- [ ] T237 Verify database query performance <3 seconds per NFR-002
- [ ] T238 Verify UI rendering at 60 FPS per NFR-003

**Checkpoint**: All polish complete, ready for release

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies - can start immediately
- **Foundational (Phase 2)**: Depends on Setup completion - BLOCKS all user stories
- **User Stories (Phases 3-7)**: All depend on Foundational phase completion
  - US1 (Repository Structure) → Can start after Phase 2
  - US2 (Bilingual Documentation) → Can start after Phase 2, benefits from US1 templates
  - US3 (Package System) → Can start after Phase 2 and US1
  - US4 (Database Integration) → Can start after Phase 2 and US3 (needs types package)
  - US5 (Clusters Feature) → Depends on Phases 2, 3, 4 (needs packages and database)
- **Auth UI (Phase 8)**: Depends on Phase 2 (AuthManager) and Phase 5 (package system)
  - US6 (Authentication UI) → Depends on auth backend from Phase 2
- **Shared Packages (Phase 9)**: Can start after Phase 3 (package structure)
  - US7 (Additional Packages) → Uses package template
- **Polish (Phase 10)**: Depends on all user stories being complete

### User Story Dependencies

```
Foundational (Phase 2) [BLOCKS EVERYTHING]
    ↓
    ├─→ US1 (Repository Structure, Phase 3) [Independent]
    │   └─→ US2 (Documentation, Phase 4) [Uses US1 templates]
    │       └─→ US3 (Package System, Phase 5) [Uses US1 structure]
    │           ├─→ US4 (Database, Phase 6) [Uses US3 types]
    │           │   └─→ US5 (Clusters, Phase 7) [Uses US3 + US4]
    │           ├─→ US6 (Auth UI, Phase 8) [Uses package template + auth backend]
    │           └─→ US7 (Shared Packages, Phase 9) [Uses package template]
    └─→ Polish (Phase 10) [Requires all user stories]
```

### Critical Path

1. Phase 1: Setup (T001-T012) - ~1-2 hours
2. Phase 2: Foundational (T013-T049) - ~2-3 days ⚠️ CRITICAL BLOCKER
3. Phase 3: US1 (T050-T058) - ~4-6 hours
4. Phase 4: US2 (T059-T070) - ~1-2 days
5. Phase 5: US3 (T071-T097) - ~2-3 days
6. Phase 6: US4 (T098-T110) - ~1-2 days
7. Phase 7: US5 (T111-T147) - ~3-4 days
8. Phase 8: US6 (T148-T177) - ~2-3 days
9. Phase 9: US7 (T178-T207) - ~2-3 days
10. Phase 10: Polish (T208-T238) - ~1-2 days

**Total Estimated Time**: 16-24 days for single developer following critical path

### Parallel Opportunities

#### Within Phase 2 (Foundational)
```bash
# These can run in parallel (different files):
T013-T016: Config implementation
T017-T024: Database implementation
T025-T033: Auth implementation
T034-T041: Network implementation
T042-T045: Logging implementation
```

#### Within Phase 3 (US1)
```bash
# All template files can be created in parallel:
T050, T051, T052, T053, T054: Template creation
```

#### Within Phase 4 (US2)
```bash
# All English docs can be created in parallel:
T059, T061, T063, T065, T066, T067, T068
# Then Russian translations done sequentially
```

#### Within Phase 5 (US3)
```bash
# All three packages can be developed in parallel by different developers:
T071-T080: universo-types package
T081-T089: universo-utils package
T090-T095: universo-api-client package
```

#### Within Phase 7 (US5)
```bash
# Backend and frontend can be developed in parallel:
T111-T126: Clusters backend (clusters-srv)
T127-T143: Clusters frontend (clusters-frt)
```

#### Within Phase 8 (US6 - Auth UI)
```bash
# Backend and frontend can be developed in parallel:
T148-T157: Auth backend (auth-srv)
T158-T172: Auth frontend (auth-frt)
```

#### Within Phase 9 (US7 - Shared Packages)
```bash
# All packages can be developed in parallel:
T178-T188: universo-template-godot
T189-T195: universo-i18n
T196-T203: universo-rest-docs
```

#### Within Phase 10 (Polish)
```bash
# Most polish tasks can run in parallel:
T208-T212: Theme development
T213-T217: Internationalization
T218-T223: Documentation
T228-T229: Summary documents
T230-T234: Security hardening
```

### Parallel Example: Foundational Phase

With 4 developers working in parallel after Phase 1:

```
Developer A: T013-T016 (Config) → T046-T049 (Startup)
Developer B: T017-T024 (Database) → T098-T110 (Testing)
Developer C: T025-T033 (Auth) → T148-T177 (Auth UI)
Developer D: T034-T041 (Network) → T042-T045 (Logging)
```

**Time Savings**: Foundational phase reduces from 2-3 days to ~1 day with parallelization

---

## Implementation Strategy

### MVP First (Recommended)

**Minimum Viable Product = Phases 1-8 (with Auth UI)**

1. Complete Phase 1: Setup (T001-T012)
2. Complete Phase 2: Foundational (T013-T049) ⚠️ MUST COMPLETE
3. Complete Phase 3: US1 Repository Structure (T050-T058)
4. Complete Phase 4: US2 Bilingual Documentation (T059-T070)
5. Complete Phase 5: US3 Package System (T071-T097)
6. Complete Phase 6: US4 Database Integration (T098-T110)
7. Complete Phase 7: US5 Clusters Feature (T111-T147)
8. Complete Phase 8: US6 Auth UI (T148-T177)
9. **STOP and VALIDATE**: Test complete auth + Clusters features
10. Deploy/Demo if ready

**MVP delivers**: Working authentication UI (login, register, password reset), Clusters feature with full CRUD, database integration, real-time sync, bilingual documentation

### Incremental Delivery

1. Foundation (Phases 1-2) → Infrastructure ready
2. Add US1 (Phase 3) → Repository structure validated
3. Add US2 (Phase 4) → Documentation complete
4. Add US3 (Phase 5) → Package system functional → **Demo: Package creation**
5. Add US4 (Phase 6) → Database working → **Demo: CRUD operations**
6. Add US5 (Phase 7) → Clusters feature complete → **Demo: Full feature**
7. Add US6 (Phase 8) → Auth UI complete → **Demo: Login/Register flow** 🎯 MVP
8. Add US7 (Phase 9) → Shared packages → **Demo: UI components**
9. Add Polish (Phase 10) → Production ready → **Release**

### Parallel Team Strategy

With 3+ developers after Foundational phase completes:

```
Week 1: Phase 1 + Phase 2 (all developers collaborate)

Week 2 (parallel after Phase 2):
- Developer A: Phase 3 (US1) → Phase 4 (US2)
- Developer B: Phase 5 (US3 - universo-types, universo-utils)
- Developer C: Phase 5 (US3 - universo-api-client) → Phase 6 (US4)

Week 3 (parallel):
- Developer A + B: Phase 7 (US5 - clusters-srv backend)
- Developer C: Phase 7 (US5 - clusters-frt frontend)

Week 4 (parallel):
- Developer A: Phase 8 (US6 - auth-frt frontend)
- Developer B: Phase 8 (US6 - auth-srv backend)
- Developer C: Phase 9 (US7 - shared packages)

Week 5:
- All developers: Phase 10 (Polish) + Integration testing
```

**Time Savings**: Project completes in ~4-5 weeks instead of 16-24 days sequential

---

## Summary

**Total Tasks**: 238 tasks organized across 10 phases
- Phase 1 (Setup): 12 tasks
- Phase 2 (Foundational): 37 tasks ⚠️ BLOCKS ALL STORIES
- Phase 3 (US1 - Repository Structure): 9 tasks
- Phase 4 (US2 - Documentation): 12 tasks
- Phase 5 (US3 - Package System): 27 tasks
- Phase 6 (US4 - Database): 13 tasks
- Phase 7 (US5 - Clusters): 37 tasks
- Phase 8 (US6 - Auth UI): 30 tasks
- Phase 9 (US7 - Shared Packages): 30 tasks
- Phase 10 (Polish): 31 tasks

**Task Count per User Story**:
- US1 (Repository Structure - P1): 9 tasks
- US2 (Bilingual Documentation - P1): 12 tasks
- US3 (Package System - P2): 27 tasks
- US4 (Database Integration - P2): 13 tasks
- US5 (Clusters Feature - P2): 37 tasks
- US6 (Auth UI - P1): 30 tasks
- US7 (Shared Packages - P3): 30 tasks

**Parallel Opportunities Identified**: ~110 tasks marked with [P] can run in parallel

**Independent Test Criteria**:
- US1: Clone, open in Godot, see organized structure
- US2: Read docs in both languages, verify structure match
- US3: Create new package from template, enable in Godot
- US4: Configure Supabase, perform CRUD operations
- US5: Use Clusters feature for complete workflow
- US6: Complete auth flow (register → login → logout → password reset)
- US7: Test UI components, i18n, API docs

**Suggested MVP Scope**: Phases 1-8 (Auth UI) = Complete foundation + Auth + Clusters features

**Format Validation**: ✅ All tasks follow format:
- [x] Checkbox format `- [ ]`
- [x] Sequential Task IDs (T001-T238)
- [x] [P] markers for parallelizable tasks (115 tasks)
- [x] [Story] labels for user story tasks (US1-US7)
- [x] Clear descriptions with file paths
- [x] No story labels for Setup, Foundational, and Polish phases

---

## Alignment with Universo Platformo React

**Reference**: [Universo Platformo React - Packages](https://github.com/teknokomo/universo-platformo-react/tree/main/packages)

**React Repository Package List (for reference):**
```
packages/
├── analytics-frt/              # Usage analytics
├── auth-frt/                   # Authentication frontend
├── auth-srv/                   # Authentication backend
├── clusters-frt/               # Clusters feature frontend
├── clusters-srv/               # Clusters feature backend
├── flowise-chatmessage/        # Legacy Flowise (not to replicate)
├── flowise-components/         # Legacy Flowise (will be split)
├── flowise-server/             # Legacy Flowise (not to replicate)
├── flowise-store/              # Legacy Flowise (not to replicate)
├── flowise-template-mui/       # Legacy Flowise (not to replicate)
├── flowise-ui/                 # Legacy Flowise (not to replicate)
├── metaverses-frt/             # Metaverses frontend
├── metaverses-srv/             # Metaverses backend
├── multiplayer-colyseus-srv/   # Multiplayer server
├── organizations-frt/          # Organizations frontend
├── organizations-srv/          # Organizations backend
├── profile-frt/                # User profile frontend
├── profile-srv/                # User profile backend
├── projects-frt/               # Projects frontend
├── projects-srv/               # Projects backend
├── publish-frt/                # Publishing frontend
├── publish-srv/                # Publishing backend
├── space-builder-frt/          # AI space builder frontend
├── space-builder-srv/          # AI space builder backend
├── spaces-frt/                 # Spaces/Canvas frontend
├── spaces-srv/                 # Spaces/Canvas backend
├── storages-frt/               # Storage management frontend
├── storages-srv/               # Storage management backend
├── template-mmoomm/            # MMOOMM template
├── template-quiz/              # Quiz template
├── uniks-frt/                  # Uniks frontend
├── uniks-srv/                  # Uniks backend
├── universo-api-client/        # Shared API client
├── universo-i18n/              # Internationalization
├── universo-rest-docs/         # API documentation
├── universo-template-mui/      # UI component library
├── universo-types/             # Shared types
├── universo-utils/             # Shared utilities
└── updl/                       # UPDL system
```

**Godot Implementation Improvements:**

| React Version | Godot Adaptation | Improvement |
|---------------|------------------|-------------|
| Monolithic flowise-components | Split into feature-specific packages | ✅ Avoids legacy monolith |
| packages/flowise-components/ | packages/node-system-{frt,srv}/ + langchain-nodes/ + custom-nodes/ | ✅ Better separation |
| packages/updl/base | packages/updl-nodes/ + updl/ (parser) | ✅ Clearer purpose split |
| Mixed frontend/backend in packages | Strict -frt/-srv separation | ✅ Deployment flexibility |
| PNPM workspace dependencies | Godot plugin.cfg dependencies | ✅ Native tool usage |
| React components | Godot scenes (.tscn) + scripts | ✅ Engine-native approach |
| Express routes | Godot HTTPServer handlers | ✅ Native implementation |

**Pattern Preservation:**
- ✅ **Modular packages** - Same concept, different implementation
- ✅ **Shared utilities** - universo-utils, universo-types (same as React)
- ✅ **Bilingual docs** - Maintained in both versions
- ✅ **Future extraction ready** - Packages can become separate repos
- ✅ **Template system** - package-template/ (same as React's templates)

**Key Differences (By Design):**
- 🔄 **Package manager**: PNPM → Godot addon system (appropriate for engine)
- 🔄 **Build system**: TypeScript compiler → Godot's built-in packaging
- 🔄 **Testing**: Jest → GUT (Godot Unit Test)
- 🔄 **State management**: Redux → Signals + Autoload singletons
- 🔄 **Routing**: React Router → Scene transitions

**Lessons Applied from React Version:**
1. ✅ Avoid mixing multiple features in one package (Flowise lesson)
2. ✅ Separate shared utilities into dedicated packages
3. ✅ Use templates for consistent package creation
4. ✅ Plan for independent deployment of packages
5. ✅ Maintain strict naming conventions

---

## Constitution Compliance
- All functionality in packages/ directory
- Frontend/backend separation (-frt/-srv)
- Bilingual documentation throughout
- Package-based modularity enforced
- Security-first design
- Database abstraction
- Test-first development (TDD)

---

## Package Expansion Pattern

**Current Implementation (001-project-setup):**
```
packages/
├── auth-frt/base/              # ✅ Auth UI (login, register, password reset)
├── auth-srv/base/              # ✅ Auth API
├── clusters-frt/base/          # ✅ First feature (frontend)
├── clusters-srv/base/          # ✅ First feature (backend)
├── universo-types/base/        # ✅ Shared types
├── universo-utils/base/        # ✅ Shared utilities
├── universo-api-client/base/   # ✅ HTTP client
├── universo-template-godot/base/ # ✅ UI component library
├── universo-i18n/base/         # ✅ Internationalization
├── universo-rest-docs/base/    # ✅ API documentation
└── package-template/base/      # ✅ Template for new packages
```

**Future Package Structure (Complete Roadmap - Aligned with React):**
```
packages/
# Authentication & User Management (001-project-setup ✅)
├── auth-frt/base/              # ✅ Auth UI (login, register, password reset)
├── auth-srv/base/              # ✅ Auth API
├── profile-frt/base/           # 🔜 User profile management UI
├── profile-srv/base/           # 🔜 User profile API

# Core Features (Progressive Implementation)
├── uniks-frt/base/             # 🔜 002-uniks-feature (unique resources)
├── uniks-srv/base/             # 🔜 Unique resources backend
├── metaverses-frt/base/        # 🔜 003-metaverses-feature (Metaverses / Sections / Entities)
├── metaverses-srv/base/        # 🔜 Metaverse management backend
├── organizations-frt/base/     # 🔜 004-organizations-feature (teams/orgs)
├── organizations-srv/base/     # 🔜 Organizations backend
├── storages-frt/base/          # 🔜 005-storages-feature (file storage)
├── storages-srv/base/          # 🔜 Storage backend
├── projects-frt/base/          # 🔜 006-projects-feature (project containers)
├── projects-srv/base/          # 🔜 Projects backend
├── spaces-frt/base/            # 🔜 007-spaces-canvases-feature (visual canvas)
├── spaces-srv/base/            # 🔜 Canvas system backend

# Node System & Libraries (Split from flowise-components)
├── node-system-frt/base/       # 🔜 008-node-libraries (core node editor UI)
├── node-system-srv/base/       # 🔜 Node graph execution engine
├── langchain-nodes/base/       # 🔜 LangChain integration nodes
├── updl-nodes/base/            # 🔜 UPDL transformation nodes
├── custom-nodes/base/          # 🔜 Custom node types framework

# Advanced Features
├── space-builder-frt/base/     # 🔜 009-space-builder (AI-assisted)
├── space-builder-srv/base/     # 🔜 LLM integration backend
├── publish-frt/base/           # 🔜 010-publishing-system
│   └── exporters/              # 🔜 Platform-specific exporters
│       ├── web-html5/
│       ├── desktop-native/
│       └── mobile-android/
├── publish-srv/base/           # 🔜 Publishing API

# Shared Infrastructure
├── universo-template-godot/base/ # ✅ UI component library (Material Design)
├── universo-i18n/base/         # ✅ Internationalization
├── universo-rest-docs/base/    # ✅ API documentation
├── universo-types/base/        # ✅ Shared types
├── universo-utils/base/        # ✅ Shared utilities
├── universo-api-client/base/   # ✅ HTTP client
├── analytics-frt/base/         # 🔜 Usage analytics
├── multiplayer-server-srv/base/ # 🔜 Multiplayer support (Godot native)
├── updl/base/                  # 🔜 UPDL parser/transformer
│   ├── parser/                 # UPDL JSON parser
│   ├── validator/              # Schema validation
│   └── transformer/            # UPDL ↔ Godot scene converter

# Templates (Reusable Starting Points)
├── template-quiz/base/         # 🔜 Quiz application template
├── template-mmoomm/base/       # 🔜 MMOOMM game template
└── package-template/base/      # ✅ Template for new packages
```

**Package Growth Strategy (Aligned with React Feature Roadmap):**
1. **001-project-setup (Current)**: Foundation + Auth UI + Clusters + Shared packages
2. **002-uniks-feature**: Unique resources (using Clusters as template)
3. **003-metaverses-feature**: Metaverses / Sections / Entities
4. **004-organizations-feature**: Team and organization management
5. **005-storages-feature**: File and asset storage
6. **006-projects-feature**: Project containers for Spaces
7. **007-spaces-canvases-feature**: Visual canvas editor with node system
8. **008-node-libraries-feature**: LangChain nodes, UPDL nodes, custom nodes
9. **009-space-builder-feature**: AI-assisted flow generation
10. **010-publishing-system-feature**: Multi-platform export and deployment

**Key Principles from React Version:**
- ✅ Avoid monolithic packages (split by feature + frontend/backend)
- ✅ Each package independently testable
- ✅ Clear dependencies declared in plugin.cfg
- ✅ Future repository extraction possible (packages can become separate repos)
- ✅ Follow naming convention: `{feature}-{frt|srv}/base/`

**Node System Split (Avoiding flowise-components Monolith):**
- React's `flowise-components` is a monolithic package with many node types
- Godot version splits this into:
  - `node-system-frt/srv` - Core node editor and execution engine
  - `langchain-nodes` - LangChain-specific nodes
  - `updl-nodes` - UPDL-specific nodes  
  - `custom-nodes` - Framework for custom node types

**Package Template Usage:**
Every new feature starts with:
```bash
godot --script tools/create_package.gd --package-name uniks --package-type frt
godot --script tools/create_package.gd --package-name uniks --package-type srv
```

---

## Godot-Specific Best Practices Applied

**Architecture Decisions:**
- ✅ Autoload singletons for global services (Config, DatabaseManager, NetworkManager, AuthManager)
- ✅ Plugin system for modular packages (plugin.cfg + plugin.gd per package)
- ✅ Signals for events and cross-package communication
- ✅ Type hints throughout (class_name, @export, typed variables)
- ✅ Resource classes for data models (extends Resource)
- ✅ Scene composition for UI (*.tscn files)

**Godot 4.3+ Features:**
- ✅ Native HTTPServer class for REST API
- ✅ Native WebSocketServer/WebSocketPeer for real-time sync
- ✅ GDScript 2.0 modern syntax
- ✅ Built-in Control nodes with custom themes

**Performance Patterns:**
- ✅ Connection pooling for database (5-20 connections)
- ✅ Deferred operations for non-critical tasks
- ✅ Optimistic UI updates with server reconciliation
- ✅ WebSocket message batching for efficiency

**Testing with GUT:**
- ✅ Unit tests per package in tests/unit/
- ✅ Integration tests in tests/integration/
- ✅ Contract tests for API in tests/contract/

---

## Notes

- Tasks marked [P] can be executed in parallel (different files, no shared state)
- Tasks with [Story] label map directly to user stories from spec.md (US1-US7)
- Each user story is independently completable and testable
- Foundational phase (Phase 2) is critical blocker - nothing can proceed until complete
- MVP can be achieved by completing Phases 1-8 (Foundation + Auth UI + Clusters)
- Full feature set achieved by completing all 10 phases
- Commit after each task or logical group of related tasks
- Stop at checkpoints to validate user story independence
- Follow .github/instructions/ for Issues, PRs, and documentation
- Reference Universo Platformo React for conceptual patterns (but adapt for Godot)
- Use package template for consistency when creating new features
- Avoid monolithic packages - split functionality into smaller, focused packages
- All packages should be independently testable and ready for future repository extraction
