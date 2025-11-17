-- Database Schema for Universo Platformo Godot
-- Feature: 001-project-setup
-- Date: 2025-11-17
-- Database: PostgreSQL (Supabase)

-- ============================================================================
-- INFRASTRUCTURE TABLES
-- ============================================================================

-- Users table
CREATE TABLE IF NOT EXISTS users (
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

CREATE INDEX IF NOT EXISTS idx_users_email ON users(email);
CREATE INDEX IF NOT EXISTS idx_users_is_active ON users(is_active) WHERE is_active = TRUE;

-- Refresh tokens table
CREATE TABLE IF NOT EXISTS refresh_tokens (
	id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
	user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
	token_hash VARCHAR(255) NOT NULL,
	created_at TIMESTAMP DEFAULT NOW(),
	expires_at TIMESTAMP NOT NULL,
	is_revoked BOOLEAN DEFAULT FALSE,
	revoked_at TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_refresh_tokens_user_id ON refresh_tokens(user_id);
CREATE INDEX IF NOT EXISTS idx_refresh_tokens_token_hash ON refresh_tokens(token_hash);
CREATE INDEX IF NOT EXISTS idx_refresh_tokens_expires_at ON refresh_tokens(expires_at);

-- Roles table (RBAC)
CREATE TABLE IF NOT EXISTS roles (
	id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
	name VARCHAR(50) UNIQUE NOT NULL,
	description VARCHAR(255),
	created_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_roles_name ON roles(name);

-- Permissions table (RBAC)
CREATE TABLE IF NOT EXISTS permissions (
	id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
	resource VARCHAR(50) NOT NULL,
	action VARCHAR(50) NOT NULL,
	description VARCHAR(255),
	UNIQUE(resource, action)
);

CREATE INDEX IF NOT EXISTS idx_permissions_resource ON permissions(resource);

-- User-Role junction table
CREATE TABLE IF NOT EXISTS user_roles (
	user_id UUID REFERENCES users(id) ON DELETE CASCADE,
	role_id UUID REFERENCES roles(id) ON DELETE CASCADE,
	assigned_at TIMESTAMP DEFAULT NOW(),
	PRIMARY KEY (user_id, role_id)
);

CREATE INDEX IF NOT EXISTS idx_user_roles_user_id ON user_roles(user_id);
CREATE INDEX IF NOT EXISTS idx_user_roles_role_id ON user_roles(role_id);

-- Role-Permission junction table
CREATE TABLE IF NOT EXISTS role_permissions (
	role_id UUID REFERENCES roles(id) ON DELETE CASCADE,
	permission_id UUID REFERENCES permissions(id) ON DELETE CASCADE,
	granted_at TIMESTAMP DEFAULT NOW(),
	PRIMARY KEY (role_id, permission_id)
);

CREATE INDEX IF NOT EXISTS idx_role_permissions_role_id ON role_permissions(role_id);
CREATE INDEX IF NOT EXISTS idx_role_permissions_permission_id ON role_permissions(permission_id);

-- ============================================================================
-- CLUSTERS FEATURE TABLES
-- ============================================================================

-- Clusters table
CREATE TABLE IF NOT EXISTS clusters (
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

CREATE INDEX IF NOT EXISTS idx_clusters_owner_id ON clusters(owner_id);
CREATE INDEX IF NOT EXISTS idx_clusters_created_at ON clusters(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_clusters_is_public ON clusters(is_public) WHERE is_public = TRUE;

-- Domains table
CREATE TABLE IF NOT EXISTS domains (
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

CREATE INDEX IF NOT EXISTS idx_domains_cluster_id ON domains(cluster_id);
CREATE INDEX IF NOT EXISTS idx_domains_order_index ON domains(cluster_id, order_index);

-- Resources table
CREATE TABLE IF NOT EXISTS resources (
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

CREATE INDEX IF NOT EXISTS idx_resources_domain_id ON resources(domain_id);
CREATE INDEX IF NOT EXISTS idx_resources_type ON resources(resource_type);
CREATE INDEX IF NOT EXISTS idx_resources_created_at ON resources(created_at DESC);

-- ============================================================================
-- MIGRATION TRACKING TABLE
-- ============================================================================

CREATE TABLE IF NOT EXISTS schema_migrations (
	version INTEGER PRIMARY KEY,
	applied_at TIMESTAMP DEFAULT NOW()
);

-- ============================================================================
-- SEED DATA (Default roles and permissions)
-- ============================================================================

-- Insert default roles
INSERT INTO roles (name, description) VALUES
	('admin', 'Administrator with full access'),
	('editor', 'Can create and edit content'),
	('viewer', 'Read-only access')
ON CONFLICT (name) DO NOTHING;

-- Insert default permissions
INSERT INTO permissions (resource, action, description) VALUES
	('clusters', 'create', 'Create new clusters'),
	('clusters', 'read', 'View clusters'),
	('clusters', 'update', 'Edit clusters'),
	('clusters', 'delete', 'Delete clusters'),
	('domains', 'create', 'Create new domains'),
	('domains', 'read', 'View domains'),
	('domains', 'update', 'Edit domains'),
	('domains', 'delete', 'Delete domains'),
	('resources', 'create', 'Create new resources'),
	('resources', 'read', 'View resources'),
	('resources', 'update', 'Edit resources'),
	('resources', 'delete', 'Delete resources'),
	('users', 'create', 'Create new users'),
	('users', 'read', 'View users'),
	('users', 'update', 'Edit users'),
	('users', 'delete', 'Delete users')
ON CONFLICT (resource, action) DO NOTHING;

-- Assign permissions to roles
-- Admin: All permissions
INSERT INTO role_permissions (role_id, permission_id)
SELECT r.id, p.id
FROM roles r
CROSS JOIN permissions p
WHERE r.name = 'admin'
ON CONFLICT DO NOTHING;

-- Editor: CRUD on clusters, domains, resources; read-only on users
INSERT INTO role_permissions (role_id, permission_id)
SELECT r.id, p.id
FROM roles r
CROSS JOIN permissions p
WHERE r.name = 'editor'
	AND (
		(p.resource IN ('clusters', 'domains', 'resources'))
		OR (p.resource = 'users' AND p.action = 'read')
	)
ON CONFLICT DO NOTHING;

-- Viewer: Read-only on all resources
INSERT INTO role_permissions (role_id, permission_id)
SELECT r.id, p.id
FROM roles r
CROSS JOIN permissions p
WHERE r.name = 'viewer'
	AND p.action = 'read'
ON CONFLICT DO NOTHING;
