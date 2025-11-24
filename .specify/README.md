# .specify - SpecKit Documentation Directory

This directory contains all project specifications, development principles, and documentation following the SpecKit standard.

## Directory Structure

```
.specify/
├── features/              # Feature specifications (also accessible via specs/ symlink)
├── memory/                # Project memory and documentation
├── templates/             # Specification templates
├── scripts/               # Utility scripts
└── specs -> features      # Symlink for backward compatibility
```

## Features (specs/)

Contains all feature specifications organized by numeric prefix:

- `001-project-setup/` - Initial project setup and infrastructure
- Future features will follow the pattern: `NNN-feature-name/`

Each feature directory contains:
- `spec.md` - Main feature specification
- `tasks.md` - Implementation tasks
- `plan.md` - Technical implementation plan
- `data-model.md` - Data models and entities
- `contracts/` - API contracts and interfaces
- `quickstart.md` - Quick start guide
- `research.md` - Research notes and decisions
- `checklists/` - Completion and quality checklists

## Memory

Project institutional knowledge:

### `constitution.md`
Core development principles (NON-NEGOTIABLE):
- I. Godot-Native Architecture
- II. Package-Based Modularity
- III. Bilingual Documentation (English/Russian)
- IV. Test-First Development
- V. Database Abstraction
- VI. Progressive Feature Development
- VII. GDScript Best Practices
- VIII. Security-First Design

**Version:** 1.2.0 | **Last Amended:** 2025-11-17

### `reference/`
Reference documentation from universo-platformo-react:
- Best practices implementation
- Feature parity analysis
- React/Godot comparison guides

### `archive/`
Historical summaries and status reports

### `REORGANIZATION_SUMMARY.md`
Documentation reorganization details (2025-11-24)

## Templates

Specification templates for creating new features:
- `spec-template.md` - Feature specification template
- `tasks-template.md` - Implementation tasks template
- `plan-template.md` - Technical plan template
- `checklist-template.md` - Quality checklist template
- `agent-file-template.md` - Custom agent template

## Scripts

Utility scripts for SpecKit workflow:
- `bash/check-prerequisites.sh` - Validate feature prerequisites
- `bash/common.sh` - Shared functions for all scripts
- `bash/create-new-feature.sh` - Create new feature directory
- `bash/setup-plan.sh` - Initialize feature planning
- `bash/update-agent-context.sh` - Update agent context

## Using SpecKit

### For New Features

1. Create feature specification:
   ```bash
   /speckit.specify
   ```

2. Create implementation plan:
   ```bash
   /speckit.plan
   ```

3. Generate implementation tasks:
   ```bash
   /speckit.tasks
   ```

4. Implement the feature:
   ```bash
   /speckit.implement
   ```

### For Analysis

Analyze specification consistency:
```bash
/speckit.analyze
```

### For Constitution Updates

Update development principles:
```bash
/speckit.constitution
```

## Important Notes

1. **Branch Naming**: Feature branches must follow the pattern `NNN-feature-name` where NNN is the feature number (e.g., `001-project-setup`, `002-user-authentication`)

2. **Constitution Authority**: The constitution is NON-NEGOTIABLE. Any conflicts must be resolved by updating specifications, not by ignoring principles.

3. **Bilingual Documentation**: ALL documentation must be provided in both English and Russian with exact structural parity.

4. **Package-Based Structure**: ALL functionality must be implemented in `packages/` directory. No exceptions.

## Agent Integration

All GitHub Copilot agents are configured to work with this `.specify/` structure:

- **speckit.specify** - Create feature specifications
- **speckit.plan** - Generate technical plans
- **speckit.tasks** - Create implementation tasks
- **speckit.implement** - Execute implementation
- **speckit.analyze** - Validate consistency
- **speckit.constitution** - Update principles
- **speckit.clarify** - Clarify specifications
- **speckit.checklist** - Manage checklists
- **speckit.taskstoissues** - Convert tasks to issues

See `.github/agents/` for agent configurations.

## Migration from Old Structure

If you have references to the old `specs/` directory at the repository root:

- **Old path**: `specs/NNN-feature-name/`
- **New path**: `.specify/specs/NNN-feature-name/` (or `.specify/features/NNN-feature-name/`)

A symlink at `.specify/specs -> features` maintains backward compatibility.

See `REORGANIZATION_SUMMARY.md` for full migration details.

## Getting Help

- Review templates in `templates/` for examples
- Check the constitution for development principles
- Use SpecKit agents via GitHub Copilot commands (`/speckit.*`)
- See main repository documentation: `../README.md`, `../ARCHITECTURE.md`, `../CONTRIBUTING.md`
