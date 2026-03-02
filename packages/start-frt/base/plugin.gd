@tool
extends EditorPlugin
## Start Frontend Plugin
##
## This plugin provides the start page functionality for Universo Platformo.
## It includes a guest landing page for unauthenticated users and an
## authenticated page for signed-in users, with Supabase auth integration.


func _enter_tree() -> void:
	print("Start Frontend Plugin: Enabled")


func _exit_tree() -> void:
	print("Start Frontend Plugin: Disabled")
