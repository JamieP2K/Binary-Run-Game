extends Control

# Loading the main menu allows the player to traverse back to the menu from a button

@onready var main_menu = load("res://scenes/main menu/main_menu.tscn") as PackedScene


func _on_back_button_down() -> void:
	AudioManager.click_button.play()
	get_tree().change_scene_to_packed(main_menu)

# Allows the user to toggle between windowed mode and exclusive-fullscreen mode

# A generic button is used here rather than a flip switch button as the state of the flip switch
# kept resetting whenever the scene reloaded. This was a graphical inconsistency.

func _on_fullscreen_button_down() -> void:
	if DisplayServer.window_get_mode() != 0:
		DisplayServer.window_set_mode(0)
	else:
		DisplayServer.window_set_mode(4)
