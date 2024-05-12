extends Control

# Allows the user to toggle between windowed mode and exclusive-fullscreen mode
# This option is provided here in the pause menu for convenience

func _on_fullscreen_button_down() -> void:
	if DisplayServer.window_get_mode() != 0:
		DisplayServer.window_set_mode(0)
	else:
		DisplayServer.window_set_mode(4)
