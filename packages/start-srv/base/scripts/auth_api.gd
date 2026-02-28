extends Node
## Auth API backend handler for Universo Platformo
##
## Runs on the backend (server side). Proxies authentication requests to
## Supabase. The frontend never calls Supabase directly — only this module does.
##
## Routes registered on the HTTPServer:
##   POST /api/auth/sign-in   — email + password sign-in
##   POST /api/auth/sign-up   — email + password sign-up
##   POST /api/auth/sign-out  — invalidate session token

## Reference to the HTTPServer node
var _http_server: Node

## Supabase credentials — backend-only, never exposed to frontend
var _supabase_url := ""
var _supabase_key := ""


func _ready() -> void:
	_supabase_url = Config.get_env("SUPABASE_URL", "")
	_supabase_key = Config.get_env("SUPABASE_KEY", "")
	if _supabase_url.is_empty() or _supabase_key.is_empty():
		push_warning("AuthAPI: SUPABASE_URL / SUPABASE_KEY not set in .env")


## Register all auth routes on the given HTTPServer node
func register_routes(http_server: Node) -> void:
	_http_server = http_server
	http_server.add_route("POST", "/api/auth/sign-in", _handle_sign_in)
	http_server.add_route("POST", "/api/auth/sign-up", _handle_sign_up)
	http_server.add_route("POST", "/api/auth/sign-out", _handle_sign_out)
	print("AuthAPI: Routes registered (/api/auth/sign-in, /api/auth/sign-up, /api/auth/sign-out)")


## POST /api/auth/sign-in
## Body: { "email": "...", "password": "..." }
func _handle_sign_in(request: Dictionary, peer: StreamPeerTCP) -> void:
	if not _check_credentials(peer):
		return

	var json := _parse_body(request["body"])
	if json == null:
		_http_server.send_response(peer, 400, '{"error":"Invalid JSON body"}')
		return

	var url := "%s/auth/v1/token?grant_type=password" % _supabase_url
	var headers := PackedStringArray([
		"Content-Type: application/json",
		"apikey: %s" % _supabase_key
	])
	var body := JSON.stringify({
		"email": json.get("email", ""),
		"password": json.get("password", "")
	})
	_proxy_to_supabase(peer, url, HTTPClient.METHOD_POST, headers, body)


## POST /api/auth/sign-up
## Body: { "email": "...", "password": "..." }
func _handle_sign_up(request: Dictionary, peer: StreamPeerTCP) -> void:
	if not _check_credentials(peer):
		return

	var json := _parse_body(request["body"])
	if json == null:
		_http_server.send_response(peer, 400, '{"error":"Invalid JSON body"}')
		return

	var url := "%s/auth/v1/signup" % _supabase_url
	var headers := PackedStringArray([
		"Content-Type: application/json",
		"apikey: %s" % _supabase_key
	])
	var body := JSON.stringify({
		"email": json.get("email", ""),
		"password": json.get("password", "")
	})
	_proxy_to_supabase(peer, url, HTTPClient.METHOD_POST, headers, body)


## POST /api/auth/sign-out
## Body: { "access_token": "..." }
func _handle_sign_out(request: Dictionary, peer: StreamPeerTCP) -> void:
	if not _check_credentials(peer):
		return

	var json := _parse_body(request["body"])
	if json == null:
		_http_server.send_response(peer, 400, '{"error":"Invalid JSON body"}')
		return

	var token: String = json.get("access_token", "")
	if token.is_empty():
		_http_server.send_response(peer, 400, '{"error":"access_token required"}')
		return

	var url := "%s/auth/v1/logout" % _supabase_url
	var headers := PackedStringArray([
		"Content-Type: application/json",
		"apikey: %s" % _supabase_key,
		"Authorization: Bearer %s" % token
	])
	_proxy_to_supabase(peer, url, HTTPClient.METHOD_POST, headers, "{}")


## Return false and send 503 if Supabase credentials are missing
func _check_credentials(peer: StreamPeerTCP) -> bool:
	if _supabase_url.is_empty() or _supabase_key.is_empty():
		_http_server.send_response(peer, 503,
			'{"error":"Backend not configured: missing SUPABASE_URL or SUPABASE_KEY"}')
		return false
	return true


## Parse JSON body, returning null on failure
func _parse_body(body: String) -> Variant:
	if body.is_empty():
		return null
	var result := JSON.parse_string(body)
	if not result is Dictionary:
		return null
	return result


## Forward a request to Supabase and relay the response back to the peer
func _proxy_to_supabase(
	peer: StreamPeerTCP,
	url: String,
	method: int,
	headers: PackedStringArray,
	body: String
) -> void:
	var http := HTTPRequest.new()
	add_child(http)
	http.request_completed.connect(_on_proxy_done.bind(peer, http))
	var err := http.request(url, headers, method, body)
	if err != OK:
		http.queue_free()
		_http_server.send_response(peer, 502, '{"error":"Failed to reach Supabase"}')


## Relay Supabase response back to the waiting frontend peer
func _on_proxy_done(
	result: int,
	response_code: int,
	_resp_headers: PackedStringArray,
	body: PackedByteArray,
	peer: StreamPeerTCP,
	http: HTTPRequest
) -> void:
	http.queue_free()
	if result != HTTPRequest.RESULT_SUCCESS:
		_http_server.send_response(peer, 502, '{"error":"Supabase connection error"}')
		return
	_http_server.send_response(peer, response_code, body.get_string_from_utf8())
