# Data Model: Universo Platformo Godot - Project Setup & Foundation

**Feature**: 001-project-setup  
**Date**: 2025-11-17  
**Status**: Complete

## Overview

This document defines the core data models, entities, relationships, and database schemas for the Universo Platformo Godot foundation. It covers infrastructure entities (users, sessions, authentication) and the initial feature implementation (Clusters/Domains/Resources).

## Core Infrastructure Entities

### User

Represents an authenticated user of the platform.

**Attributes**:
- `id`: UUID (primary key, auto-generated)
- `email`: String (unique, required, max 255 chars)
- `password_hash`: String (required, bcrypt hashed)
- `display_name`: String (optional, max 100 chars)
- `avatar_url`: String (optional, URL to avatar image)
- `created_at`: Timestamp (auto-generated on creation)
- `updated_at`: Timestamp (auto-updated on modification)
- `last_login_at`: Timestamp (nullable)
- `is_active`: Boolean (default true, for soft delete/ban)

**Relationships**:
- Has Many: `Session` (one user can have multiple active sessions)
- Has Many: `RefreshToken` (one user can have multiple refresh tokens)
- Has Many: `UserRole` (one user can have multiple roles)
- Has Many: `Cluster` (as creator/owner)

**Validation Rules**:
- Email: Must be valid email format, unique across users
- Password: Minimum 8 characters, must contain uppercase, lowercase, number
- Display name: If provided, must be 3-100 characters

**State Transitions**:
- `is_active`: true ↔ false (admin can activate/deactivate users)

**GDScript Class** (universo-types package):
```gdscript
class_name User
extends Resource

@export var id: String  # UUID
@export var email: String
@export var display_name: String = ""
@export var avatar_url: String = ""
@export var created_at: float  # Unix timestamp
@export var updated_at: float
@export var last_login_at: float = 0.0
@export var is_active: bool = true

# Not exported (security)
var password_hash: String = ""
var roles: Array[Role] = []

func validate() -> Dictionary:
	var errors = {}
	if not email or not email.is_valid_email():
		errors["email"] = "ERROR_INVALID_EMAIL"
	if display_name.length() > 100:
		errors["display_name"] = "ERROR_DISPLAY_NAME_TOO_LONG"
	return errors

func to_dict() -> Dictionary:
	return {
		"id": id,
		"email": email,
		"display_name": display_name,
		"avatar_url": avatar_url,
		"created_at": created_at,
		"updated_at": updated_at,
		"last_login_at": last_login_at,
		"is_active": is_active
	}
```

---

### Session

Represents an active user session (in-memory only, not persisted to database).

**Attributes**:
- `session_id`: UUID (primary key)
- `user_id`: UUID (foreign key to User)
- `access_token`: String (JWT token)
- `created_at`: Timestamp
- `expires_at`: Timestamp (15 minutes after creation)
- `ip_address`: String
- `user_agent`: String

**Relationships**:
- Belongs To: `User`

**Lifecycle**:
- Created on successful authentication
- Stored in memory (AuthManager.sessions Dictionary)
- Automatically cleaned up on expiry (periodic cleanup every 5 minutes)
- Manually invalidated on logout

**GDScript Class** (scripts/auth_manager.gd):
```gdscript
class Session:
	var session_id: String
	var user_id: String
	var access_token: String
	var created_at: float
	var expires_at: float
	var ip_address: String
	var user_agent: String
	
	func is_expired() -> bool:
		return Time.get_unix_time_from_system() > expires_at
	
	func to_dict() -> Dictionary:
		return {
			"session_id": session_id,
			"user_id": user_id,
			"created_at": created_at,
			"expires_at": expires_at,
			"ip_address": ip_address
		}
```

---

### RefreshToken

Represents a long-lived refresh token for obtaining new access tokens.

**Attributes**:
- `id`: UUID (primary key)
- `user_id`: UUID (foreign key to User)
- `token_hash`: String (hashed refresh token)
- `created_at`: Timestamp
- `expires_at`: Timestamp (30 days after creation)
- `is_revoked`: Boolean (default false)
- `revoked_at`: Timestamp (nullable)

