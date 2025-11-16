# Clusters Frontend Package

## Overview

The Clusters Frontend package provides the client-side implementation for the Clusters system in Universo Platformo. It manages the user interface and client-side logic for working with Clusters, Domains, and Resources.

## Features

- Cluster management UI
- Domain organization interface
- Resource browsing and management
- Real-time updates via network synchronization

## Structure

```
packages/clusters-frt/base/
├── scenes/              # UI scenes
│   ├── cluster_list.tscn
│   ├── cluster_detail.tscn
│   ├── domain_list.tscn
│   └── resource_browser.tscn
├── scripts/             # Client-side logic
│   ├── cluster_manager.gd
│   ├── domain_controller.gd
│   └── resource_handler.gd
├── plugin.cfg           # Plugin configuration
├── plugin.gd            # Plugin entry point
├── README.md            # This file (English)
└── README-RU.md        # Russian version
```

## Installation

This package is part of the Universo Platformo Godot monorepo and is automatically available when the project is opened.

To enable the plugin:
1. Open Project Settings → Plugins
2. Find "Clusters Frontend" in the list
3. Enable the plugin

## Usage

### Creating a Cluster

```gdscript
var cluster_manager = ClusterManager.new()
var new_cluster = cluster_manager.create_cluster({
    "name": "My Cluster",
    "description": "A sample cluster"
})
```

### Managing Domains

```gdscript
var domain_controller = DomainController.new()
domain_controller.add_domain(cluster_id, {
    "name": "Production",
    "type": "environment"
})
```

### Browsing Resources

```gdscript
var resource_handler = ResourceHandler.new()
var resources = resource_handler.list_resources(domain_id)
```

## API Reference

### ClusterManager

Main class for managing clusters on the client side.

**Methods:**
- `create_cluster(data: Dictionary) -> Dictionary`
- `get_cluster(cluster_id: String) -> Dictionary`
- `update_cluster(cluster_id: String, data: Dictionary) -> bool`
- `delete_cluster(cluster_id: String) -> bool`
- `list_clusters() -> Array`

### DomainController

Manages domains within clusters.

**Methods:**
- `add_domain(cluster_id: String, data: Dictionary) -> Dictionary`
- `get_domain(domain_id: String) -> Dictionary`
- `update_domain(domain_id: String, data: Dictionary) -> bool`
- `delete_domain(domain_id: String) -> bool`
- `list_domains(cluster_id: String) -> Array`

### ResourceHandler

Handles resources within domains.

**Methods:**
- `add_resource(domain_id: String, data: Dictionary) -> Dictionary`
- `get_resource(resource_id: String) -> Dictionary`
- `update_resource(resource_id: String, data: Dictionary) -> bool`
- `delete_resource(resource_id: String) -> bool`
- `list_resources(domain_id: String) -> Array`

## Integration

This package integrates with:
- **Clusters Server Package**: Backend API for data persistence
- **Database Manager**: Supabase integration for data storage
- **Network Manager**: Real-time synchronization

## Development

### Adding New Features

1. Create new scene files in `scenes/`
2. Add corresponding scripts in `scripts/`
3. Update this README with new functionality
4. Ensure Russian version (README-RU.md) is updated identically

### Testing

Run the main scene with this package enabled to test cluster functionality:
```bash
godot --path . scenes/main.tscn
```

## Dependencies

- Godot Engine 4.x
- Universo Platformo Core
- Database Manager autoload
- Network Manager autoload

## Contributing

See the main project [CONTRIBUTING.md](../../../CONTRIBUTING.md) for contribution guidelines.

## License

[License information to be added]
