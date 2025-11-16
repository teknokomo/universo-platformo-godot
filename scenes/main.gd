extends Control
## Main scene controller for Universo Platformo
##
## This is the entry point of the application, handling initialization
## and providing a basic UI for server/client mode selection.


@onready var status_label: Label = $VBoxContainer/Status


func _ready() -> void:
	update_status("Ready")
	
	# Connect to network manager signals
	NetworkManager.server_started.connect(_on_server_started)
	NetworkManager.connected_to_server.connect(_on_connected_to_server)
	NetworkManager.connection_failed.connect(_on_connection_failed)
	
	# Initialize database connection
	DatabaseManager.connect_database()


func update_status(message: String) -> void:
	if status_label:
		status_label.text = "Status: %s" % message
	print("Status: %s" % message)


func _on_start_server_button_pressed() -> void:
	update_status("Starting server...")
	if NetworkManager.start_server():
		update_status("Server running on port %d" % NetworkManager.server_port)
	else:
		update_status("Failed to start server")


func _on_connect_client_button_pressed() -> void:
	var server_address := "127.0.0.1"
	update_status("Connecting to server at %s..." % server_address)
	if NetworkManager.connect_to_server(server_address):
		update_status("Connecting...")
	else:
		update_status("Failed to connect")


func _on_server_started() -> void:
	update_status("Server started successfully")


func _on_connected_to_server() -> void:
	update_status("Connected to server")


func _on_connection_failed(error: String) -> void:
	update_status("Connection failed: %s" % error)
