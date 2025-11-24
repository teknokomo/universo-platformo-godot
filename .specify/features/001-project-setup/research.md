# Research: Best Practices for Godot/GDScript Full-Stack Development

**Feature**: 001-project-setup  
**Date**: 2025-11-17  
**Status**: Complete

## Executive Summary

This research consolidates best practices, technical solutions, and patterns for implementing a full-stack application using Godot Engine 4.3+ and GDScript. The findings address all technical clarifications needed for the Universo Platformo Godot project.

## Research Topics

### 1. Godot 4.3+ Full-Stack Architecture Patterns

#### Decision: Scene-Based Modular Architecture with Autoload Singletons

**Rationale**:
- Godot's scene-tree paradigm provides natural separation of concerns
- Autoload scripts serve as global managers (Config, DatabaseManager, NetworkManager)
- Scenes should be organized hierarchically with backend logic in separate node structures
- Signal-based event system ensures loose coupling between components

**Best Practices**:
- Use Scenes to construct node hierarchies for clear separation (backend nodes for HTTP/WebSocket logic, separate scenes for UI)
- Implement autoload singletons via Project Settings → Autoload for persistent global data
- Prefer composition (multiple reusable scripts/scenes) over deeply nested inheritance
- Keep scripts focused and single-responsibility
- Use GDScript's type hints and static typing for better performance and error detection

**Source References**:
- GDQuest Design Patterns: https://www.gdquest.com/tutorial/godot/design-patterns/intro-to-design-patterns/
- Godot Official Best Practices: https://docs.godotengine.org/en/stable/tutorials/best_practices/index.html
- Godot 4.3 Developer Cheatsheet: https://themetalvortex.com/godot-4-3-developer-cheatsheet-game-architecture-workflows/

**Alternatives Considered**:
- MVC/MVVM patterns: Too rigid for Godot's scene-based system
- Monolithic single-script approach: Doesn't scale for full-stack applications

---

### 2. HTTP Server Implementation in GDScript

#### Decision: Use REST API Server Plugin (godot-rest-api-server) with Fallback to GodotTPD

**Rationale**:
- REST API Server plugin provides Express-like routing with minimal boilerplate
- Native support for HTTP and HTTPS
- Clean signal-based endpoint handling
- Well-maintained and documented for Godot 4.x
- Alternative: GodotTPD offers similar functionality if primary plugin has limitations

**Implementation Pattern**:
```gdscript
# Main server node: RESTHttpServer
# Endpoint handling: RESTApiHandler
# Define endpoints as strings: "users/:username/slots/:slot_number"
# Handle requests via signals with parameters as dictionaries
```

**Performance Considerations**:
- GDScript-based servers are suitable for 100-500 concurrent users
- For heavier loads (1000+), consider backend languages like Go or Python with Godot as client
- HTTP is stateless; use WebSocket for real-time features

**Source References**:
- REST API Server for Godot 4.x: https://github.com/fbcosentino/godot-rest-api-server
- GodotTPD: https://github.com/deep-entertainment/godottpd
- Godot Asset Library: https://godotassetlibrary.com/asset/cp5f9v/rest-api-server---for-restful-apis

**Alternatives Considered**:
- Custom TCP implementation: Too low-level, requires HTTP protocol parsing
- Godot's HTTPClient: Only for client-side requests, not serving

---

### 3. WebSocket Server Implementation

#### Decision: Godot Native WebSocketServer/WebSocketPeer Classes

**Rationale**:
- Godot 4.3+ provides robust native WebSocket support
- Direct integration with Godot's multiplayer API
- Low-level control over packet handling and connection management
- No external dependencies needed

**Implementation Pattern**:
```gdscript
var server = WebSocketServer.new()
func _ready():
    server.listen(8081)
    # Handle connections via signals or polling
func _process(delta):
    server.poll()
    # Handle incoming packets and connections
```

**Synchronization Patterns**:
- **Server-Authoritative**: Server maintains game state, validates inputs, broadcasts updates
- **Optimistic UI Updates**: Clients immediately reflect changes, mark as "pending", rollback on rejection
- **Message Format**: JSON with structure: `{type, entity, action, id, data, timestamp, user_id}`
- **Interpolation**: Client-side position interpolation for smooth movement (update every 10 ticks/sec)
- **Reconnection**: Exponential backoff (1s, 2s, 4s, 8s, 16s, max 30s)
- **Message Queue**: Queue outgoing messages during disconnection (max 100, discard oldest)

