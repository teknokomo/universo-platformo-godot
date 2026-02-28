extends Node
## Simple HTTP/1.1 server for Godot 4
##
## Accepts TCP connections, parses HTTP requests, and dispatches them to
## registered route handlers. Used by the backend to expose a local API
## that the frontend calls instead of reaching Supabase directly.

## Maximum accepted request size (64 KB)
const MAX_REQUEST_BYTES := 65536

## Registered route handlers: "METHOD /path" -> Callable(req, peer)
var _routes: Dictionary = {}

var _tcp_server := TCPServer.new()

## Pending connections: Array of { peer: StreamPeerTCP, buffer: PackedByteArray }
var _connections: Array[Dictionary] = []


## Start listening on the given address and port
func listen(port: int, address: String = "127.0.0.1") -> bool:
	var err := _tcp_server.listen(port, address)
	if err != OK:
		push_error("HTTPServer: Cannot bind to %s:%d (error %d)" % [address, port, err])
		return false
	set_process(true)
	print("HTTPServer: Listening on %s:%d" % [address, port])
	return true


## Stop the server and close all connections
func stop() -> void:
	_tcp_server.stop()
	set_process(false)
	_connections.clear()


## Register a route handler
## handler signature: func(request: Dictionary, peer: StreamPeerTCP) -> void
func add_route(method: String, path: String, handler: Callable) -> void:
	_routes[method.to_upper() + " " + path] = handler


## Send an HTTP JSON response and close the connection
func send_response(peer: StreamPeerTCP, status_code: int, body: String) -> void:
	if peer.get_status() != StreamPeerTCP.STATUS_CONNECTED:
		return
	var body_bytes := body.to_utf8_buffer()
	var header := (
		"HTTP/1.1 %d %s\r\n" % [status_code, _status_text(status_code)]
		+ "Content-Type: application/json; charset=utf-8\r\n"
		+ "Content-Length: %d\r\n" % body_bytes.size()
		+ "Connection: close\r\n"
		+ "\r\n"
	)
	var packet := header.to_utf8_buffer()
	packet.append_array(body_bytes)
	peer.put_data(packet)
	peer.disconnect_from_host()


func _process(_delta: float) -> void:
	# Accept new connections
	while _tcp_server.is_connection_available():
		_connections.push_back({
			"peer": _tcp_server.take_connection(),
			"buffer": PackedByteArray()
		})

	# Process pending connections (iterate backwards for safe removal)
	var i := _connections.size() - 1
	while i >= 0:
		var conn: Dictionary = _connections[i]
		var peer: StreamPeerTCP = conn["peer"]
		var remove := false

		match peer.get_status():
			StreamPeerTCP.STATUS_CONNECTED:
				var avail := peer.get_available_bytes()
				if avail > 0:
					var chunk := peer.get_data(avail)
					if chunk[0] == OK:
						conn["buffer"].append_array(chunk[1])

				if conn["buffer"].size() > MAX_REQUEST_BYTES:
					send_response(peer, 413, '{"error":"Request too large"}')
					remove = true
				else:
					var req := _parse_request(conn["buffer"])
					if not req.is_empty():
						_dispatch(peer, req)
						remove = true

			StreamPeerTCP.STATUS_NONE, StreamPeerTCP.STATUS_ERROR:
				remove = true

		if remove:
			_connections.remove_at(i)
		i -= 1


func _parse_request(buf: PackedByteArray) -> Dictionary:
	var raw := buf.get_string_from_utf8()
	var sep := raw.find("\r\n\r\n")
	if sep == -1:
		return {}  # Incomplete — wait for more data

	var header_section := raw.substr(0, sep)
	var body_offset := sep + 4

	# Parse request line (first line)
	var first_nl := header_section.find("\r\n")
	var req_line := header_section.substr(0, first_nl if first_nl >= 0 else header_section.length())
	var parts := req_line.split(" ", false, 2)
	if parts.size() < 2:
		return {}

	# Parse headers
	var headers: Dictionary = {}
	for line in header_section.split("\r\n").slice(1):
		var colon := line.find(":")
		if colon > 0:
			var key := line.substr(0, colon).strip_edges().to_lower()
			headers[key] = line.substr(colon + 1).strip_edges()

	# Verify body is fully received
	var content_length := int(headers.get("content-length", "0"))
	if buf.size() - body_offset < content_length:
		return {}  # Body not yet complete

	# Strip query string from path
	var path := parts[1].split("?")[0]

	return {
		"method": parts[0],
		"path": path,
		"headers": headers,
		"body": raw.substr(body_offset, content_length)
	}


func _dispatch(peer: StreamPeerTCP, req: Dictionary) -> void:
	var key: String = req["method"].to_upper() + " " + req["path"]
	if _routes.has(key):
		_routes[key].call(req, peer)
	else:
		send_response(peer, 404, '{"error":"Not found"}')


func _status_text(code: int) -> String:
	match code:
		200: return "OK"
		201: return "Created"
		400: return "Bad Request"
		401: return "Unauthorized"
		403: return "Forbidden"
		404: return "Not Found"
		413: return "Payload Too Large"
		500: return "Internal Server Error"
		502: return "Bad Gateway"
		503: return "Service Unavailable"
		_: return "Unknown"
