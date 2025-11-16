# Contributing to Universo Platformo Godot

Thank you for your interest in contributing to Universo Platformo Godot! This guide will help you get started with contributing to this project.

## Table of Contents

- [Getting Started](#getting-started)
- [Development Workflow](#development-workflow)
- [Coding Standards](#coding-standards)
- [Documentation Standards](#documentation-standards)
- [Issue Guidelines](#issue-guidelines)
- [Pull Request Guidelines](#pull-request-guidelines)
- [Package Development](#package-development)
- [Testing](#testing)

## Getting Started

### Prerequisites

Before contributing, ensure you have:

1. **Godot Engine 4.x** (latest stable version)
2. **Git** for version control
3. **Supabase account** (for database features)
4. Basic knowledge of GDScript
5. Familiarity with the Godot Editor

### Setting Up Your Development Environment

1. Fork the repository on GitHub
2. Clone your fork locally:
```bash
git clone https://github.com/YOUR_USERNAME/universo-platformo-godot.git
cd universo-platformo-godot
```

3. Add the upstream repository:
```bash
git remote add upstream https://github.com/teknokomo/universo-platformo-godot.git
```

4. Copy the environment file and configure:
```bash
cp .env.example .env
# Edit .env with your Supabase credentials
```

5. Open the project in Godot Editor:
```bash
godot --editor project.godot
```

## Development Workflow

### 1. Find or Create an Issue

- Browse existing [Issues](https://github.com/teknokomo/universo-platformo-godot/issues)
- If creating a new issue, follow [Issue Guidelines](#issue-guidelines)
- Comment on the issue to claim it before starting work

### 2. Create a Feature Branch

```bash
git checkout -b feature/your-feature-name
```

Branch naming conventions:
- `feature/feature-name` - New features
- `fix/bug-description` - Bug fixes
- `docs/update-description` - Documentation updates
- `refactor/component-name` - Code refactoring

### 3. Make Your Changes

- Follow our [Coding Standards](#coding-standards)
- Write clean, documented code
- Test your changes thoroughly
- Commit frequently with clear messages

### 4. Keep Your Branch Updated

```bash
git fetch upstream
git rebase upstream/main
```

### 5. Submit a Pull Request

- Push your branch to your fork
- Create a Pull Request following [PR Guidelines](#pull-request-guidelines)
- Wait for review and address feedback

## Coding Standards

### GDScript Style Guide

We follow the [official Godot GDScript style guide](https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_styleguide.html) with these additions:

#### File Organization

```gdscript
extends Node
## Brief description of the class
##
## Detailed description providing context and usage information.
## Multiple paragraphs are allowed.

# Constants first
const MAX_SPEED := 100
const DEFAULT_NAME := "Player"

# Enums
enum State { IDLE, RUNNING, JUMPING }

# Exported variables
@export var speed := 50.0
@export var health := 100

# Public variables
var is_alive := true
var score := 0

# Private variables (prefixed with underscore)
var _internal_state := State.IDLE

# Onready variables
@onready var sprite: Sprite2D = $Sprite2D

# Signals
signal health_changed(new_health: int)
signal player_died

# Built-in virtual methods
func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pass

# Public methods
func take_damage(amount: int) -> void:
	health -= amount
	health_changed.emit(health)

# Private methods
func _update_internal_state() -> void:
	pass
```

#### Naming Conventions

- **Variables**: `snake_case`
- **Constants**: `UPPER_CASE`
- **Functions**: `snake_case`
- **Classes**: `PascalCase`
- **Signals**: `snake_case`
- **Private members**: `_prefixed_with_underscore`

#### Type Hints

Always use type hints for better performance and error detection:

```gdscript
func calculate_damage(base_damage: int, multiplier: float) -> int:
	return int(base_damage * multiplier)
```

#### Documentation

Use `##` for documentation comments that appear in the editor:

```gdscript
## Calculates the total damage with modifiers
##
## Takes the base damage and applies multipliers and resistances
## to calculate the final damage value.
##
## @param base_damage The initial damage value
## @param multiplier Damage multiplier (1.0 = no change)
## @return The final calculated damage
func calculate_damage(base_damage: int, multiplier: float) -> int:
	return int(base_damage * multiplier)
```

### Scene Organization

- One main scene per feature/component
- Group related nodes logically
- Use descriptive node names
- Follow the project directory structure

### File Structure

```
packages/{feature}/base/
├── scenes/           # Scene files (.tscn)
├── scripts/          # GDScript files (.gd)
├── resources/        # Resource files (.tres, .res)
├── assets/           # Feature-specific assets
├── plugin.cfg        # Plugin configuration
├── plugin.gd         # Plugin entry point
├── README.md         # English documentation
└── README-RU.md     # Russian documentation
```

## Documentation Standards

### Bilingual Documentation

All documentation must be provided in both English and Russian:

1. **Create English version first** (e.g., `README.md`)
2. **Create identical Russian version** (e.g., `README-RU.md`)
3. **Maintain same structure and line count** in both versions
4. Follow guidelines in `.github/instructions/i18n-docs.md`

### Documentation Requirements

Every package must include:
- `README.md` - English documentation
- `README-RU.md` - Russian documentation (identical structure)
- Code comments for public APIs
- Usage examples
- Integration guidelines

### Comment Style

```gdscript
## Public function documentation
## Multiple lines are allowed
func public_function() -> void:
	pass

# Private implementation comment
func _private_function() -> void:
	# Inline comment explaining complex logic
	var result = complex_calculation()
```

## Issue Guidelines

When creating issues, follow `.github/instructions/github-issues.md`:

### Issue Template

```markdown
# Title in English

Description in English

<details>
<summary>In Russian</summary>

# Заголовок на русском

Описание на русском
</details>
```

### Required Labels

Apply appropriate labels according to `.github/instructions/github-labels.md`:

- **Type**: `feature`, `bug`, `enhancement`, `documentation`
- **Area**: `frontend`, `backend`, `platformo`, `repository`
- **Specific**: `clusters`, `metaverses`, `spaces`, etc.

## Pull Request Guidelines

Follow `.github/instructions/github-pr.md` when creating PRs:

### PR Title Format

```
GH{issue_number} Brief description of changes
```

Example: `GH45 Add cluster management UI`

### PR Description Template

```markdown
Fixes #123

# Description

Brief description of changes made.

## Changes Made

- Specific change 1
- Specific change 2
- Specific change 3

## Additional Work

- Documentation updates
- Test additions
- Configuration changes

## Testing

- [ ] Manual testing completed
- [ ] Automated tests pass
- [ ] No breaking changes introduced

<details>
<summary>In Russian</summary>

Исправляет #123

# Описание

Краткое описание внесенных изменений.

## Внесенные изменения

- Конкретное изменение 1
- Конкретное изменение 2
- Конкретное изменение 3

## Дополнительная работа

- Обновления документации
- Добавление тестов
- Изменения конфигурации

## Тестирование

- [ ] Ручное тестирование завершено
- [ ] Автоматические тесты проходят
- [ ] Не внесено критических изменений
</details>
```

## Package Development

### Creating a New Package

1. **Create directory structure**:
```bash
mkdir -p packages/{feature}-frt/base/{scenes,scripts}
mkdir -p packages/{feature}-srv/base/{scripts,api}
```

2. **Add plugin configuration** (`plugin.cfg`):
```ini
[plugin]

name="Feature Name"
description="Description of the feature"
author="Universo Platformo"
version="0.1.0"
script="plugin.gd"
```

3. **Create plugin entry point** (`plugin.gd`):
```gdscript
@tool
extends EditorPlugin

func _enter_tree() -> void:
	print("Feature Plugin: Enabled")

func _exit_tree() -> void:
	print("Feature Plugin: Disabled")
```

4. **Add README files**:
   - Create `README.md` (English)
   - Create `README-RU.md` (Russian, identical structure)

5. **Implement functionality**:
   - Add scenes in `scenes/`
   - Add scripts in `scripts/`
   - Document all public APIs

### Package Integration

Packages integrate through:
- **Autoloads**: Global managers (Config, DatabaseManager, NetworkManager)
- **Signals**: Event-driven communication
- **Direct references**: When appropriate

## Testing

### Manual Testing

1. Open project in Godot Editor
2. Enable your plugin in Project Settings → Plugins
3. Test functionality through the UI
4. Verify network features in client/server mode
5. Check database operations

### Running Test Scenes

```bash
godot --path . scenes/your_test_scene.tscn
```

### Server Mode Testing

```bash
godot --headless --path . scenes/server.tscn
```

## Code Review Process

1. Submit your PR with complete documentation
2. Automated checks will run
3. Maintainers will review your code
4. Address feedback promptly
5. Once approved, your PR will be merged

## Questions or Issues?

- Open a discussion on GitHub Discussions
- Ask in issue comments
- Review existing documentation and code

## License

By contributing, you agree that your contributions will be licensed under the same license as the project.

---

Thank you for contributing to Universo Platformo Godot!
