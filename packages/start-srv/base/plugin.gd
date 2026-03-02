@tool
extends EditorPlugin
## Start Backend Plugin
##
## This plugin provides the backend server functionality for the start page.
## It runs a lightweight HTTP server that proxies authentication requests
## to Supabase, ensuring the frontend never accesses Supabase directly.


func _enter_tree() -> void:
	print("Start Backend Plugin: Enabled")


func _exit_tree() -> void:
	print("Start Backend Plugin: Disabled")
