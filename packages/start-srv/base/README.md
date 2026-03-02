# Start Backend Package

## Overview

The Start Backend package provides the server-side component for the start page
of Universo Platformo. It runs a lightweight HTTP server that acts as a proxy
between the frontend and Supabase, ensuring Supabase credentials never reach
the client.

## Security Architecture

```
[Frontend — start-frt]      [Backend — start-srv]      [Supabase Cloud]
  AuthManager autoload  →   BackendServer autoload  →   REST Auth API
  no SUPABASE_URL/KEY        holds all credentials       (external)
  calls 127.0.0.1:8080       proxies requests
```

The frontend sends email/password (or access_token) to the local backend.
The backend forwards these to Supabase using `SUPABASE_URL` and `SUPABASE_KEY`,
which are only available in the backend's `.env` configuration.

## Structure

```
packages/start-srv/base/
├── scripts/
│   ├── http_server.gd    # Lightweight TCPServer-based HTTP/1.1 server
│   └── auth_api.gd       # Auth API routes — proxies requests to Supabase
├── plugin.cfg            # Plugin configuration
├── plugin.gd             # Plugin entry point
├── README.md             # This file (English)
└── README-RU.md          # Russian version
```

## API Endpoints

The backend listens on `127.0.0.1:BACKEND_PORT` (default `8080`):

| Method | Path                  | Body fields                 | Description              |
|--------|-----------------------|-----------------------------|--------------------------|
| POST   | /api/auth/sign-in     | email, password             | Sign in with credentials |
| POST   | /api/auth/sign-up     | email, password             | Create a new account     |
| POST   | /api/auth/sign-out    | access_token                | Invalidate session token |

All endpoints proxy directly to the Supabase Auth REST API and relay the
response back to the caller unchanged.

## Configuration

Set in `.env` (backend-only variables):

```env
BACKEND_PORT=8080
SUPABASE_URL=https://your-project.supabase.co
SUPABASE_KEY=your-anon-key-here
```

The frontend reads only `BACKEND_PORT` and builds `http://127.0.0.1:BACKEND_PORT`.

## Usage

The server starts automatically via the `BackendServer` autoload
(`scripts/autoload/backend_server.gd`) when the Godot project runs.

To call from GDScript (frontend side):

```gdscript
# Sign in (handled by AuthManager — do not call directly)
var http := HTTPRequest.new()
add_child(http)
http.request(
    "http://127.0.0.1:8080/api/auth/sign-in",
    PackedStringArray(["Content-Type: application/json"]),
    HTTPClient.METHOD_POST,
    JSON.stringify({"email": "user@example.com", "password": "secret"})
)
```

In practice, always use `AuthManager.sign_in()` — it wraps this call.

## Dependencies

- Godot Engine 4.3+
- `Config` autoload — reads `.env` for `SUPABASE_URL`, `SUPABASE_KEY`, `BACKEND_PORT`
- Supabase project with authentication enabled

## Contributing

See the main project [CONTRIBUTING.md](../../../CONTRIBUTING.md).

## License

[License information to be added]