**Relationships**:
- Belongs To: `User`

**Validation Rules**:
- Token must be 64 characters (base64 encoded random bytes)
- Token hash stored in database (not plaintext)

**State Transitions**:
- `is_revoked`: false → true (on manual revocation or security event)

**GDScript Class** (universo-types package):
```gdscript
class_name RefreshToken
extends Resource

@export var id: String
@export var user_id: String
@export var token_hash: String
@export var created_at: float
@export var expires_at: float
@export var is_revoked: bool = false
@export var revoked_at: float = 0.0

func is_expired() -> bool:
	return Time.get_unix_time_from_system() > expires_at

func is_valid() -> bool:
	return not is_revoked and not is_expired()
```

---

### Role

Represents a role in the RBAC system.

**Attributes**:
- `id`: UUID (primary key)
- `name`: String (unique, required, max 50 chars) - e.g., "admin", "editor", "viewer"
- `description`: String (optional, max 255 chars)
- `created_at`: Timestamp

**Relationships**:
- Has Many: `UserRole` (roles assigned to users)
- Has Many: `RolePermission` (permissions granted to role)

**Validation Rules**:
- Name: Lowercase alphanumeric with underscores, unique

**GDScript Class** (universo-types package):
```gdscript
class_name Role
extends Resource

@export var id: String
@export var name: String
@export var description: String = ""
@export var created_at: float

var permissions: Array[Permission] = []

func to_dict() -> Dictionary:
	return {
		"id": id,
		"name": name,
		"description": description,
		"created_at": created_at
	}
```

---

### Permission

Represents a specific permission in the RBAC system.

**Attributes**:
- `id`: UUID (primary key)
- `resource`: String (required, max 50 chars) - e.g., "clusters", "users"
- `action`: String (required, max 50 chars) - e.g., "create", "read", "update", "delete"
- `description`: String (optional, max 255 chars)

**Format**: `{resource}:{action}` - e.g., "clusters:create", "users:delete"

**Relationships**:
- Has Many: `RolePermission` (permissions assigned to roles)

**Validation Rules**:
- Resource and action combination must be unique
- Resource and action: Lowercase alphanumeric with underscores

**GDScript Class** (universo-types package):
```gdscript
class_name Permission
extends Resource

@export var id: String
@export var resource: String
@export var action: String
@export var description: String = ""

func get_permission_string() -> String:
	return "%s:%s" % [resource, action]

func to_dict() -> Dictionary:
	return {
		"id": id,
		"resource": resource,
		"action": action,
		"permission": get_permission_string(),
		"description": description
	}
```

---

### UserRole (Junction Table)

Links users to roles (many-to-many relationship).

**Attributes**:
- `user_id`: UUID (foreign key to User, composite primary key part 1)
- `role_id`: UUID (foreign key to Role, composite primary key part 2)
- `assigned_at`: Timestamp

**Database Table**:
```sql
CREATE TABLE user_roles (
	user_id UUID REFERENCES users(id) ON DELETE CASCADE,
	role_id UUID REFERENCES roles(id) ON DELETE CASCADE,
	assigned_at TIMESTAMP DEFAULT NOW(),
	PRIMARY KEY (user_id, role_id)
);

CREATE INDEX idx_user_roles_user_id ON user_roles(user_id);
CREATE INDEX idx_user_roles_role_id ON user_roles(role_id);
```

---

### RolePermission (Junction Table)

Links roles to permissions (many-to-many relationship).

**Attributes**:
- `role_id`: UUID (foreign key to Role, composite primary key part 1)
- `permission_id`: UUID (foreign key to Permission, composite primary key part 2)
- `granted_at`: Timestamp

**Database Table**:
```sql
CREATE TABLE role_permissions (
	role_id UUID REFERENCES roles(id) ON DELETE CASCADE,
	permission_id UUID REFERENCES permissions(id) ON DELETE CASCADE,
	granted_at TIMESTAMP DEFAULT NOW(),
	PRIMARY KEY (role_id, permission_id)
);

CREATE INDEX idx_role_permissions_role_id ON role_permissions(role_id);
CREATE INDEX idx_role_permissions_permission_id ON role_permissions(permission_id);
```

