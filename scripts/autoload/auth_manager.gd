extends Node
## Authentication manager for Universo Platformo (Frontend)
##
## Routes all authentication requests through the local backend server.
## The frontend NEVER calls Supabase directly — only the backend does.
## SUPABASE_URL and SUPABASE_KEY are backend-only credentials.
##
## Call flow:  AuthManager → BackendServer (127.0.0.1:BACKEND_PORT) → Supabase

signal signed_in(user: Dictionary)
signal signed_out
signal sign_in_failed(error: String)
signal sign_up_failed(error: String)
signal auth_state_changed(is_authenticated: bool)

## Current authentication state
var is_authenticated := false
var current_user := {}
var access_token := ""
var refresh_token := ""

## Backend API base URL (local server, never Supabase)
var _backend_url := ""

## Session file path
const SESSION_FILE := "user://session.json"


func _ready() -> void:
	_load_config()
	_restore_session()


## Build backend URL from BACKEND_PORT env variable
func _load_config() -> void:
	var port_env := Config.get_env("BACKEND_PORT", "8080")
	var port := int(port_env)
	if port < 1 or port > 65535:
		port = 8080
	_backend_url = "http://127.0.0.1:%d" % port


## Sign in with email and password — routed through backend
func sign_in(email: String, password: String) -> void:
	var url := "%s/api/auth/sign-in" % _backend_url
	var headers := PackedStringArray(["Content-Type: application/json"])
	var body := JSON.stringify({"email": email, "password": password})

	var http := HTTPRequest.new()
	add_child(http)
	http.request_completed.connect(_on_sign_in_completed.bind(http))
	http.request(url, headers, HTTPClient.METHOD_POST, body)


## Sign up with email and password — routed through backend
func sign_up(email: String, password: String) -> void:
	var url := "%s/api/auth/sign-up" % _backend_url
	var headers := PackedStringArray(["Content-Type: application/json"])
	var body := JSON.stringify({"email": email, "password": password})

	var http := HTTPRequest.new()
	add_child(http)
	http.request_completed.connect(_on_sign_up_completed.bind(http))
	http.request(url, headers, HTTPClient.METHOD_POST, body)


## Sign out — sends access_token to backend which invalidates it with Supabase
func sign_out() -> void:
	if not is_authenticated:
		return

	if not access_token.is_empty():
		var url := "%s/api/auth/sign-out" % _backend_url
		var headers := PackedStringArray(["Content-Type: application/json"])
		var body := JSON.stringify({"access_token": access_token})

		var http := HTTPRequest.new()
		add_child(http)
		http.request_completed.connect(_on_sign_out_completed.bind(http))
		http.request(url, headers, HTTPClient.METHOD_POST, body)

	_clear_session()
	signed_out.emit()
	auth_state_changed.emit(false)


## Get current user info dictionary
func get_user() -> Dictionary:
	return current_user


## Save session data to local file
func _save_session() -> void:
	var session := {
		"access_token": access_token,
		"refresh_token": refresh_token,
		"user": current_user
	}
	var file := FileAccess.open(SESSION_FILE, FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(session))
		file.close()


## Restore session from local file on startup
func _restore_session() -> void:
	if not FileAccess.file_exists(SESSION_FILE):
		return

	var file := FileAccess.open(SESSION_FILE, FileAccess.READ)
	if not file:
		return

	var json := JSON.new()
	var result := json.parse(file.get_as_text())
	file.close()

	if result != OK or not json.data is Dictionary:
		return

	var session: Dictionary = json.data
	access_token = session.get("access_token", "")
	refresh_token = session.get("refresh_token", "")
	current_user = session.get("user", {})

	if not access_token.is_empty():
		# Session is restored optimistically. If the token has expired the backend
		# will return 401/403 on the next API call and the user must sign in again.
		is_authenticated = true
		print("AuthManager: Session restored for %s" % current_user.get("email", "unknown"))


## Clear all session data and remove local session file
func _clear_session() -> void:
	is_authenticated = false
	current_user = {}
	access_token = ""
	refresh_token = ""

	if FileAccess.file_exists(SESSION_FILE):
		DirAccess.remove_absolute(ProjectSettings.globalize_path(SESSION_FILE))


func _on_sign_in_completed(result: int, response_code: int, _headers: PackedStringArray, body: PackedByteArray, http: HTTPRequest) -> void:
	http.queue_free()

	if result != HTTPRequest.RESULT_SUCCESS:
		sign_in_failed.emit("Backend unavailable (error %d)" % result)
		return

	var json := JSON.new()
	if json.parse(body.get_string_from_utf8()) != OK or not json.data is Dictionary:
		sign_in_failed.emit("Invalid response from backend")
		return

	var data: Dictionary = json.data

	if response_code != 200:
		var msg: String = data.get("error_description", data.get("msg", data.get("error", "Sign in failed")))
		sign_in_failed.emit(msg)
		return

	access_token = data.get("access_token", "")
	refresh_token = data.get("refresh_token", "")
	current_user = data.get("user", {})
	is_authenticated = true

	_save_session()
	print("AuthManager: Signed in as %s" % current_user.get("email", "unknown"))
	signed_in.emit(current_user)
	auth_state_changed.emit(true)


func _on_sign_up_completed(result: int, response_code: int, _headers: PackedStringArray, body: PackedByteArray, http: HTTPRequest) -> void:
	http.queue_free()

	if result != HTTPRequest.RESULT_SUCCESS:
		sign_up_failed.emit("Backend unavailable (error %d)" % result)
		return

	var json := JSON.new()
	if json.parse(body.get_string_from_utf8()) != OK or not json.data is Dictionary:
		sign_up_failed.emit("Invalid response from backend")
		return

	var data: Dictionary = json.data

	# Supabase returns 2xx for success; accept any 2xx code
	if response_code < 200 or response_code >= 300:
		var msg: String = data.get("error_description", data.get("msg", data.get("error", "Sign up failed")))
		sign_up_failed.emit(msg)
		return

	# Auto sign-in when token is present (email confirmation disabled on Supabase)
	if data.has("access_token"):
		access_token = data.get("access_token", "")
		refresh_token = data.get("refresh_token", "")
		current_user = data.get("user", {})
		is_authenticated = true

		_save_session()
		print("AuthManager: Signed up and in as %s" % current_user.get("email", "unknown"))
		signed_in.emit(current_user)
		auth_state_changed.emit(true)
	else:
		# Email confirmation required — account created but not yet active
		print("AuthManager: Sign up successful, email confirmation required")
		signed_in.emit({})


func _on_sign_out_completed(_result: int, _response_code: int, _headers: PackedStringArray, _body: PackedByteArray, http: HTTPRequest) -> void:
	http.queue_free()
	print("AuthManager: Sign out completed")
