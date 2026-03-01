extends Node
## Backend server autoload for Universo Platformo
##
## Starts a local HTTP server that the frontend uses instead of calling
## Supabase directly. All Supabase credentials are held here on the backend;
## the frontend only knows the local backend URL (127.0.0.1:BACKEND_PORT).

## Public references to sub-components (accessible for testing / extension)
var http_server: Node
var auth_api: Node


func _ready() -> void:
	_start_server()


func _start_server() -> void:
	var HTTPServerScript: GDScript = load(
		"res://packages/start-srv/base/scripts/http_server.gd"
	)
	var AuthAPIScript: GDScript = load(
		"res://packages/start-srv/base/scripts/auth_api.gd"
	)

	http_server = HTTPServerScript.new()
	http_server.name = "HTTPServer"
	add_child(http_server)

	auth_api = AuthAPIScript.new()
	auth_api.name = "AuthAPI"
	add_child(auth_api)

	var port_str := Config.get_env("BACKEND_PORT", "8080")
	var port := int(port_str)
	if port < 1 or port > 65535:
		push_error(
			"BackendServer: Invalid BACKEND_PORT '%s'; falling back to 8080" % port_str
		)
		port = 8080
	if http_server.listen(port, "127.0.0.1"):
		auth_api.register_routes(http_server)
		print("BackendServer: Running on http://127.0.0.1:%d" % port)
	else:
		push_error("BackendServer: Failed to start on port %d" % port)