**Source References**:
- Godot WebSocket Documentation: https://docs.godotengine.org/en/stable/tutorials/networking/websocket.html
- WebSocket Multiplayer Demo: https://godotengine.org/asset-library/asset/2801
- Simple WebSocket Multiplayer Addon: https://godotengine.org/asset-library/asset/4320

**Alternatives Considered**:
- Node.js backend: Better for scalability but adds deployment complexity
- ENet protocol: Better for traditional multiplayer but less browser-compatible

---

### 4. Godot Addon System Best Practices

#### Decision: Standard Plugin Structure with plugin.cfg and plugin.gd

**Rationale**:
- Godot's native addon system provides built-in package management
- No external tools (PNPM/npm) needed
- Clean integration with Godot Editor
- Supports semantic versioning and dependency management

**Plugin Structure**:
```
addons/package_name/
├── plugin.cfg           # Metadata (name, description, author, version, script)
├── plugin.gd           # Entry point (extends EditorPlugin)
├── base/               # Core implementation
│   ├── scenes/
│   ├── scripts/
│   └── assets/
└── docs/
    ├── README.md
    └── README-RU.md
```

**plugin.cfg Format**:
```ini
[plugin]
name="Package Name"
description="Package description"
author="Author Name"
version="1.0.0"
script="plugin.gd"

[dependencies]
required_plugins=["other_plugin_name"]
```

**Best Practices**:
- Use EditorPlugin inheritance with `tool` keyword
- Initialize in `_enter_tree()`, cleanup in `_exit_tree()`
- Keep scene hierarchies shallow with descriptive names
- Document APIs clearly for maintainability
- Follow semantic versioning (MAJOR.MINOR.PATCH)

**Design Patterns**:
- **Signal Bus**: Centralize event communication without tight coupling
- **State Machine**: For complex systems with multiple states (only when needed)
- **Object Pooling**: For frequently created/destroyed objects (bullets, effects)
- **Resource Pattern (.tres)**: Store reusable configuration in custom resource files
- **Autoload (Singleton)**: Only for truly global managers

**Source References**:
- Godot Plugin Documentation: https://docs.godotengine.org/en/3.1/tutorials/plugins/editor/making_plugins.html
- GDQuest Design Patterns: https://github.com/gdquest-demos/godot-design-patterns
- JetBrains Godot Addon Guide: https://www.jetbrains.com/guide/gamedev/links/building-a-godot-addon/

**Alternatives Considered**:
- Git submodules: More complex, doesn't integrate with Godot Editor
- Manual file copying: Error-prone, no version management

---

### 5. Material Design UI in Godot

#### Decision: Custom Theme Resources with StyleBoxFlat for Material Design Aesthetics

**Rationale**:
- Godot's built-in Control nodes and Theme system are sufficient
- No external UI library needed (reduces dependencies)
- Theme resources (.tres) are reusable and easy to maintain
- StyleBoxFlat provides all Material Design visual elements (rounded corners, shadows, elevation)

**Implementation Approach**:
1. Create Theme resource (File System → New Resource → Theme)
2. Edit in Theme Editor panel (bottom of editor)
3. Add Types (Button, Panel, Label, etc.)
4. Customize StyleBox, Colors, Fonts, Icons for each Type
5. Apply globally (Project Settings → GUI → Theme) or per-node

**Material Design Elements**:
- **Rounded Corners**: StyleBoxFlat corner_radius property
- **Elevation/Shadow**: StyleBoxFlat shadow with subtle opacity
- **Color Palette**: Primary, surface, accent colors (3 main colors + variations)
- **Typography**: Roboto font or similar in Theme Font Items
- **Icons**: Custom SVGs/PNGs for checkboxes, sliders, radio buttons

**Programmatic Theme Override**:
```gdscript
$Button.add_theme_color_override("font_color", Color(0.2, 0.6, 0.8))
$Button.add_theme_stylebox_override("normal", StyleBoxFlat.new())
```

**Source References**:
- Godot Theme Editor: https://docs.godotengine.org/en/4.3/tutorials/ui/gui_using_theme_editor.html
- Custom Theme Tutorial: https://gamedevfcups.com/how-to-make-a-custom-theme-in-godot/
- Minimal Theme Example: https://github.com/passivestar/godot-minimal-theme

