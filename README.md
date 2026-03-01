# Universo Platformo Godot

**Implementation of Universo Platformo built on Godot Engine 4 and GDScript.**

## Overview

Universo Platformo Godot is a full-stack Godot 4 implementation of the Universo Platformo
concept, providing a modular platform for metaverse applications, multiplayer experiences,
and collaborative digital spaces. Both frontend and backend components are written in GDScript.

This project follows the architectural patterns of
[Universo Platformo React](https://github.com/teknokomo/universo-platformo-react),
adapted for the Godot engine ecosystem.

## Key Features

- **Full-Stack GDScript**: Both client UI and backend server written in GDScript
- **Backend-as-Proxy for Supabase**: The frontend never calls Supabase directly;
  all authentication operations go through the built-in GDScript backend server
- **Modular Package Architecture**: Features organized in `-frt` (frontend) and `-srv`
  (backend) packages under the `packages/` directory
- **Start Pages**: Guest landing page (sign-in / sign-up) and authenticated welcome page,
  routing based on Supabase auth state via the `AuthManager` autoload
- **Session Persistence**: Auth session stored locally in `user://session.json`
- **Bilingual Documentation**: Complete documentation in English and Russian

## Architecture

All Supabase access goes through the local backend server. The frontend (`start-frt`)
communicates only with the backend (`start-srv`), which holds Supabase credentials:

```
[Frontend — start-frt]          [Backend — start-srv]        [Supabase Cloud]
  AuthManager autoload    →    BackendServer + AuthAPI   →   REST Auth API
  no SUPABASE_URL/KEY           holds SUPABASE_URL/KEY        (external)
  calls http://127.0.0.1:8080   proxies to Supabase
```

The backend starts as the `BackendServer` autoload, which runs a lightweight HTTP server
accepting requests from the frontend on `127.0.0.1:8080` (configurable via `BACKEND_PORT`).

## Project Structure

```
universo-platformo-godot/
├── packages/
│   ├── start-frt/base/          # Start page frontend
│   │   ├── scenes/              #   Guest and authenticated page scenes
│   │   └── scripts/             #   Page controller scripts
│   ├── start-srv/base/          # Start page backend
│   │   └── scripts/             #   HTTP server + Auth API proxy to Supabase
│   ├── clusters-frt/base/       # Clusters frontend (UI plugin stub)
│   └── clusters-srv/base/       # Clusters backend (logic plugin stub)
├── scenes/
│   └── main.tscn                # Main scene — auth-routing entry point
├── scripts/
│   └── autoload/
│       ├── config.gd            #   Reads .env and config.json
│       ├── database_manager.gd  #   Database interface (Supabase)
│       ├── network_manager.gd   #   Godot ENet multiplayer networking
│       ├── backend_server.gd    #   Starts local HTTP backend server
│       └── auth_manager.gd      #   Frontend auth state (calls backend)
├── .env.example                 # Environment variable template
├── config.json                  # Application feature configuration
└── project.godot                # Godot project configuration
```

## Packages

### start-frt — Start Page Frontend

Guest landing page with email/password sign-in and sign-up forms. Authenticated
welcome page displaying user info and a sign-out button. `scenes/main.tscn` routes
between them using `AuthManager.is_authenticated` and `auth_state_changed` signal.

### start-srv — Start Page Backend

Lightweight HTTP/1.1 server (`http_server.gd`) listening on `127.0.0.1:BACKEND_PORT`.
Auth API handler (`auth_api.gd`) proxies sign-in, sign-up, and sign-out to Supabase
using credentials from `.env`. **Only this package accesses `SUPABASE_URL`/`SUPABASE_KEY`.**

### clusters-frt / clusters-srv — Clusters

Plugin stubs for the Clusters feature. Frontend manages cluster UI; backend handles
cluster data and API. Full implementation is planned for a future iteration.

## Technology Stack

| Component          | Technology                                   |
|--------------------|----------------------------------------------|
| Engine             | Godot 4.3+ (GDScript)                        |
| Frontend UI        | Godot scenes and Control nodes               |
| Backend server     | Custom GDScript HTTP server (TCPServer)      |
| Database / Auth    | Supabase (PostgreSQL + GoTrue Auth)          |
| Auth proxy         | GDScript HTTPRequest → Supabase REST API     |
| Session storage    | Local file `user://session.json`             |
| Multiplayer        | Godot ENet high-level multiplayer API        |

## Getting Started

### Prerequisites

- [Godot Engine 4.3+](https://godotengine.org/download/) (latest stable recommended)
- Git
- A [Supabase](https://supabase.com) project with authentication enabled

### Installation

1. Clone the repository:

```bash
git clone https://github.com/teknokomo/universo-platformo-godot.git
cd universo-platformo-godot
```

2. Copy the environment template and configure:

```bash
cp .env.example .env
```

Edit `.env` with your values:

```env
BACKEND_PORT=8080
SUPABASE_URL=https://your-project.supabase.co
SUPABASE_KEY=your-anon-key-here
```

3. Open the project in Godot Editor:

```bash
godot --editor project.godot
```

### Running

Press **F5** in the Godot Editor, or run from the command line:

```bash
godot --path . res://scenes/main.tscn
```

The application starts the backend HTTP server and the frontend start page.
Without a configured `.env`, the backend logs a warning and auth forms will
return a "Backend not configured" error when submitted.

## Project Status

- [x] Repository structure and Godot project setup
- [x] Core autoload system (Config, DatabaseManager, NetworkManager)
- [x] Backend HTTP server (BackendServer, HTTPServer, AuthAPI)
- [x] Supabase auth proxy (sign-in, sign-up, sign-out via backend)
- [x] Frontend auth manager (routes all calls through backend only)
- [x] Start page: guest landing with sign-in / sign-up form
- [x] Start page: authenticated welcome with user info and sign-out
- [x] Clusters package stubs (clusters-frt, clusters-srv)
- [ ] Clusters full implementation
- [ ] Metaverses, Spaces, Uniks packages
- [ ] Headless server-mode scene

## Related Projects

- [Universo Platformo React](https://github.com/teknokomo/universo-platformo-react) —
  React/Express reference implementation
- Documentation: `docs.universo.pro` (coming soon)

## License

[License information to be added]

## Community & Support

- **Issues**: [GitHub Issues](https://github.com/teknokomo/universo-platformo-godot/issues)
- **Discussions**: [GitHub Discussions](https://github.com/teknokomo/universo-platformo-godot/discussions)
- **Documentation**: Coming soon at `docs.universo.pro`