---

## Clusters Feature Entities

### Cluster

Top-level organizational unit in the Clusters feature.

**Attributes**:
- `id`: UUID (primary key, auto-generated)
- `name`: String (required, max 100 chars)
- `description`: String (optional, max 500 chars)
- `owner_id`: UUID (foreign key to User, required)
- `created_at`: Timestamp (auto-generated)
- `updated_at`: Timestamp (auto-updated)
- `is_public`: Boolean (default false)
- `metadata`: JSON (optional, flexible key-value storage)

**Relationships**:
- Belongs To: `User` (as owner)
- Has Many: `Domain` (one cluster contains multiple domains)

**Validation Rules**:
- Name: 3-100 characters, must be unique within owner's clusters
- Description: Max 500 characters
- Owner: Must be valid, active user

**State Transitions**:
- None (simple CRUD entity)

**GDScript Class** (packages/clusters-srv/base/models/cluster.gd):
```gdscript
class_name Cluster
extends Resource

@export var id: String
@export var name: String
@export var description: String = ""
@export var owner_id: String
@export var created_at: float
@export var updated_at: float
@export var is_public: bool = false
@export var metadata: Dictionary = {}

func validate() -> Dictionary:
	var errors = {}
	if not name or name.length() < 3 or name.length() > 100:
		errors["name"] = "ERROR_CLUSTER_NAME_INVALID_LENGTH"
	if description.length() > 500:
		errors["description"] = "ERROR_CLUSTER_DESCRIPTION_TOO_LONG"
	if not owner_id:
		errors["owner_id"] = "ERROR_CLUSTER_OWNER_REQUIRED"
	return errors

func to_dict() -> Dictionary:
	return {
		"id": id,
		"name": name,
		"description": description,
		"owner_id": owner_id,
		"created_at": created_at,
		"updated_at": updated_at,
		"is_public": is_public,
		"metadata": metadata
	}
```

**Database Table**:
```sql
CREATE TABLE clusters (
	id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
	name VARCHAR(100) NOT NULL,
	description VARCHAR(500),
	owner_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
	created_at TIMESTAMP DEFAULT NOW(),
	updated_at TIMESTAMP DEFAULT NOW(),
	is_public BOOLEAN DEFAULT FALSE,
	metadata JSONB,
	UNIQUE(owner_id, name)
);

CREATE INDEX idx_clusters_owner_id ON clusters(owner_id);
CREATE INDEX idx_clusters_created_at ON clusters(created_at DESC);
CREATE INDEX idx_clusters_is_public ON clusters(is_public) WHERE is_public = TRUE;
```

---

### Domain

Logical grouping within a Cluster.

**Attributes**:
- `id`: UUID (primary key, auto-generated)
- `name`: String (required, max 100 chars)
- `description`: String (optional, max 500 chars)
- `cluster_id`: UUID (foreign key to Cluster, required)
- `created_at`: Timestamp (auto-generated)
- `updated_at`: Timestamp (auto-updated)
- `configuration`: JSON (optional, domain-specific settings)
- `order_index`: Integer (for manual ordering within cluster)

**Relationships**:
- Belongs To: `Cluster`
- Has Many: `Resource` (one domain contains multiple resources)

**Validation Rules**:
- Name: 3-100 characters, must be unique within parent cluster
- Cluster: Must exist and be accessible to user

**GDScript Class** (packages/clusters-srv/base/models/domain.gd):
```gdscript
class_name Domain
extends Resource

@export var id: String
@export var name: String
@export var description: String = ""
@export var cluster_id: String
@export var created_at: float
@export var updated_at: float
@export var configuration: Dictionary = {}
@export var order_index: int = 0

func validate() -> Dictionary:
	var errors = {}
	if not name or name.length() < 3 or name.length() > 100:
		errors["name"] = "ERROR_DOMAIN_NAME_INVALID_LENGTH"
	if description.length() > 500:
		errors["description"] = "ERROR_DOMAIN_DESCRIPTION_TOO_LONG"
	if not cluster_id:
		errors["cluster_id"] = "ERROR_DOMAIN_CLUSTER_REQUIRED"
	return errors

func to_dict() -> Dictionary:
	return {
		"id": id,
		"name": name,
		"description": description,
		"cluster_id": cluster_id,
		"created_at": created_at,
		"updated_at": updated_at,
		"configuration": configuration,
		"order_index": order_index
	}
```

