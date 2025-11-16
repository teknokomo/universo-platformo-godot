# Feature Specification: Universo Platformo Godot - Project Setup & Foundation

**Feature Branch**: `copilot/setup-universo-platformo-godot-again`  
**Created**: 2025-11-16  
**Status**: Draft  
**Input**: Initialize Universo Platformo Godot implementation from scratch, following patterns from Universo Platformo React while adapting for Godot Engine and GDScript

## Clarifications

### Session 2025-11-16

- Q: which databases to prioritize for future support? → A: PostgreSQL and MongoDB (following web standards)
- Q: which authentication methods to support - basic auth, OAuth, JWT? → A: JWT tokens with Passport.js-inspired strategy pattern
- Q: how should mode switching be implemented? → A: Command-line arguments with --server flag for headless mode
- Q: what variations in entity count are expected? → A: 3-level hierarchy standard (like Clusters), but support 2-5 levels for flexibility
- Q: real-time sync strategy? → A: WebSocket-based signals with optimistic UI updates and conflict resolution

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

- **FR-017**: Project MUST use Godot Engine 4.x (latest stable version)
- **FR-018**: All code MUST be written in GDScript for both frontend and backend
- **FR-019**: Project MUST support Supabase as primary database
- **FR-020**: Database layer MUST be extensible to support additional databases in future (priority: PostgreSQL and MongoDB after Supabase)
- **FR-021**: Authentication system MUST be implemented in GDScript using JWT tokens with Passport.js-inspired strategy pattern for extensibility

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

- **NFR-013**: Database credentials MUST be stored in .env file (not committed)
- **NFR-014**: API endpoints MUST validate all input data using schema validation and sanitization
- **NFR-015**: Authentication tokens MUST be securely stored in memory (never persisted to disk) and transmitted over HTTPS/WSS

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
