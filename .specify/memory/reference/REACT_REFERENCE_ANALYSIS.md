# Reference Project Analysis: Universo Platformo React vs Godot

**Date**: 2025-11-17  
**Purpose**: Document package organization patterns from React implementation for adaptation to Godot version

## Overview

This document analyzes the [Universo Platformo React](https://github.com/teknokomo/universo-platformo-react) repository to identify package organization patterns and shared entity concepts that should be adapted for the Godot implementation.

## Package Structure Comparison

### React Version Organization

The React version uses PNPM workspaces with the following package structure:

```
packages/
├── README.md                    # Package directory documentation
├── README-RU.md                 # Russian version
├── TEMPLATE-README.md           # Template for new package READMEs
├── TEMPLATE-README-GUIDE.md     # Guide for using the template
│
├── Feature Packages (Frontend/Backend pairs)
│   ├── auth-frt/                # Authentication frontend
│   ├── auth-srv/                # Authentication backend
│   ├── clusters-frt/            # Clusters frontend
│   ├── clusters-srv/            # Clusters backend
│   ├── metaverses-frt/          # Metaverses frontend
│   ├── metaverses-srv/          # Metaverses backend
│   ├── profile-frt/             # User profiles frontend
│   ├── profile-srv/             # User profiles backend
│   ├── projects-frt/            # Projects frontend
│   ├── projects-srv/            # Projects backend
│   ├── publish-frt/             # Publishing frontend
│   ├── publish-srv/             # Publishing backend
│   ├── spaces-frt/              # Spaces frontend
│   ├── spaces-srv/              # Spaces backend
│   ├── uniks-frt/               # Uniks frontend
│   ├── uniks-srv/               # Uniks backend
│   ├── space-builder-frt/       # Space builder UI
│   ├── space-builder-srv/       # Space builder backend
│
├── Shared/Utility Packages (NO -frt/-srv suffix)
│   ├── universo-types/          # Common TypeScript types
│   ├── universo-utils/          # Common utilities
│   ├── universo-i18n/           # Internationalization
│   ├── universo-api-client/     # API client library
│   ├── universo-template-mui/   # MUI theme template
│   ├── universo-rest-docs/      # REST API documentation
│
├── Specialized Packages
│   ├── analytics-frt/           # Analytics (frontend only)
│   ├── multiplayer-colyseus-srv/# Multiplayer server (backend only)
│   ├── updl/                    # UPDL system
│   ├── template-mmoomm/         # Template packages
│   └── template-quiz/
│
└── Legacy Flowise Packages (TO BE REFACTORED)
    ├── flowise-ui/
    ├── flowise-server/
    ├── flowise-components/
    ├── flowise-chatmessage/
    ├── flowise-store/
    └── flowise-template-mui/
```

### Godot Version Organization (Target)

Adapt the same principles to Godot's addon system:

```
packages/
├── README.md                    # Package directory documentation
├── README-RU.md                 # Russian version
│
├── Feature Packages (Frontend/Backend pairs)
│   ├── clusters-frt/base/       # Clusters frontend
│   ├── clusters-srv/base/       # Clusters backend
│   ├── metaverses-frt/base/     # Metaverses frontend
│   ├── metaverses-srv/base/     # Metaverses backend
│   ├── spaces-frt/base/         # Spaces frontend
│   ├── spaces-srv/base/         # Spaces backend
│   ├── uniks-frt/base/          # Uniks frontend
│   ├── uniks-srv/base/          # Uniks backend
│   ├── auth-frt/base/           # Authentication frontend
│   ├── auth-srv/base/           # Authentication backend
│   ├── profile-frt/base/        # User profiles frontend
│   └── profile-srv/base/        # User profiles backend
│
└── Shared/Utility Packages
    ├── universo-types/base/     # Common GDScript types
    ├── universo-utils/base/     # Common utilities
    ├── universo-i18n/base/      # Internationalization
    ├── universo-api-client/base/# API client library
    └── universo-resources/base/ # Shared Godot resources
```

## Key Patterns Identified

### 1. Consistent Naming Convention

**React Pattern**:
- Frontend packages: `{feature}-frt`
- Backend packages: `{feature}-srv`
- Shared packages: `universo-{name}` (no suffix)

**Godot Adaptation**:
- ✅ Same naming convention
- ✅ Add `base/` subdirectory in each package
- ✅ Replace `package.json` with `plugin.cfg`

### 2. Shared Entity Packages

**React Implementation**: `universo-types` package
- Contains TypeScript interfaces and types shared across packages
- Prevents code duplication
- Single source of truth for data structures

**Key Shared Entities**:
```typescript
// From universo-types package (conceptual)
- User
- Session
- Role
- Permission
- Cluster
- Domain
- Resource
- Metaverse
- Section
- Entity
- Space
- Canvas
- Node
```

**Godot Adaptation**: `packages/universo-types/base/`
- Convert TypeScript interfaces to GDScript classes (extends Resource)
- Use Godot's type system with `@export` annotations
- Follow same entity structure as React version

### 3. Feature Package Structure Pattern

**React Version** (example: clusters-frt):
```
packages/clusters-frt/
├── package.json           # NPM package manifest
├── tsconfig.json          # TypeScript configuration
├── README.md              # English documentation
├── README-RU.md          # Russian documentation
├── src/
│   ├── components/        # React components
│   ├── hooks/             # React hooks
│   ├── services/          # API service layer
│   ├── types/             # Local types
│   └── index.ts           # Package entry point
└── __tests__/             # Tests
```

**Godot Adaptation** (example: clusters-frt):
```
packages/clusters-frt/base/
├── plugin.cfg             # Godot plugin manifest
├── plugin.gd              # Plugin entry point
├── README.md              # English documentation
├── README-RU.md          # Russian documentation
├── scenes/                # Godot scenes (UI)
├── scripts/               # GDScript files (logic)
│   ├── cluster_list.gd
│   ├── cluster_detail.gd
│   └── cluster_service.gd
├── resources/             # Godot resources (.tres)
└── tests/                 # GUT tests
```

### 4. Documentation Standards

**React Implementation**:
- ✅ Every package has README.md (English)
- ✅ Every package has README-RU.md (Russian, exact structural parity)
- ✅ Template files for new packages (TEMPLATE-README.md)
- ✅ Guide for using templates (TEMPLATE-README-GUIDE.md)
- ✅ Main packages/README.md documenting all packages

**Godot Should Adopt**:
- ✅ Same bilingual documentation requirement
- ✅ Create package README template for Godot
- ✅ Create packages/README.md overview document
- ✅ Maintain exact structural parity between English and Russian

### 5. Shared Package Examples

#### universo-types (React)
**Purpose**: Common TypeScript types and interfaces

**Godot Equivalent**: packages/universo-types/base/
```
packages/universo-types/base/
├── plugin.cfg
├── plugin.gd
├── scripts/
│   ├── user.gd            # User resource class
│   ├── session.gd         # Session class
│   ├── role.gd            # Role resource class
│   ├── permission.gd      # Permission resource class
│   ├── cluster.gd         # Cluster resource class
│   ├── domain.gd          # Domain resource class
│   └── resource.gd        # Resource resource class (rename to cluster_resource.gd)
├── README.md
└── README-RU.md
```

#### universo-utils (React)
**Purpose**: Common utility functions

**Godot Equivalent**: packages/universo-utils/base/
```
packages/universo-utils/base/
├── plugin.cfg
├── plugin.gd
├── scripts/
│   ├── validator.gd       # Validation utilities
│   ├── logger.gd          # Logging utilities
│   ├── crypto.gd          # Cryptographic utilities
│   ├── date_utils.gd      # Date/time utilities
│   └── string_utils.gd    # String manipulation
├── README.md
└── README-RU.md
```

#### universo-api-client (React)
**Purpose**: API client library for making HTTP requests

**Godot Equivalent**: packages/universo-api-client/base/
```
packages/universo-api-client/base/
├── plugin.cfg
├── plugin.gd
├── scripts/
│   ├── api_client.gd      # Base API client
│   ├── clusters_api.gd    # Clusters API endpoints
│   ├── auth_api.gd        # Auth API endpoints
│   └── request_builder.gd # HTTP request builder
├── README.md
└── README-RU.md
```

## Feature Comparison Matrix

| Feature | React Packages | Godot Packages (Target) | Priority |
|---------|----------------|------------------------|----------|
| Clusters | ✅ clusters-frt, clusters-srv | ✅ clusters-frt, clusters-srv | P0 (CURRENT) |
| Metaverses | ✅ metaverses-frt, metaverses-srv | 🔜 metaverses-frt, metaverses-srv | P1 |
| Spaces | ✅ spaces-frt, spaces-srv | 🔜 spaces-frt, spaces-srv | P1 |
| Uniks | ✅ uniks-frt, uniks-srv | 🔜 uniks-frt, uniks-srv | P2 |
| Authentication | ✅ auth-frt, auth-srv | 🔜 auth-frt, auth-srv | P1 |
| User Profiles | ✅ profile-frt, profile-srv | 🔜 profile-frt, profile-srv | P2 |
| Projects | ✅ projects-frt, projects-srv | 🔜 projects-frt, projects-srv | P3 |
| Publishing | ✅ publish-frt, publish-srv | 🔜 publish-frt, publish-srv | P3 |
| Space Builder | ✅ space-builder-frt, space-builder-srv | 🔜 space-builder-frt, space-builder-srv | P2 |
| Types (shared) | ✅ universo-types | 🔜 universo-types | P0 (HIGH) |
| Utils (shared) | ✅ universo-utils | 🔜 universo-utils | P0 (HIGH) |
| API Client | ✅ universo-api-client | 🔜 universo-api-client | P1 |
| i18n | ✅ universo-i18n | 🔜 universo-i18n | P2 |
| Analytics | ✅ analytics-frt | 🔜 analytics-frt | P3 |
| UPDL | ✅ updl | 🔜 updl | P2 |

Legend:
- ✅ Implemented
- 🔜 Planned
- P0: Critical priority (foundation)
- P1: High priority (core features)
- P2: Medium priority (extended features)
- P3: Low priority (future enhancements)

## Technology Stack Mapping

| Aspect | React Version | Godot Version | Notes |
|--------|---------------|---------------|-------|
| **Package Manager** | PNPM workspaces | Godot addon system | Native Godot plugins |
| **Package Manifest** | package.json | plugin.cfg | Similar metadata |
| **Language** | TypeScript | GDScript | Statically typed |
| **Frontend** | React components | Godot scenes | UI paradigm shift |
| **Backend** | Express.js | GDScript HTTP server | Full-stack GDScript |
| **Database** | Supabase | Supabase | Same (with abstraction) |
| **Authentication** | Passport.js | JWT library | Similar strategy pattern |
| **Testing** | Jest/Vitest | GUT | Unit testing framework |
| **Build** | Vite/Turbo | Godot export | Different approach |
| **Types** | TypeScript interfaces | GDScript classes (extends Resource) | Resource-based |

## Lessons Learned from React Version

### What Worked Well ✅

1. **Clear Package Separation**: -frt/-srv naming makes structure immediately understandable
2. **Shared Packages**: universo-types, universo-utils prevent code duplication
3. **Bilingual Documentation**: Exact parity between English and Russian maintains consistency
4. **Template Files**: TEMPLATE-README.md speeds up new package creation
5. **Monorepo Structure**: Atomic commits across packages, easier refactoring

### What to Avoid ❌

1. **Legacy Code Not Refactored**: Flowise packages still present (technical debt)
2. **Inconsistent Documentation**: Some packages missing full docs
3. **Missing Tests**: Not all packages have comprehensive test coverage

### Godot-Specific Considerations

1. **No External Package Manager**: Use Godot's native addon system (simpler)
2. **Scene-Based UI**: Leverage Godot's scene tree (different paradigm from React)
3. **Resource System**: Use Godot resources for data models (built-in serialization)
4. **Signal-Based Events**: Use Godot signals for inter-package communication
5. **Plugin Dependencies**: Document in plugin.cfg [dependencies] section

## Implementation Recommendations

### Immediate Actions (P0)

1. **Create Shared Packages**:
   - [ ] `packages/universo-types/base/` - Common data models
   - [ ] `packages/universo-utils/base/` - Utility functions

2. **Document Existing Packages**:
   - [ ] Add README.md to clusters-srv
   - [ ] Add README-RU.md to clusters-srv

3. **Create Package Templates**:
   - [ ] Create TEMPLATE-README.md for Godot packages
   - [ ] Create packages/README.md overview document

### Next Features (P1)

1. **Authentication Packages**:
   - [ ] `packages/auth-frt/base/` - Login/logout UI
   - [ ] `packages/auth-srv/base/` - JWT authentication

2. **Metaverses Packages**:
   - [ ] `packages/metaverses-frt/base/` - Metaverse UI
   - [ ] `packages/metaverses-srv/base/` - Metaverse backend

### Best Practices Going Forward

1. **Always create both -frt and -srv packages** for features needing UI and backend
2. **Always include bilingual documentation** with exact structural parity
3. **Always use base/ subdirectory** for core implementation
4. **Always create plugin.cfg and plugin.gd** following Godot conventions
5. **Always extract shared code** into dedicated packages when used by 2+ packages
6. **Always reference React version** for feature requirements and entity structures

## Conclusion

The Universo Platformo React repository demonstrates excellent modular architecture with clear package separation and comprehensive shared packages. The Godot version should adopt the same organizational principles while adapting to Godot's native addon system and scene-based paradigm.

**Key Takeaway**: The package-based structure is proven and scalable. Focus on:
1. Creating shared packages (universo-types, universo-utils) immediately
2. Following the established -frt/-srv naming convention
3. Maintaining bilingual documentation
4. Learning from React version's entity structures
5. Adapting patterns to Godot's strengths (scenes, resources, signals)

---

**Analysis Date**: 2025-11-17  
**React Repository**: https://github.com/teknokomo/universo-platformo-react  
**Godot Repository**: https://github.com/teknokomo/universo-platformo-godot  
**Next Update**: After implementing first shared packages