**Database Table**:
```sql
CREATE TABLE domains (
	id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
	name VARCHAR(100) NOT NULL,
	description VARCHAR(500),
	cluster_id UUID NOT NULL REFERENCES clusters(id) ON DELETE CASCADE,
	created_at TIMESTAMP DEFAULT NOW(),
	updated_at TIMESTAMP DEFAULT NOW(),
	configuration JSONB,
	order_index INTEGER DEFAULT 0,
	UNIQUE(cluster_id, name)
);

CREATE INDEX idx_domains_cluster_id ON domains(cluster_id);
CREATE INDEX idx_domains_order_index ON domains(cluster_id, order_index);
```

---

### Resource

Individual asset or component within a Domain.

**Attributes**:
- `id`: UUID (primary key, auto-generated)
- `name`: String (required, max 100 chars)
- `description`: String (optional, max 500 chars)
- `domain_id`: UUID (foreign key to Domain, required)
- `resource_type`: String (required, max 50 chars) - e.g., "file", "link", "data"
- `data`: JSON (optional, type-specific data storage)
- `created_at`: Timestamp (auto-generated)
- `updated_at`: Timestamp (auto-updated)
- `file_url`: String (optional, URL if type="file")
- `file_size`: BigInt (optional, bytes if type="file")

**Relationships**:
- Belongs To: `Domain`

**Validation Rules**:
- Name: 3-100 characters, must be unique within parent domain
- Resource type: Must be from allowed list ["file", "link", "data", "note"]
- Domain: Must exist and be accessible to user

**GDScript Class** (packages/clusters-srv/base/models/resource.gd):
```gdscript
class_name ClusterResource  # Avoid conflict with Godot's Resource class
extends RefCounted

var id: String
var name: String
var description: String = ""
var domain_id: String
var resource_type: String
var data: Dictionary = {}
var created_at: float
var updated_at: float
var file_url: String = ""
var file_size: int = 0

const ALLOWED_TYPES = ["file", "link", "data", "note"]

func validate() -> Dictionary:
	var errors = {}
	if not name or name.length() < 3 or name.length() > 100:
		errors["name"] = "ERROR_RESOURCE_NAME_INVALID_LENGTH"
	if description.length() > 500:
		errors["description"] = "ERROR_RESOURCE_DESCRIPTION_TOO_LONG"
	if not domain_id:
		errors["domain_id"] = "ERROR_RESOURCE_DOMAIN_REQUIRED"
	if not resource_type in ALLOWED_TYPES:
		errors["resource_type"] = "ERROR_RESOURCE_TYPE_INVALID"
	return errors

func to_dict() -> Dictionary:
	return {
		"id": id,
		"name": name,
		"description": description,
		"domain_id": domain_id,
		"resource_type": resource_type,
		"data": data,
		"created_at": created_at,
		"updated_at": updated_at,
		"file_url": file_url,
		"file_size": file_size
	}
```

**Database Table**:
```sql
CREATE TABLE resources (
	id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
	name VARCHAR(100) NOT NULL,
	description VARCHAR(500),
	domain_id UUID NOT NULL REFERENCES domains(id) ON DELETE CASCADE,
	resource_type VARCHAR(50) NOT NULL CHECK (resource_type IN ('file', 'link', 'data', 'note')),
	data JSONB,
	created_at TIMESTAMP DEFAULT NOW(),
	updated_at TIMESTAMP DEFAULT NOW(),
	file_url TEXT,
	file_size BIGINT,
	UNIQUE(domain_id, name)
);

CREATE INDEX idx_resources_domain_id ON resources(domain_id);
CREATE INDEX idx_resources_type ON resources(resource_type);
CREATE INDEX idx_resources_created_at ON resources(created_at DESC);
```

