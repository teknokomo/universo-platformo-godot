# Deprecated: Specifications Directory

> **⚠️ This directory is deprecated.**  
> All specifications have been moved to `.specify/specs/` (or `.specify/features/`)

## Migration Notice

As of November 2024, the project has reorganized its documentation to follow the SpecKit standard structure:

- **Old location**: `specs/`
- **New location**: `.specify/specs/` (symlink to `.specify/features/`)

## New Structure

```
.specify/
├── features/           # Feature specifications (accessed via .specify/specs/ symlink)
│   └── 001-project-setup/
│       ├── spec.md         # Feature specification
│       ├── tasks.md        # Implementation tasks
│       ├── plan.md         # Technical plan
│       ├── data-model.md   # Data models
│       ├── quickstart.md   # Quick start guide
│       ├── research.md     # Research notes
│       └── contracts/      # API contracts
├── memory/
│   ├── constitution.md     # Development principles
│   ├── archive/            # Historical summaries
│   └── reference/          # Reference documentation
├── templates/              # Specification templates
└── scripts/                # Utility scripts
```

## What to Do

If you have scripts or references pointing to `specs/`, update them to use `.specify/specs/` instead.

For more information about the SpecKit structure, see the [SpecKit documentation](../.github/agents/).
