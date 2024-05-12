extends Control

@onready var retry_button = $MarginContainer/HBoxContainer/VBoxContainer/Retry as Button
@onready var mainmenu_button = $"MarginContainer/HBoxContainer/VBoxContainer/Main Menu" as Button
@onready var restart_level = load("res://scenes/runner/runner.tscn") as PackedScene
@onready var main_menu = load("res://scenes/main menu/main_menu.tscn") as PackedScene

# Global score singleton is read from here
# Displays the user's score on game over

func _ready():
	AudioManager.propagate_call("stop")
	AudioManager.game_over.play()
	$MarginContainer/VBoxContainer/Label2.set_text(str("Your Score: ", GlobalScore.score))
	retry_button.button_down.connect(on_start_pressed)
	mainmenu_button.button_down.connect(on_exit_pressed)

func on_start_pressed() -> void:
	AudioManager.propagate_call("stop")
	AudioManager.running_theme.play()
	get_tree().change_scene_to_packed(restart_level)
	
func on_exit_pressed() -> void:
	AudioManager.propagate_call("stop")
	get_tree().change_scene_to_packed(main_menu)
