extends Control

@onready var decimal_button = $MarginContainer/HBoxContainer/VBoxContainer/DecimalToBinary as Button
@onready var binary_button = $MarginContainer/HBoxContainer/VBoxContainer/BinaryToDecimal as Button
@onready var decimal_to_binary = load("res://scenes/runner/runner.tscn") as PackedScene
@onready var binary_to_decimal = load("res://scenes/runner/runner.tscn") as PackedScene
@onready var tutorial = load("res://scenes/tutorial/tutorial.tscn") as PackedScene
@onready var main_menu = load("res://scenes/main menu/main_menu.tscn") as PackedScene


func _ready():
	decimal_button.button_down.connect(on_decimal_pressed)
	binary_button.button_down.connect(on_binary_pressed)

func _on_tutorial_pressed() -> void:
	AudioManager.click_button.play()
	get_tree().change_scene_to_packed(tutorial)

# Propagation calls are used here to stop all music and sound effects playing
# This stops the menu music from playing and allows the game music to play without overlapping

# GlobalScore.decimaltobinary is used here as a way of determining what gamemode to launch
# This is used in other scenes to determine what functions to use when generating questions

func on_decimal_pressed() -> void:
	AudioManager.propagate_call("stop")
	AudioManager.click_button.play()
	AudioManager.running_theme.play()
	GlobalScore.decimaltobinary = true
	get_tree().change_scene_to_packed(decimal_to_binary)
	
func on_binary_pressed() -> void:
	AudioManager.propagate_call("stop")
	AudioManager.click_button.play()
	AudioManager.running_theme.play()
	GlobalScore.decimaltobinary = false
	get_tree().change_scene_to_packed(binary_to_decimal)


func _on_back_button_down() -> void:
	AudioManager.click_button.play()
	get_tree().change_scene_to_packed(main_menu)
