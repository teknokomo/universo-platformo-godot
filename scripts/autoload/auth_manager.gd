extends Node
## Authentication manager for Universo Platformo
##
## Handles Supabase authentication via HTTP requests.
## Provides sign-in, sign-up, and sign-out functionality.
## Stores session data locally for persistence between runs.

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

## Supabase configuration
var _supabase_url := ""
var _supabase_key := ""

## Session file path
const SESSION_FILE := "user://session.json"


func _ready() -> void:
	_load_config()
	_restore_session()


## Load Supabase credentials from Config autoload
func _load_config() -> void:
	_supabase_url = Config.get_env("SUPABASE_URL", "")
	_supabase_key = Config.get_env("SUPABASE_KEY", "")

	if _supabase_url.is_empty() or _supabase_key.is_empty():
		push_warning("AuthManager: Supabase credentials not configured")


## Sign in with email and password via Supabase REST API
func sign_in(email: String, password: String) -> void:
	if _supabase_url.is_empty() or _supabase_key.is_empty():
		sign_in_failed.emit("Supabase credentials not configured")
		return

	var url := "%s/auth/v1/token?grant_type=password" % _supabase_url
	var headers := PackedStringArray([
		"Content-Type: application/json",
		"apikey: %s" % _supabase_key
	])
	var body := JSON.stringify({"email": email, "password": password})

	var http := HTTPRequest.new()
	add_child(http)
	http.request_completed.connect(_on_sign_in_completed.bind(http))
	http.request(url, headers, HTTPClient.METHOD_POST, body)


## Sign up with email and password via Supabase REST API
func sign_up(email: String, password: String) -> void:
	if _supabase_url.is_empty() or _supabase_key.is_empty():
		sign_up_failed.emit("Supabase credentials not configured")
		return

	var url := "%s/auth/v1/signup" % _supabase_url
	var headers := PackedStringArray([
		"Content-Type: application/json",
		"apikey: %s" % _supabase_key
	])
	var body := JSON.stringify({"email": email, "password": password})

	var http := HTTPRequest.new()
	add_child(http)
	http.request_completed.connect(_on_sign_up_completed.bind(http))
	http.request(url, headers, HTTPClient.METHOD_POST, body)


## Sign out and clear session
func sign_out() -> void:
	if not is_authenticated:
		return

	if not _supabase_url.is_empty() and not access_token.is_empty():
		var url := "%s/auth/v1/logout" % _supabase_url
		var headers := PackedStringArray([
			"Content-Type: application/json",
			"apikey: %s" % _supabase_key,
			"Authorization: Bearer %s" % access_token
		])

		var http := HTTPRequest.new()
		add_child(http)
		http.request_completed.connect(_on_sign_out_completed.bind(http))
		http.request(url, headers, HTTPClient.METHOD_POST, "")

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
		# Note: we restore the session optimistically without verifying token expiry.
		# If the token has expired, Supabase API calls will return 401 and the user
		# will need to sign in again. A future improvement could check expires_at
		# from the session data or call /auth/v1/user to validate before restoring.
		is_authenticated = true
		print("AuthManager: Session restored for %s" % current_user.get("email", "unknown"))


## Clear all session data
func _clear_session() -> void:
	is_authenticated = false
	current_user = {}
	access_token = ""
	refresh_token = ""

	if FileAccess.file_exists(SESSION_FILE):
		DirAccess.remove_absolute(SESSION_FILE)


func _on_sign_in_completed(result: int, response_code: int, _headers: PackedStringArray, body: PackedByteArray, http: HTTPRequest) -> void:
	http.queue_free()

	if result != HTTPRequest.RESULT_SUCCESS:
		sign_in_failed.emit("Network error: %d" % result)
		return

	var json := JSON.new()
	var parse_result := json.parse(body.get_string_from_utf8())

	if parse_result != OK:
		sign_in_failed.emit("Invalid response format")
		return

	var data: Dictionary = json.data

	if response_code != 200:
		var error_msg: String = data.get("error_description", data.get("msg", "Sign in failed"))
		sign_in_failed.emit(error_msg)
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
		sign_up_failed.emit("Network error: %d" % result)
		return

	var json := JSON.new()
	var parse_result := json.parse(body.get_string_from_utf8())

	if parse_result != OK:
		sign_up_failed.emit("Invalid response format")
		return

	var data: Dictionary = json.data

	# Supabase sign-up returns 200 with a user+token when email confirmation is disabled,
	# or 200/201 for other configurations. We accept any 2xx success code.
	if response_code < 200 or response_code >= 300:
		var error_msg: String = data.get("error_description", data.get("msg", "Sign up failed"))
		sign_up_failed.emit(error_msg)
		return

	# Auto sign-in after signup if token is provided (email confirmation disabled)
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
		# Email confirmation required — user is created but not yet signed in
		print("AuthManager: Sign up successful, email confirmation required")
		signed_in.emit({})


func _on_sign_out_completed(_result: int, _response_code: int, _headers: PackedStringArray, _body: PackedByteArray, http: HTTPRequest) -> void:
	http.queue_free()
	print("AuthManager: Sign out API call completed")