**Alternatives Considered**:
- External Material Design library: Unnecessary overhead, harder to customize
- Pure code-based UI: Less maintainable, no visual preview

---

### 6. Supabase Integration with Godot

#### Decision: Community Supabase Addon with REST API via HTTPRequest

**Rationale**:
- Mature community addon (supabase-community/godot-engine.supabase) provides ready-to-use integration
- Supports authentication, database, realtime, and storage out-of-the-box
- REST API approach is stable and well-documented
- Drag-and-drop UI library for rapid prototyping

**Implementation Pattern**:
```gdscript
const config := {
    "supabaseUrl": "{your_supabase_url}",
    "supabaseKey": "{your_supabase_anon_key}"
}

func _ready():
    Supabase.load_config(config)
    var task = Supabase.Auth.sign_in("email@example.com", "password")
    var auth_result = await task.completed
    if auth_result.success:
        print("Logged in:", auth_result.data.user)
    else:
        print("Failed:", auth_result.error)
```

**Authentication Features**:
- Email/password login
- Anonymous login
- OTP (One-Time Password)
- Magic links
- OAuth support (Google, GitHub, etc.)

**Database Operations**:
- Query, insert, update, delete via REST API
- Real-time subscriptions
- Row-level security (RLS) support

**Source References**:
- Supabase Godot Addon: https://github.com/supabase-community/godot-engine.supabase
- Alternative Addon: https://github.com/Overvault-64/Supabase-Godot-API
- OAuth Tutorial: https://www.youtube.com/watch?v=g1tgPEKCKg0

**Alternatives Considered**:
- Direct PostgreSQL connection: More complex, requires additional libraries
- Custom REST wrapper: Reinventing the wheel, more maintenance

---

### 7. JWT Authentication in GDScript

#### Decision: godot-engine.jwt Library by fenix-hub

**Rationale**:
- Mature GDScript library with HS256 and RS256 support
- JWT creation, signing, verification, and decoding
- Available on GitHub and Godot Asset Library
- Active maintenance and community support

**Implementation Pattern**:
```gdscript
# Creating a JWT
var secret = "your-secret-key"
var jwt_algorithm = JWTAlgorithmBuilder.HS256(secret)
var jwt_builder = JWT.create()
    .with_expires_at(OS.get_unix_time() + 3600)
    .with_issuer("GodotGame")
    .with_claim("user_id", user_id)
var token = jwt_builder.sign(jwt_algorithm)

# Verifying a JWT
var jwt_verifier = JWT.require(jwt_algorithm)
    .with_claim("user_id", expected_user_id)
    .build()
if jwt_verifier.verify(token) == JWTVerifier.JWTExceptions.OK:
    print("Token is valid!")
```

**Security Best Practices**:
- Always set expiration (`exp`) claims (15 minutes for access tokens)
- Use refresh tokens (30-day expiry) stored separately
- Store JWT_SECRET in .env file (256-bit minimum)
- Use HTTPS for all token transmission
- Prefer RS256 for public APIs (asymmetric keys)
- Never store sensitive data in payload (only base64-encoded, not encrypted)
- Implement token blacklisting/revocation for logout

**Token Management Strategy**:
- Access token: Short-lived (15 min), stored in memory only
- Refresh token: Long-lived (30 days), stored in secure table
- Automatic refresh before expiry
- Clear all tokens on logout

**Source References**:
- godot-engine.jwt: https://github.com/fenix-hub/godot-engine.jwt
- Asset Library: https://godotengine.org/asset-library/asset/1104
- JWT Security Guide: https://jsonconsole.com/blog/advanced-json-web-token-jwt-implementation-security-best-practices

**Alternatives Considered**:
- Custom JWT implementation: Error-prone, security risks
- Session-based auth: Less scalable for distributed systems

---

### 8. Testing Frameworks for Godot

#### Decision: GUT (Godot Unit Test) as Primary Framework

**Rationale**:
- Most mature and popular testing framework for Godot
- Supports both Godot 3.x and 4.x
- Works in editor and CLI (CI/CD compatible)
- Rich assertion library with doubles (mocks/stubs)
- Parameterized tests and inner test classes
- JUnit XML export for CI integration
- VSCode extension for IDE integration

