extends Control
## Guest start page for Universo Platformo
##
## Landing page shown to non-authenticated users.
## Provides sign-in and sign-up functionality via Supabase auth.

@onready var email_input: LineEdit = $VBoxContainer/FormContainer/EmailInput
@onready var password_input: LineEdit = $VBoxContainer/FormContainer/PasswordInput
@onready var sign_in_button: Button = $VBoxContainer/FormContainer/ButtonsContainer/SignInButton
@onready var sign_up_button: Button = $VBoxContainer/FormContainer/ButtonsContainer/SignUpButton
@onready var status_label: Label = $VBoxContainer/StatusLabel
@onready var loading_label: Label = $VBoxContainer/LoadingLabel


func _ready() -> void:
	AuthManager.signed_in.connect(_on_signed_in)
	AuthManager.sign_in_failed.connect(_on_sign_in_failed)
	AuthManager.sign_up_failed.connect(_on_sign_up_failed)


func _on_sign_in_button_pressed() -> void:
	var email := email_input.text.strip_edges()
	var password := password_input.text

	if email.is_empty() or password.is_empty():
		_show_status("Please enter your email and password", true)
		return

	_start_loading("Signing in...")
	AuthManager.sign_in(email, password)


func _on_sign_up_button_pressed() -> void:
	var email := email_input.text.strip_edges()
	var password := password_input.text

	if email.is_empty() or password.is_empty():
		_show_status("Please enter your email and password", true)
		return

	_start_loading("Creating account...")
	AuthManager.sign_up(email, password)


func _start_loading(message: String) -> void:
	loading_label.text = message
	loading_label.visible = true
	status_label.visible = false
	sign_in_button.disabled = true
	sign_up_button.disabled = true
	email_input.editable = false
	password_input.editable = false


func _stop_loading() -> void:
	loading_label.visible = false
	sign_in_button.disabled = false
	sign_up_button.disabled = false
	email_input.editable = true
	password_input.editable = true


func _show_status(message: String, is_error: bool = false) -> void:
	status_label.text = message
	status_label.visible = true
	if is_error:
		status_label.modulate = Color(1.0, 0.3, 0.3, 1.0)
	else:
		status_label.modulate = Color(0.3, 1.0, 0.3, 1.0)


func _on_signed_in(_user: Dictionary) -> void:
	_stop_loading()
	if _user.is_empty():
		_show_status("Account created! Please check your email to confirm.", false)
	# Auth state change will be handled by the parent start_page


func _on_sign_in_failed(error: String) -> void:
	_stop_loading()
	_show_status("Sign in failed: %s" % error, true)


func _on_sign_up_failed(error: String) -> void:
	_stop_loading()
	_show_status("Sign up failed: %s" % error, true)
