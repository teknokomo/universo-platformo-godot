extends Node
## Network manager for Universo Platformo
##
## This autoload manages network connections and multiplayer functionality.
## Handles both peer-to-peer and client-server architectures.

signal peer_connected(peer_id: int)
signal peer_disconnected(peer_id: int)
signal server_started
signal server_stopped
signal connected_to_server
signal connection_failed(error: String)

## Network configuration
var is_server := false
var is_client := false
var server_port := 7777
var max_clients := 32

## Multiplayer peer
var peer: MultiplayerPeer


func _ready() -> void:
	load_network_config()
	multiplayer.peer_connected.connect(_on_peer_connected)
	multiplayer.peer_disconnected.connect(_on_peer_disconnected)
	multiplayer.connected_to_server.connect(_on_connected_to_server)
	multiplayer.connection_failed.connect(_on_connection_failed)
	multiplayer.server_disconnected.connect(_on_server_disconnected)


## Load network configuration from Config autoload
func load_network_config() -> void:
	server_port = int(Config.get_env("SERVER_PORT", "7777"))
	max_clients = int(Config.get_config("max_clients", 32))


## Start server
func start_server(port: int = server_port) -> bool:
	peer = ENetMultiplayerPeer.new()
	var error := peer.create_server(port, max_clients)
	
	if error != OK:
		push_error("Failed to start server: %s" % error)
		return false
	
	multiplayer.multiplayer_peer = peer
	is_server = true
	server_started.emit()
	print("Server started on port %d" % port)
	return true


## Connect to server as client
func connect_to_server(address: String, port: int = server_port) -> bool:
	peer = ENetMultiplayerPeer.new()
	var error := peer.create_client(address, port)
	
	if error != OK:
		push_error("Failed to connect to server: %s" % error)
		return false
	
	multiplayer.multiplayer_peer = peer
	is_client = true
	print("Connecting to server at %s:%d" % [address, port])
	return true


## Disconnect from network
func disconnect_network() -> void:
	if peer:
		peer.close()
		peer = null
	
	multiplayer.multiplayer_peer = null
	is_server = false
	is_client = false
	
	if is_server:
		server_stopped.emit()
	
	print("Disconnected from network")


## Send data to specific peer
func send_to_peer(peer_id: int, data: Variant) -> void:
	if not multiplayer.multiplayer_peer:
		push_warning("Cannot send data: not connected to network")
		return
	
	# Use RPC for sending data
	rpc_id(peer_id, "_receive_data", data)


## Send data to all peers
func send_to_all(data: Variant) -> void:
	if not multiplayer.multiplayer_peer:
		push_warning("Cannot send data: not connected to network")
		return
	
	# Use RPC for broadcasting data
	rpc("_receive_data", data)


## RPC function to receive data
@rpc("any_peer", "call_remote")
func _receive_data(data: Variant) -> void:
	# Override this in connected scripts to handle received data
	pass


## Signal handlers
func _on_peer_connected(id: int) -> void:
	print("Peer connected: %d" % id)
	peer_connected.emit(id)


func _on_peer_disconnected(id: int) -> void:
	print("Peer disconnected: %d" % id)
	peer_disconnected.emit(id)


func _on_connected_to_server() -> void:
	print("Successfully connected to server")
	connected_to_server.emit()


func _on_connection_failed() -> void:
	print("Failed to connect to server")
	connection_failed.emit("Connection failed")


func _on_server_disconnected() -> void:
	print("Disconnected from server")
	disconnect_network()
