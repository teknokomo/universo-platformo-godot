@tool
extends EditorPlugin
## Clusters Frontend Plugin
##
## This plugin provides the client-side functionality for the Clusters system.
## It manages the UI and client-side logic for Clusters, Domains, and Resources.


func _enter_tree() -> void:
	print("Clusters Frontend Plugin: Enabled")


func _exit_tree() -> void:
	print("Clusters Frontend Plugin: Disabled")
