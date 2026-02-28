extends Control
## Authenticated start page for Universo Platformo
##
## Welcome page shown to signed-in users.
## Displays user info and provides access to platform features.

@onready var welcome_label: Label = $VBoxContainer/WelcomeLabel
@onready var email_label: Label = $VBoxContainer/EmailLabel
@onready var sign_out_button: Button = $VBoxContainer/ButtonsContainer/SignOutButton


func _ready() -> void:
	AuthManager.signed_out.connect(_on_signed_out)
	_update_user_info()


func _update_user_info() -> void:
	var user := AuthManager.get_user()
	var email: String = user.get("email", "")

	if email.is_empty():
		welcome_label.text = "Welcome to Universo Platformo!"
		email_label.visible = false
	else:
		welcome_label.text = "Welcome back!"
		email_label.text = email
		email_label.visible = true


func _on_sign_out_button_pressed() -> void:
	sign_out_button.disabled = true
	sign_out_button.text = "Signing out..."
	AuthManager.sign_out()


func _on_signed_out() -> void:
	sign_out_button.disabled = false
	sign_out_button.text = "Sign Out"
	# Auth state change will be handled by the parent start_page
