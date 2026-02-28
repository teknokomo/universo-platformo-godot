# Start Frontend Package

## Overview

The Start Frontend package provides the entry-point start page for Universo Platformo. It implements the equivalent of the React-based `start-frontend/base` package, adapted for Godot 4.6 and GDScript.

## Features

- **Guest Start Page** — landing page for unauthenticated users with sign-in and sign-up forms
- **Authenticated Start Page** — welcome page for signed-in users with sign-out functionality
- **Supabase Authentication** — connection to Supabase via HTTP REST API (through the `AuthManager` autoload)
- **Session Persistence** — auth session is saved locally and restored on next launch

## Structure

```
packages/start-frt/base/
├── scenes/
│   ├── guest_start_page.tscn        # Landing page for non-authenticated users
│   └── authenticated_start_page.tscn  # Page for authenticated users
├── scripts/
│   ├── guest_start_page.gd          # Guest page logic (sign-in / sign-up)
│   └── authenticated_start_page.gd  # Authenticated page logic (sign-out)
├── plugin.cfg                       # Plugin configuration
├── plugin.gd                        # Plugin entry point
├── README.md                        # This file (English)
└── README-RU.md                     # Russian version
```

## Architecture

The start page routing is handled by `scenes/main.tscn` and `scenes/main.gd`, which:

1. Show a loading screen during auth state check
2. Display `GuestStartPage` for unauthenticated users
3. Display `AuthenticatedStartPage` for authenticated users
4. React to `AuthManager.auth_state_changed` signal to switch views

The `AuthManager` autoload (`scripts/autoload/auth_manager.gd`) manages all Supabase authentication:
- Signs in via `POST /auth/v1/token?grant_type=password`
- Signs up via `POST /auth/v1/signup`
- Signs out via `POST /auth/v1/logout`
- Persists session in `user://session.json`

## Installation

This package is part of the Universo Platformo Godot monorepo. The start page scenes are loaded by `scenes/main.tscn`.

### Configure Supabase Credentials

1. Copy `.env.example` to `.env` in the project root
2. Set your Supabase project URL and anon key:

```env
SUPABASE_URL=https://your-project.supabase.co
SUPABASE_KEY=your-anon-key-here
```

### Enable the Plugin (optional)

1. Open Project Settings → Plugins
2. Find "Start Frontend" in the list
3. Enable the plugin

## Usage

### Sign In

The `GuestStartPage` handles sign-in automatically when the user submits the form. You can also call `AuthManager` directly:

```gdscript
AuthManager.sign_in("user@example.com", "password123")
AuthManager.signed_in.connect(func(user): print("Signed in: ", user.get("email")))
AuthManager.sign_in_failed.connect(func(error): print("Failed: ", error))
```

### Sign Up

```gdscript
AuthManager.sign_up("newuser@example.com", "password123")
```

### Sign Out

```gdscript
AuthManager.sign_out()
AuthManager.signed_out.connect(func(): print("Signed out"))
```

### Check Auth State

```gdscript
if AuthManager.is_authenticated:
    var user = AuthManager.get_user()
    print("Logged in as: ", user.get("email"))
```

## Integration

This package integrates with:
- **AuthManager autoload** — `scripts/autoload/auth_manager.gd` (routes calls to backend)
- **BackendServer autoload** — `scripts/autoload/backend_server.gd` (proxies to Supabase)
- **Main scene** — `scenes/main.tscn` / `scenes/main.gd`

## Dependencies

- Godot Engine 4.3+
- `BACKEND_PORT` configured in `.env` (default: `8080`)
- `start-srv` package running (provides the backend API)

## Contributing

See the main project [CONTRIBUTING.md](../../../CONTRIBUTING.md) for contribution guidelines.

## License

[License information to be added]
