extends Control

# @Onready is shorthand for assigning the variables in the _ready() function
# Create and assign all of these variables at the start up of the scene
@onready var start_button = $MarginContainer/HBoxContainer/VBoxContainer/Start as Button
@onready var options_button = $MarginContainer/HBoxContainer/VBoxContainer/Options as Button
@onready var exit_button = $MarginContainer/HBoxContainer/VBoxContainer/Exit as Button

# Preload loads the resource as soon as the scene is opened
# Load loads the resource when it is called

# Load is used here rather than preload as these scenes are not 
# necessary to be loaded in until they are opened

@onready var mode_select = load("res://scenes/mode select/mode_select.tscn") as PackedScene
@onready var options_menu = load("res://scenes/options menu/options_menu.tscn") as PackedScene

# Checks to see if the audio manager is playing something already. If it is not, then play the menu theme
# This is used to allow the main menu music to play across the various submenus without repeating
# Also allows the menu music to be played again when returning from a game over
func _ready():
	if !AudioManager.main_menu_theme.playing:
		AudioManager.main_menu_theme.play()

# The following buttons play sound effects when clicked and transition the scene to a different scene
func _on_start_button_down() -> void:
	AudioManager.click_button.play()
	get_tree().change_scene_to_packed(mode_select)

func _on_options_button_down() -> void:
	AudioManager.click_button.play()
	get_tree().change_scene_to_packed(options_menu)

# The timeout method is used here to wait 0.13 seconds before closing the game
# This is done to allow the sound effect of clicking the button to play fully before closing the game
func _on_exit_button_down() -> void:
	AudioManager.click_button.play()
	await get_tree().create_timer(0.13).timeout
	get_tree().quit()



