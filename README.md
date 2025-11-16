# Universo Platformo Godot

**Implementation of Universo Platformo / Universo MMOOMM / Universo Kiberplano built on Godot Engine and GDScript**

## Overview

Universo Platformo Godot is a full-stack implementation of the Universo Platformo concept using [Godot Engine](https://godotengine.org/) and GDScript. This project provides a modular, extensible platform for creating metaverse applications, multiplayer experiences, and collaborative digital spaces.

This implementation follows the architectural patterns established in [Universo Platformo React](https://github.com/teknokomo/universo-platformo-react) but adapted for the Godot ecosystem, leveraging GDScript for both frontend and backend functionality.

## Key Features

- **Full-Stack GDScript**: Both client and server components written in GDScript
- **Modular Architecture**: Package-based structure with clear separation of concerns
- **Multiplayer Ready**: Built-in support for networking and real-time collaboration
- **Database Integration**: Supabase support with extensibility for other databases
- **Extensible Design**: Base implementations allow for multiple technology stack variations
- **Bilingual Documentation**: Complete documentation in English and Russian

## Project Structure

```
universo-platformo-godot/
├── addons/                 # Third-party Godot plugins and tools
├── packages/               # Core application packages
│   ├── clusters-frt/      # Clusters frontend (client-side)
│   │   └── base/          # Base implementation
│   ├── clusters-srv/      # Clusters server (backend)
│   │   └── base/          # Base implementation
│   ├── metaverses-frt/    # Metaverses frontend
│   │   └── base/
│   ├── metaverses-srv/    # Metaverses server
│   │   └── base/
│   └── ...                # Other feature packages
├── scenes/                 # Main Godot scenes
├── scripts/                # Shared utility scripts
├── assets/                 # Shared assets (sprites, audio, fonts)
├── themes/                 # UI themes and styles
├── translations/           # Internationalization files
├── .github/                # GitHub workflows and documentation
├── .specify/               # Specification and planning tools
├── project.godot           # Godot project configuration
├── README.md               # This file (English)
└── README-RU.md           # Russian version
```

## Package Organization

Each feature in Universo Platformo is organized into packages with frontend (`-frt`) and server (`-srv`) components:

### Package Naming Convention
- `{feature}-frt/` - Frontend/client-side implementation
- `{feature}-srv/` - Backend/server-side implementation

### Base Implementation
Each package contains a `base/` directory for the primary implementation. This structure allows for future alternative implementations while maintaining backward compatibility.

Example structure for the Clusters feature:
```
packages/clusters-frt/base/
├── scenes/              # UI scenes for clusters
├── scripts/             # Client-side logic
└── plugin.cfg           # Godot addon configuration

packages/clusters-srv/base/
├── scripts/             # Server-side logic
├── api/                 # REST API endpoints
└── plugin.cfg           # Godot addon configuration
```

## Core Features

### Clusters System
Manages infrastructure and resource organization through three main entities:
- **Clusters**: Top-level organizational units
- **Domains**: Logical groupings within clusters
- **Resources**: Individual assets and components

### Metaverses System
Handles virtual world creation and management:
- **Metaverses**: Virtual environment containers
- **Sections**: Subdivisions within metaverses
- **Entities**: Objects and actors in the metaverse

### Spaces & Canvases
Advanced features for collaborative work:
- **Spaces**: Shared workspaces for teams
- **Canvases**: Visual programming interfaces
- **Nodes**: LangChain graph implementation
- **UPDL Nodes**: Custom Universo Platform Definition Language nodes

### Uniks System
Unique resource management with extended entity hierarchy

## Technology Stack

### Core Technologies
- **Engine**: Godot 4.x (latest stable version)
- **Language**: GDScript
- **Networking**: Godot's high-level multiplayer API
- **HTTP Server**: Custom GDScript REST API implementation

### Database & Backend
- **Primary Database**: Supabase
- **Authentication**: Custom authentication system (GDScript implementation)
- **API Architecture**: RESTful endpoints using GDScript HTTP server

### Future Extensions
- Support for additional databases (PostgreSQL, MongoDB, etc.)
- Enhanced authentication methods
- Expanded API capabilities

## Getting Started

### Prerequisites
- Godot Engine 4.x (latest stable version)
- Git for version control
- Supabase account (for database functionality)

### Installation

1. Clone the repository:
```bash
git clone https://github.com/teknokomo/universo-platformo-godot.git
cd universo-platformo-godot
```

2. Open the project in Godot:
```bash
godot --editor project.godot
```

3. Configure environment variables:
   - Copy `.env.example` to `.env`
   - Add your Supabase credentials
   - Configure other required settings

4. Enable required addons:
   - Open Project Settings → Plugins
   - Enable all required Universo Platformo addons

### Running the Application

**Client Mode:**
```bash
godot --path . scenes/main.tscn
```

**Server Mode (Headless):**
```bash
godot --headless --path . scenes/server.tscn
```

**Development Mode:**
Open the project in Godot Editor and press F5 to run

## Development Workflow

### Creating New Features

1. Create a specification using `/speckit.specify` command
2. Create a GitHub Issue following `.github/instructions/github-issues.md`
3. Apply appropriate labels per `.github/instructions/github-labels.md`
4. Create feature branch and implement
5. Create Pull Request following `.github/instructions/github-pr.md`

### Package Development

When creating a new package:

1. Create package directories:
```bash
mkdir -p packages/{feature}-frt/base
mkdir -p packages/{feature}-srv/base
```

2. Add `plugin.cfg` to each package base directory
3. Implement frontend scenes and scripts in `-frt/base/`
4. Implement backend logic in `-srv/base/`
5. Document the package in its own README files

### Documentation Standards

All documentation must follow the bilingual standard:
1. Create English documentation first (e.g., `README.md`)
2. Create identical Russian version (e.g., `README-RU.md`)
3. Ensure both versions have the same structure and line count
4. Follow guidelines in `.github/instructions/i18n-docs.md`

## Architecture Principles

### What We Follow from React Version
- Monorepo structure with package-based organization
- Frontend/backend separation within features
- Base implementation folders for future extensibility
- Supabase as primary database
- Bilingual documentation approach

### Godot-Specific Adaptations
- Addon/plugin system instead of npm packages
- GDScript for both client and server
- Godot scenes for UI components
- Native Godot networking for multiplayer
- Custom HTTP server for REST API

### What We Don't Include
- Documentation folder (`docs/`) - will be in separate repository
- AI agent rules folders - created by user as needed
- Legacy code from other implementations
- Non-essential development files

## Contributing

### Before Contributing
1. Read this README and the Russian version (README-RU.md)
2. Review existing issues and pull requests
3. Check the project specifications in `.specify/`
4. Understand the labeling system in `.github/instructions/github-labels.md`

### Contribution Process
1. Create or claim an issue
2. Fork the repository
3. Create a feature branch
4. Implement changes following our standards
5. Test thoroughly
6. Submit a pull request with complete documentation
7. Ensure both English and Russian docs are updated

## Project Status

This project is in active development. We are currently in the foundation phase, setting up:
- [ ] Basic repository structure
- [ ] Core package architecture
- [ ] Godot project configuration
- [ ] First feature implementation (Clusters)
- [ ] Database integration layer
- [ ] Authentication system

Check the [Issues](https://github.com/teknokomo/universo-platformo-godot/issues) page for current tasks and progress.

## Related Projects

- [Universo Platformo React](https://github.com/teknokomo/universo-platformo-react) - React/Express implementation (reference implementation)
- Documentation site: `docs.universo.pro` (coming soon)

## License

[License information to be added]

## Community & Support

- **Issues**: [GitHub Issues](https://github.com/teknokomo/universo-platformo-godot/issues)
- **Discussions**: [GitHub Discussions](https://github.com/teknokomo/universo-platformo-godot/discussions)
- **Documentation**: Coming soon at docs.universo.pro

## Acknowledgments

This project builds upon the concepts established in Universo Platformo React and adapts them for the Godot Engine ecosystem. Special thanks to all contributors and the Godot community for their excellent tools and resources.