**Framework Comparison**:

| Feature | GUT | GdUnit4 |
|---------|-----|---------|
| GDScript Support | ✅ | ✅ |
| C# Support | ❌ | ✅ |
| Scene Testing | ✅ | ✅ |
| Mocking/Stubbing | ✅ | ✅ |
| Parameterized Tests | ✅ | ✅ |
| CLI Support | ✅ | ✅ |
| Editor Integration | ✅ | ✅ (Test Inspector) |
| Community Size | Larger | Growing |

**Test Structure**:
```gdscript
extends GutTest

func before_all():
    # Setup once before all tests

func before_each():
    # Setup before each test

func after_each():
    # Cleanup after each test

func after_all():
    # Cleanup once after all tests

func test_example():
    assert_eq(1, 1, "Should pass")
```

**Best Practices**:
- Place tests in `test/` or `tests/` directory
- Name test files with `test_` prefix (e.g., `test_player.gd`)
- Group related tests with inner classes
- Use parameterized tests to reduce duplication
- Write integration tests for scene interactions
- Mock external dependencies (database, network)

**Source References**:
- GUT GitHub: https://github.com/bitwes/Gut
- GUT Documentation: https://gut.readthedocs.io/en/latest/Quick-Start.html
- GdUnit4: https://github.com/MikeSchulze/gdUnit4
- Testing Tutorial: https://nightblade9.github.io/godot-gamedev/2019/getting-started-with-unit-and-integration-testing-in-godot.html

**Alternatives Considered**:
- GdUnit4: Good alternative, especially for C# projects
- Custom test framework: Not recommended, reinvents the wheel

---

### 9. Monorepo Architecture for Godot

#### Decision: Filesystem-Based Package Organization with Addons System

**Rationale**:
- Godot has no native monorepo tools like PNPM/npm
- Filesystem discipline + version control provides sufficient organization
- Addons directory serves as package registry
- Clear folder structure scales well with team size

**Recommended Structure**:
```
/project.godot
/addons/                    # Reusable packages/plugins
│   ├── auth/
│   ├── database/
│   └── networking/
/packages/                  # Feature modules
│   ├── clusters-frt/       # Frontend package
│   │   └── base/
│   │       ├── scenes/
│   │       ├── scripts/
│   │       ├── plugin.cfg
│   │       └── plugin.gd
│   ├── clusters-srv/       # Backend package
│   │   └── base/
│   │       ├── scripts/
│   │       ├── api/
│   │       ├── plugin.cfg
│   │       └── plugin.gd
│   └── metaverses-frt/
/scenes/                    # Main application scenes
/scripts/                   # Shared utility scripts
/assets/                    # Shared assets
/themes/                    # UI themes
/translations/              # i18n files
/tests/                     # Test suites
/.github/                   # GitHub workflows
/.specify/                  # Specification tools
```

**Best Practices**:
- Group assets near scenes for maintainability
- Use snake_case for directories, PascalCase for scripts
- Use `.gdignore` to exclude folders from import/cache
- Each package should be independently testable
- Shared code goes in `/addons` or `/scripts`
- Document package dependencies in plugin.cfg

**Package Naming Convention**:
- Frontend packages: `{feature}-frt`
- Backend packages: `{feature}-srv`
- Shared packages: `{feature}-shared` (if needed)
- Each package contains `base/` for primary implementation

**CI/CD Strategy**:
- Matrix builds for each package
- Selective test execution based on changed files
- Automated build/export per package
- Version tagging per package release

**Source References**:
- Godot Project Organization: https://docs.godotengine.org/en/stable/tutorials/best_practices/project_organization.html
- Monorepo Best Practices: https://www.aviator.co/blog/monorepo-a-hands-on-guide-for-managing-repositories-and-microservices/
- GitHub Monorepo Guide: https://wellarchitected.github.com/library/scenarios/monorepos/

**Alternatives Considered**:
- Git submodules: Complex merge conflicts, harder to maintain
- Multiple repositories: Loses atomic commits, harder to refactor across packages
- External monorepo tools (Bazel, Nx): Overkill for Godot projects

---

## Technical Clarifications Resolution

All "NEEDS CLARIFICATION" items from the Technical Context have been resolved:

