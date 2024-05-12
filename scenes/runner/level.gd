extends Node3D


@onready var game_over = load("res://scenes/game over/game_over.tscn") as PackedScene
@onready var main_menu = load("res://scenes/main menu/main_menu.tscn") as PackedScene
@export var modules: Array[PackedScene] = []

@onready var lifetext = $"../HUD/UIElements/Lives"
@onready var pause_menu = $"../HUD/Pause_Menu"

var amnt = 24 # How many modules can exist at once
var freq = 25 # Controls how frequently gates should be spawned
var modules_spawned = 0 # Tracks how many modules were spawned
var rng = RandomNumberGenerator.new()
var offset = 4 # Determines how far apart platforms spawn
var score = 0 # Updated in module1.gd; tracks player's score
var speed = 5
var lives = 5
var paused = false


# Once the game is started, constantly spawns modules

# Background color is set to gray. This is because in module1.gd there is a function that changes
# the color of the background. This color does not revert back between new games
# and so it must be manually reset here
func _ready():
	$"../WorldEnvironment".environment.background_color = Color.GRAY
	lifetext.set_text(str(lives, "♥︎"))
	for n in amnt:
		spawnModule(n*offset)

# Checks every frame if the pause key was pressed, if so pause
# Checked every frame as the pause key should be responsive

# The backspace key is assigned to take the user back to the main menu
# This along with the requirement of being paused ensures the user does not
# accidentally quit back to the menu unintentionally

# Propogate call is used to stop the audio currently playing to prevent overlap in the menu
func _process(_delta):
		if Input.is_action_just_pressed("pause"):
			pauseMenu()
		if (Input.is_action_just_pressed("exit") and paused):
			pauseMenu()
			AudioManager.propagate_call("stop")
			get_tree().change_scene_to_packed(main_menu)


# Time scale is set to 0 here to ensure the game doesn't keep playing in the background when paused
func pauseMenu():
	if paused:
		pause_menu.hide()
		AudioManager.unpause.play()
		Engine.time_scale = 1
	else:
		pause_menu.show()
		AudioManager.pause.play()
		Engine.time_scale = 0
		
	paused = !paused

# modules_spawned is checked against frequency to ensure gates spawns precisely every 24 modules
func spawnModule(n):
	rng.randomize()
	var instance
	if modules_spawned < freq:
		instance = modules[0].instantiate()
		modules_spawned += 1
	else:
		instance = modules[1].instantiate()
		modules_spawned = 0
	instance.position.x = n
	add_child(instance)
	
func checkGameOver():
	if lives <= 0:
		GlobalScore.score = score
		get_tree().change_scene_to_packed(game_over)

# ---------Binary and Decimal number generation and conversion -------

# A function to generate binary and decimal numbers
# Essential to generating questions and answers
func generate_binary_number() -> String:
	var binary_str = ""
	var num_bits = 4 #Always generate 4 bit binary numbers
	for i in num_bits:
		binary_str += str(rng.randi_range(0, 1))
	return binary_str

func generate_decimal_number() -> int:
	var max_value = 15  # Maximum value for decimal numbers (0-15 for 4-bits)
	return rng.randi_range(0, max_value)
	
# Unique number functions, used to ensure that every possible answer is unique
func unique_binary_numbers() -> Array:
	var binary_numbers = []
	while binary_numbers.size() < 3:
		var new_number = generate_binary_number()
		if new_number not in binary_numbers:  # Check if already exists
			binary_numbers.append(new_number)
	return binary_numbers
	
func unique_decimal_numbers() -> Array:
	var decimal_numbers = []
	while decimal_numbers.size() < 3:
		var new_number = generate_decimal_number()
		if new_number not in decimal_numbers:  
			decimal_numbers.append(new_number)
	return decimal_numbers

# Conversion functions, used to check that answers are correct or incorrect in module.gd
func binary_to_decimal(binary_str: String) -> int:
	var decimal = 0
	var power = 0
	for character in binary_str.reverse():
		decimal += int(character) * 2**power
		power += 1
	return decimal

func decimal_to_binary(decimal_num: int) -> String:
	if decimal_num == 0:
		return "0000"
	var binary = ""
	while decimal_num > 0:
		var remainder = decimal_num % 2
		binary = str(remainder) + binary
		decimal_num = decimal_num / 2
	return binary.pad_zeros(4)
