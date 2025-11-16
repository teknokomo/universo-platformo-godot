<!--
SYNC IMPACT REPORT
==================
Version Change: 1.0.0 → 1.1.0
Reason: Added Security-First Design principle (VIII), clarified Package-Based Modularity with Godot-native details, enhanced Technology Stack Requirements

Modified Principles:
- UPDATED: II. Package-Based Modularity (Godot-Native Approach) - Added clarification that Godot's addon system replaces PNPM, no external package manager needed
- NEW: VIII. Security-First Design - Added comprehensive security principle

Updated Sections:
- Technology Stack Requirements - Specified minimum Godot 4.3+, clarified HTTP/WebSocket implementation, detailed authentication strategy pattern, explicit package management via addon system

Templates Status:
- ✅ plan-template.md - Reviewed, no updates needed (generic constitution check)
- ✅ spec-template.md - Reviewed, no updates needed (requirements-focused)
- ✅ tasks-template.md - Reviewed, no updates needed (user story based)

Follow-up TODOs:
- None - All enhancements complete

Ratification Details:
- Original ratification date: 2025-11-16 (initial adoption)
- Amendment date: 2025-11-16 (same day - comprehensive enhancement)
- Reason for amendment: Specification enhancement phase identified gaps in security principles and package management clarity
-->

# Universo Platformo Godot Constitution

## Core Principles

### I. Godot-Native Architecture

Every feature MUST be implemented using Godot Engine's native capabilities and GDScript best practices. The project is a full-stack implementation where:
- Frontend components are Godot scenes and scripts
- Backend services are GDScript-based servers or modules
- All code adheres to Godot's scene tree paradigm and signal-based event system
- No unnecessary frameworks or abstractions that conflict with Godot's architecture

**Rationale**: Godot Engine provides a complete ecosystem for full-stack development. Leveraging native capabilities ensures optimal performance, maintainability, and seamless integration with the engine's features.

### II. Package-Based Modularity (Godot-Native Approach)

All functionality MUST be organized as self-contained packages within `packages/` directory using Godot's native addon system:
- Each package follows the naming convention: `packages/{feature}-frt` (frontend) and `packages/{feature}-srv` (backend/server)
- Every package contains a `base/` root folder for core implementation
- Packages are Godot plugins registered in `project.godot` (no PNPM or npm equivalent needed)
- Package dependencies declared in `plugin.cfg` [dependencies] section
- Packages are independently testable and documented
- Future alternative implementations can coexist (e.g., `packages/clusters-frt/base/`, `packages/clusters-frt/alternative/`)

**Rationale**: Package-based structure enables incremental development, parallel feature work, and future extensibility. Unlike Universo Platformo React which uses PNPM workspaces, Godot's native addon system provides built-in package management without external tools. The monorepo approach with clear separation supports team scalability.

### III. Bilingual Documentation (NON-NEGOTIABLE)

ALL documentation MUST be provided in both English and Russian with EXACT structural parity:
- English is the primary standard (`README.md`, `docs/*.md`)
- Russian versions follow immediately (`README-RU.md`, `docs/*-RU.md`)
- Both versions MUST have identical line count, section structure, and content meaning
- GitHub Issues and Pull Requests MUST use `<details><summary>In Russian</summary>` spoiler format for Russian translation

**Rationale**: The Universo Platformo project serves an international community with significant Russian-speaking users. Exact parity ensures no information is lost in translation and maintains consistency across the project.

### IV. Test-First Development

Features MUST follow test-driven development (TDD) practices:
- Tests are written BEFORE implementation begins
- Tests MUST fail initially to prove they test the right behavior
- Implementation proceeds only after test approval
- Red-Green-Refactor cycle is enforced for all new features
- Integration tests cover critical paths: database operations, API endpoints, inter-package communication

**Rationale**: TDD ensures requirements are clear, implementation is verifiable, and regressions are caught early. This is especially critical for a full-stack system with multiple interacting packages.

### V. Database Abstraction

Database access MUST be abstracted to support multiple backends:
- Primary implementation targets Supabase (current standard)
- Database layer MUST be designed for future support of additional SQL/NoSQL databases
- All database operations go through abstraction interfaces/classes
- No direct database-specific code outside the database abstraction layer

**Rationale**: While Supabase is the initial choice, the platform must evolve to support diverse deployment scenarios and database preferences without rewriting features.

### VI. Progressive Feature Development

Features MUST be developed incrementally following this priority order:
1. Repository setup and base documentation
2. Base functionality and infrastructure
3. First complete feature: Clusters (Clusters/Domains/Resources entities)
4. Replicate pattern to similar features: Metaverses (Metaverses/Sections/Entities)
5. Extended features: Spaces/Canvases with node graph systems (LangChain, UPDL nodes)

