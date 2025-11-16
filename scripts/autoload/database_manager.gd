extends Node
## Database manager for Universo Platformo
##
## This autoload manages database connections and operations.
## Currently supports Supabase with extensibility for other databases.

signal connection_established
signal connection_failed(error: String)
signal query_completed(result: Dictionary)
signal query_failed(error: String)

## Database configuration
var database_url := ""
var database_key := ""
var database_type := "supabase"

## Connection state
var is_connected := false


func _ready() -> void:
	load_database_config()


## Load database configuration from Config autoload
func load_database_config() -> void:
	database_url = Config.get_env("SUPABASE_URL", "")
	database_key = Config.get_env("SUPABASE_KEY", "")
	database_type = Config.get_config("database_type", "supabase")
	
	if database_url.is_empty() or database_key.is_empty():
		push_warning("Database credentials not configured")


## Initialize database connection
func connect_database() -> void:
	if database_url.is_empty() or database_key.is_empty():
		connection_failed.emit("Database credentials not configured")
		return
	
	# TODO: Implement actual connection logic
	# For now, just emit success
	is_connected = true
	connection_established.emit()
	print("Database connection established: %s" % database_type)


## Execute a database query
func query(table: String, operation: String, data: Dictionary = {}) -> void:
	if not is_connected:
		query_failed.emit("Database not connected")
		return
	
	# TODO: Implement actual query logic
	# This is a placeholder for the database interface
	print("Executing query: %s on %s" % [operation, table])
	query_completed.emit({"success": true, "data": []})


## Insert data into a table
func insert(table: String, data: Dictionary) -> void:
	query(table, "insert", data)


## Select data from a table
func select(table: String, filters: Dictionary = {}) -> void:
	query(table, "select", filters)


## Update data in a table
func update(table: String, data: Dictionary, filters: Dictionary = {}) -> void:
	var query_data := {"data": data, "filters": filters}
	query(table, "update", query_data)


## Delete data from a table
func delete(table: String, filters: Dictionary) -> void:
	query(table, "delete", filters)
