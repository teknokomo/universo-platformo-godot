extends Node
## Global configuration manager for Universo Platformo
##
## This autoload manages application-wide configuration including
## environment variables, feature flags, and runtime settings.

## Configuration constants
const CONFIG_FILE_PATH := "res://config.json"
const ENV_FILE_PATH := "res://.env"

## Configuration dictionary
var config := {}

## Environment variables
var env := {}


func _ready() -> void:
	load_configuration()
	load_environment()


## Load configuration from JSON file
func load_configuration() -> void:
	if not FileAccess.file_exists(CONFIG_FILE_PATH):
		push_warning("Configuration file not found: %s" % CONFIG_FILE_PATH)
		return
	
	var file := FileAccess.open(CONFIG_FILE_PATH, FileAccess.READ)
	if file:
		var json := JSON.new()
		var parse_result := json.parse(file.get_as_text())
		if parse_result == OK:
			config = json.data
		else:
			push_error("Failed to parse configuration file: %s" % json.get_error_message())
		file.close()


## Load environment variables from .env file
func load_environment() -> void:
	if not FileAccess.file_exists(ENV_FILE_PATH):
		push_warning("Environment file not found: %s" % ENV_FILE_PATH)
		return
	
	var file := FileAccess.open(ENV_FILE_PATH, FileAccess.READ)
	if file:
		while not file.eof_reached():
			var line := file.get_line().strip_edges()
			if line.is_empty() or line.begins_with("#"):
				continue
			
			var parts := line.split("=", true, 1)
			if parts.size() == 2:
				env[parts[0].strip_edges()] = parts[1].strip_edges()
		file.close()


## Get configuration value with optional default
func get_config(key: String, default = null):
	return config.get(key, default)


## Get environment variable with optional default
func get_env(key: String, default: String = "") -> String:
	return env.get(key, default)


## Check if feature is enabled
func is_feature_enabled(feature_name: String) -> bool:
	var features = config.get("features", {})
	return features.get(feature_name, false)