Each feature MUST be independently completable and testable before moving to the next priority.

**Rationale**: Incremental development minimizes risk, provides early value, and establishes reusable patterns. The Clusters feature serves as the template for subsequent similar features.

### VII. GDScript Best Practices

All code MUST follow Godot and GDScript community best practices:
- Use GDScript's type hints and static typing where possible
- Follow Godot's naming conventions (PascalCase for classes, snake_case for functions/variables)
- Leverage signals for decoupled communication
- Use Godot's resource system for data modeling
- Prefer composition over inheritance
- Keep scripts focused and single-responsibility

**Rationale**: Consistent coding standards improve readability, reduce bugs, and make the codebase accessible to the broader Godot developer community.

### VIII. Security-First Design

Security MUST be integral to all features, not an afterthought:
- Authentication and authorization checks MUST precede all state-changing operations
- All sensitive data (credentials, tokens) MUST be stored securely (environment variables, memory-only for tokens)
- Input validation and sanitization MUST occur at API boundaries
- Security headers and CORS policies MUST be properly configured
- Rate limiting MUST protect against abuse
- Regular security reviews and threat modeling MUST be conducted
- Security vulnerabilities MUST be addressed with highest priority

**Rationale**: As a full-stack platform handling user data, security is paramount. Building security into the architecture from the start prevents costly retrofits and protects users. The Universo Platformo is designed for multi-user environments where trust and safety are critical.

## Technology Stack Requirements

**Core Technologies**:
- Godot Engine 4.3+ (minimum version) with GDScript
- Supabase for database and authentication (with abstraction layer)
- Material Design UI principles adapted for Godot (using native Control nodes with custom themes)
- Godot's native addon system (NO PNPM/npm equivalent - packages managed through project.godot)

**Backend Implementation**:
- HTTP Server: Godot's native HTTPServer class (4.3+) or vetted third-party addon
- WebSocket Server: Godot's native WebSocketServer and WebSocketPeer classes
- Scale Target: 100-500 concurrent users per server instance

**Authentication**:
- JWT tokens with Passport.js-inspired strategy pattern
- Initial: JWTAuthStrategy class
- Extensibility: OAuth2Strategy, APIKeyStrategy, custom strategies via BaseAuthStrategy interface

**Package Management**:
- Godot's addon system for shared packages
- Each package is a self-contained Godot plugin with plugin.cfg and plugin.gd
- Dependencies declared in plugin.cfg [dependencies] section
- Loading order controlled via autoload system in project.godot

**Documentation Standards**:
- English + Russian with exact structural parity
- Markdown format for all text documentation
- In-code documentation using GDScript docstrings

**Reference Implementation**:
- Universo Platformo React (https://github.com/teknokomo/universo-platformo-react) serves as conceptual reference
- Adapt concepts to Godot paradigms, DO NOT copy React-specific implementation details
- DO NOT replicate React project's `docs/` folder or AI agent configurations

## Development Workflow

**Issue Creation**:
- Follow `.github/instructions/github-issues.md` for issue format
- Use bilingual format with English primary and Russian in `<details><summary>In Russian</summary>` spoiler
- Apply labels according to `.github/instructions/github-labels.md`

**Pull Request Process**:
- Follow `.github/instructions/github-pr.md` for PR format
- Title format: `GH{issue_number} {descriptive_title}`
- Include `Fixes #{issue_number}` to auto-close issues
- Use bilingual description format
- Include "Additional Work" section documenting supplementary changes

**Documentation Updates**:
- Follow `.github/instructions/i18n-docs.md` strictly
- Update English version first (primary standard)
- Create Russian version with identical structure and line count
- Verify both versions have matching content and structure

**Specification Process**:
- Analyze Universo Platformo React repository for feature requirements
- Create specifications following SpecKit templates in `.specify/templates/`
- Track implementation progress with task lists
- Monitor React repository for new features to port to Godot implementation

## Governance

**Constitutional Authority**:
This constitution supersedes all other development practices and guidelines. In case of conflict, constitutional principles take precedence.

**Amendment Process**:
- Amendments require documented justification and community review
- Version bumping follows semantic versioning:
  - MAJOR: Breaking changes to core principles or governance structure
  - MINOR: New principles added or significant principle expansions
  - PATCH: Clarifications, wording improvements, non-semantic refinements
- All amendments must update dependent templates and documentation

**Compliance Verification**:
- Every PR and code review MUST verify compliance with these principles
- Constitutional violations must be justified with explicit reasoning
- Complexity or deviations require documentation in PR descriptions
- Regular constitution reviews to ensure principles remain relevant

**Living Document**:
This constitution evolves with the project. Feedback and improvement suggestions are welcome through the standard issue/PR process.

**Version**: 1.1.0 | **Ratified**: 2025-11-16 | **Last Amended**: 2025-11-16
