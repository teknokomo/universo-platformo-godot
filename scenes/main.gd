extends Control
## Main scene controller for Universo Platformo
##
## Entry point of the application. Routes between the guest start page
## (for unauthenticated users) and the authenticated start page
## (for signed-in users) based on Supabase auth state.


@onready var loading_container: CenterContainer = $LoadingContainer
@onready var guest_start_page: Control = $GuestStartPage
@onready var authenticated_start_page: Control = $AuthenticatedStartPage


func _ready() -> void:
	# Connect to auth state signals
	AuthManager.auth_state_changed.connect(_on_auth_state_changed)
	AuthManager.signed_in.connect(_on_signed_in)
	AuthManager.signed_out.connect(_on_signed_out)

	# Initialize database connection
	DatabaseManager.connect_database()

	# Defer auth check to allow autoloads to finish initialization
	call_deferred("_check_auth_state")


func _check_auth_state() -> void:
	_update_view(AuthManager.is_authenticated)


func _show_loading() -> void:
	loading_container.visible = true
	guest_start_page.visible = false
	authenticated_start_page.visible = false


func _update_view(is_authenticated: bool) -> void:
	loading_container.visible = false
	if is_authenticated:
		guest_start_page.visible = false
		authenticated_start_page.visible = true
	else:
		guest_start_page.visible = true
		authenticated_start_page.visible = false


func _on_auth_state_changed(is_authenticated: bool) -> void:
	_update_view(is_authenticated)


func _on_signed_in(_user: Dictionary) -> void:
	if AuthManager.is_authenticated:
		_update_view(true)


func _on_signed_out() -> void:
	_update_view(false)