---

## Database Schema Summary

### Complete Schema (PostgreSQL)

```sql
-- Infrastructure Tables

CREATE TABLE users (
	id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
	email VARCHAR(255) UNIQUE NOT NULL,
	password_hash VARCHAR(255) NOT NULL,
	display_name VARCHAR(100),
	avatar_url TEXT,
	created_at TIMESTAMP DEFAULT NOW(),
	updated_at TIMESTAMP DEFAULT NOW(),
	last_login_at TIMESTAMP,
	is_active BOOLEAN DEFAULT TRUE
);

CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_is_active ON users(is_active) WHERE is_active = TRUE;

CREATE TABLE refresh_tokens (
	id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
	user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
	token_hash VARCHAR(255) NOT NULL,
	created_at TIMESTAMP DEFAULT NOW(),
	expires_at TIMESTAMP NOT NULL,
	is_revoked BOOLEAN DEFAULT FALSE,
	revoked_at TIMESTAMP
);

CREATE INDEX idx_refresh_tokens_user_id ON refresh_tokens(user_id);
CREATE INDEX idx_refresh_tokens_token_hash ON refresh_tokens(token_hash);
CREATE INDEX idx_refresh_tokens_expires_at ON refresh_tokens(expires_at);

CREATE TABLE roles (
	id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
	name VARCHAR(50) UNIQUE NOT NULL,
	description VARCHAR(255),
	created_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX idx_roles_name ON roles(name);

CREATE TABLE permissions (
	id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
	resource VARCHAR(50) NOT NULL,
	action VARCHAR(50) NOT NULL,
	description VARCHAR(255),
	UNIQUE(resource, action)
);

CREATE INDEX idx_permissions_resource ON permissions(resource);

CREATE TABLE user_roles (
	user_id UUID REFERENCES users(id) ON DELETE CASCADE,
	role_id UUID REFERENCES roles(id) ON DELETE CASCADE,
	assigned_at TIMESTAMP DEFAULT NOW(),
	PRIMARY KEY (user_id, role_id)
);

CREATE INDEX idx_user_roles_user_id ON user_roles(user_id);
CREATE INDEX idx_user_roles_role_id ON user_roles(role_id);

CREATE TABLE role_permissions (
	role_id UUID REFERENCES roles(id) ON DELETE CASCADE,
	permission_id UUID REFERENCES permissions(id) ON DELETE CASCADE,
	granted_at TIMESTAMP DEFAULT NOW(),
	PRIMARY KEY (role_id, permission_id)
);

CREATE INDEX idx_role_permissions_role_id ON role_permissions(role_id);
CREATE INDEX idx_role_permissions_permission_id ON role_permissions(permission_id);

-- Feature Tables (Clusters)

CREATE TABLE clusters (
	id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
	name VARCHAR(100) NOT NULL,
	description VARCHAR(500),
	owner_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
	created_at TIMESTAMP DEFAULT NOW(),
	updated_at TIMESTAMP DEFAULT NOW(),
	is_public BOOLEAN DEFAULT FALSE,
	metadata JSONB,
	UNIQUE(owner_id, name)
);

CREATE INDEX idx_clusters_owner_id ON clusters(owner_id);
CREATE INDEX idx_clusters_created_at ON clusters(created_at DESC);
CREATE INDEX idx_clusters_is_public ON clusters(is_public) WHERE is_public = TRUE;

CREATE TABLE domains (
	id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
	name VARCHAR(100) NOT NULL,
	description VARCHAR(500),
	cluster_id UUID NOT NULL REFERENCES clusters(id) ON DELETE CASCADE,
	created_at TIMESTAMP DEFAULT NOW(),
	updated_at TIMESTAMP DEFAULT NOW(),
	configuration JSONB,
	order_index INTEGER DEFAULT 0,
	UNIQUE(cluster_id, name)
);

CREATE INDEX idx_domains_cluster_id ON domains(cluster_id);
CREATE INDEX idx_domains_order_index ON domains(cluster_id, order_index);

CREATE TABLE resources (
	id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
	name VARCHAR(100) NOT NULL,
	description VARCHAR(500),
	domain_id UUID NOT NULL REFERENCES domains(id) ON DELETE CASCADE,
	resource_type VARCHAR(50) NOT NULL CHECK (resource_type IN ('file', 'link', 'data', 'note')),
	data JSONB,
	created_at TIMESTAMP DEFAULT NOW(),
	updated_at TIMESTAMP DEFAULT NOW(),
	file_url TEXT,
	file_size BIGINT,
	UNIQUE(domain_id, name)
);

CREATE INDEX idx_resources_domain_id ON resources(domain_id);
CREATE INDEX idx_resources_type ON resources(resource_type);
CREATE INDEX idx_resources_created_at ON resources(created_at DESC);

-- Migration Tracking Table

CREATE TABLE schema_migrations (
	version INTEGER PRIMARY KEY,
	applied_at TIMESTAMP DEFAULT NOW()
);
```

