extends Node

#Ensures that all of the audio nodes are accessible anywhere in the program

@onready var correct: AudioStreamPlayer = $Correct
@onready var incorrect: AudioStreamPlayer = $Incorrect
@onready var click_button: AudioStreamPlayer = $ClickButton
@onready var game_over: AudioStreamPlayer = $GameOver
@onready var pause: AudioStreamPlayer = $Pause
@onready var unpause: AudioStreamPlayer = $Unpause
@onready var switch_lane: AudioStreamPlayer = $SwitchLane
@onready var running_theme: AudioStreamPlayer = $RunningTheme
@onready var main_menu_theme: AudioStreamPlayer = $MainMenuTheme
