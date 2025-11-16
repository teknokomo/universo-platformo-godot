@tool
extends EditorPlugin
## Clusters Server Plugin
##
## This plugin provides the server-side functionality for the Clusters system.
## It manages the business logic and API endpoints for Clusters, Domains, and Resources.


func _enter_tree() -> void:
	print("Clusters Server Plugin: Enabled")


func _exit_tree() -> void:
	print("Clusters Server Plugin: Disabled")