✅ **Language/Version**: Godot Engine 4.3+ (minimum), GDScript  
✅ **Primary Dependencies**: REST API Server addon, Supabase addon, JWT library, GUT testing  
✅ **Storage**: Supabase (PostgreSQL) via REST API  
✅ **Testing**: GUT (Godot Unit Test) with CLI and editor support  
✅ **Target Platform**: Desktop (Windows/Linux/Mac) + Server (headless)  
✅ **Project Type**: Full-stack application (frontend + backend in single project)  
✅ **Performance Goals**: 100-500 concurrent users per server instance  
✅ **Constraints**: <200ms p95 latency for API calls, <100MB memory for headless server  
✅ **Scale/Scope**: Initial implementation with 3-5 packages, extensible to 20+ packages

## Implementation Priorities

Based on research findings, the recommended implementation order:

1. **Project Setup** (P0 - Foundation)
   - Initialize Godot 4.3+ project
   - Setup addon system and package structure
   - Configure .env and config.json
   - Create base documentation (README, CONTRIBUTING, ARCHITECTURE)

2. **Core Infrastructure** (P1 - Critical)
   - Implement autoload managers (Config, Logger, DatabaseManager, NetworkManager)
   - Integrate Supabase addon
   - Setup JWT authentication
   - Configure Material Design theme

3. **Server Implementation** (P1 - Critical)
   - Install REST API Server plugin
   - Implement WebSocket server
   - Create API routing system
   - Setup authentication middleware

4. **Testing Foundation** (P1 - Critical)
   - Install GUT framework
   - Create test directory structure
   - Write initial unit tests for core managers
   - Setup CI/CD with automated testing

5. **First Feature: Clusters** (P2 - Template)
   - Implement packages/clusters-frt/base/
   - Implement packages/clusters-srv/base/
   - Create full CRUD operations
   - Serve as template for future features

6. **Documentation & Guidelines** (P2 - Essential)
   - Complete bilingual README files
   - Create package development guide
   - Document API contracts
   - Setup GitHub issue/PR templates

## Recommendations

### Do's
- ✅ Use Godot's native capabilities wherever possible
- ✅ Follow scene-based architecture with autoload for global services
- ✅ Implement server-authoritative multiplayer patterns
- ✅ Write tests before implementation (TDD)
- ✅ Maintain bilingual documentation with exact parity
- ✅ Use semantic versioning for all packages
- ✅ Keep packages independently testable
- ✅ Document all public APIs clearly

### Don'ts
- ❌ Don't create custom package managers (use Godot's addon system)
- ❌ Don't skip testing for "simple" features
- ❌ Don't expose sensitive data in JWT payloads
- ❌ Don't use client-authoritative patterns (security risk)
- ❌ Don't create deep inheritance hierarchies (prefer composition)
- ❌ Don't hard-code configuration (use .env and config.json)
- ❌ Don't optimize prematurely (profile first)

## Next Steps

1. Update Technical Context in plan.md with resolved clarifications
2. Proceed to Phase 1: Design & Contracts
3. Create data-model.md for entity definitions
4. Generate API contracts in contracts/ directory
5. Create quickstart.md for onboarding
6. Update agent context files

## References Summary

### Official Documentation
- Godot 4.3+ Documentation: https://docs.godotengine.org/en/stable/
- GDScript Reference: https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/
- WebSocket Tutorial: https://docs.godotengine.org/en/stable/tutorials/networking/websocket.html

### Community Resources
- GDQuest (Design Patterns): https://www.gdquest.com/
- Godot Asset Library: https://godotengine.org/asset-library/
- Godot Forum: https://forum.godotengine.org/

### Essential Addons
- REST API Server: https://github.com/fbcosentino/godot-rest-api-server
- Supabase Integration: https://github.com/supabase-community/godot-engine.supabase
- JWT Library: https://github.com/fenix-hub/godot-engine.jwt
- GUT Testing: https://github.com/bitwes/Gut

### Learning Resources
- Godot Tutorials: https://gdscript.com/tutorials/
- Game Dev Patterns: https://www.manuelsanchezdev.com/blog/game-development-patterns
- Godot Cookbook: https://github.com/PacktPublishing/Godot-4-Game-Development-Cookbook

---

**Research Completed**: 2025-11-17  
**Total Sources Reviewed**: 30+  
**Status**: Ready for Phase 1 (Design & Contracts)