---

## Entity Relationships Diagram

```
┌──────────────┐
│     User     │
├──────────────┤
│ id (PK)      │
│ email        │
│ password_hash│
│ display_name │
│ ...          │
└──────────────┘
       │ 1
       │
       │ N
┌──────────────┐     ┌──────────────┐
│  UserRole    │  N  │     Role     │
├──────────────┤─────├──────────────┤
│ user_id (FK) │     │ id (PK)      │
│ role_id (FK) │     │ name         │
└──────────────┘     │ description  │
                     └──────────────┘
                            │ 1
                            │
                            │ N
                     ┌──────────────────┐     ┌──────────────┐
                     │ RolePermission   │  N  │  Permission  │
                     ├──────────────────┤─────├──────────────┤
                     │ role_id (FK)     │     │ id (PK)      │
                     │ permission_id(FK)│     │ resource     │
                     └──────────────────┘     │ action       │
                                              └──────────────┘

┌──────────────┐
│     User     │
└──────────────┘
       │ 1
       │
       │ N
┌──────────────┐
│   Cluster    │
├──────────────┤
│ id (PK)      │
│ name         │
│ owner_id (FK)│
│ description  │
│ is_public    │
│ metadata     │
└──────────────┘
       │ 1
       │
       │ N
┌──────────────┐
│    Domain    │
├──────────────┤
│ id (PK)      │
│ name         │
│ cluster_id(FK)│
│ description  │
│ configuration│
│ order_index  │
└──────────────┘
       │ 1
       │
       │ N
┌──────────────┐
│   Resource   │
├──────────────┤
│ id (PK)      │
│ name         │
│ domain_id(FK)│
│ resource_type│
│ data         │
│ file_url     │
│ file_size    │
└──────────────┘
```

---

## Data Model Summary

### Infrastructure Entities
- **User**: Platform user with authentication and ownership
- **Session**: In-memory active session (not persisted)
- **RefreshToken**: Long-lived token for access token renewal
- **Role**: RBAC role (admin, editor, viewer)
- **Permission**: RBAC permission (resource:action format)
- **UserRole**: User-to-Role assignment (junction)
- **RolePermission**: Role-to-Permission assignment (junction)

### Clusters Feature Entities
- **Cluster**: Top-level organizational unit (owned by user)
- **Domain**: Logical grouping within cluster
- **Resource**: Individual asset/component within domain

### Cascade Delete Behavior
- User deleted → Clusters deleted → Domains deleted → Resources deleted
- User deleted → Refresh tokens deleted
- Role deleted → User role assignments deleted, Role permission assignments deleted
- Cluster deleted → Domains deleted → Resources deleted

### Indexing Strategy
- Foreign keys: Indexed for fast joins
- Unique constraints: Natural keys indexed (email, cluster name per owner, etc.)
- Frequently queried fields: Indexed (created_at DESC for latest-first queries, is_public for filtering)
- Partial indexes: Used for filtered queries (e.g., is_active = TRUE)

---

**Status**: ✅ COMPLETE  
**Next Step**: Create API contracts in `contracts/` directory  
**Date**: 2025-11-17
