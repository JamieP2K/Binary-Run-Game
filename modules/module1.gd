extends Node3D

@onready var level = $"../"
@onready var score = $"../../HUD/UIElements/Score"
@onready var question = $"../../HUD/UIElements/Question"
@onready var background = $"../../WorldEnvironment"

@onready var gate1text = $"Gates/Gate1/Label3D"
@onready var gate2text = $"Gates/Gate2/Label3D"
@onready var gate3text = $"Gates/Gate3/Label3D"

var binary_num1
var binary_num2
var binary_num3
var decimal_num1
var decimal_num2
var decimal_num3
var correct_answer

var rng = RandomNumberGenerator.new()

# Flag to track if the gate has been triggered
# Used to determine if the gate module should be turned into a gateless module
var has_gate_triggered = false  

# Determines which game mode was selected on the mode select screen
# This allows the game to run the required functions in order to generate the appropriate questions

func _ready():
	randomize()
	if GlobalScore.decimaltobinary == true:
		generate_questions_binary()
	else:
		generate_questions_decimal()

func _process(delta):
	position.x -= level.speed * delta
	if position.x < -15:
		level.spawnModule(position.x+(level.amnt*level.offset))
		queue_free()
	if has_gate_triggered:
		replace_with_module_0()

# Functions to check whether the answer the user picks is the correct one
# checkGameOver() is called here to ensure that the game ends as soon as the player loses their last life

func _on_gate_1_area_entered(_area):
	if binary_num1 == correct_answer:
		correctAnswer()
	elif decimal_num1 == correct_answer:
		correctAnswer()
	else:
		incorrectAnswer()
	level.checkGameOver()
	has_gate_triggered = true


func _on_gate_2_area_entered(_area):
	if binary_num2 == correct_answer:
		correctAnswer()
	elif decimal_num2 == correct_answer:
		correctAnswer()
	else:
		incorrectAnswer()
	level.checkGameOver()
	has_gate_triggered = true


func _on_gate_3_area_entered(_area):
	if binary_num3 == correct_answer:
		correctAnswer()
	elif decimal_num3 == correct_answer:
		correctAnswer()
	else:
		incorrectAnswer()
	level.checkGameOver()
	has_gate_triggered = true

# Replaces the current module with a gateless one
# Ensures that the character's hitbox can not trigger multiple gates once an answer is chosen

func replace_with_module_0():
	var new_module = level.modules[0].instantiate()
	new_module.position = position  # Copy the position of the old module
	level.add_child(new_module)
	queue_free()  # Remove the old module


# ------Question and answer generation-------

func generate_questions_binary():
	var binary_numbers = level.unique_binary_numbers()
	binary_num1 = binary_numbers[0]
	binary_num2 = binary_numbers[1]
	binary_num3 = binary_numbers[2 ]
	
	#Set the text above each gate to their binary number
	gate1text.set_text(str(binary_num1))
	gate2text.set_text(str(binary_num2))
	gate3text.set_text(str(binary_num3))

	# Choose a random number to convert to decimal
	var random_index = rng.randi_range(0, 2)
	var decimal_number

	if random_index == 0:
		decimal_number = level.binary_to_decimal(binary_num1)
		correct_answer = binary_num1
	elif random_index == 1:
		decimal_number = level.binary_to_decimal(binary_num2)
		correct_answer = binary_num2
	else:
		decimal_number = level.binary_to_decimal(binary_num3)
		correct_answer = binary_num3
		
	question.set_text(str(decimal_number)) # Display the decimal number

func generate_questions_decimal():
	var decimal_numbers = level.unique_decimal_numbers()
	decimal_num1 = decimal_numbers[0]
	decimal_num2 = decimal_numbers[1]
	decimal_num3 = decimal_numbers[2]
	
	#Set the text above each gate to their decimal number
	gate1text.set_text(str(decimal_num1))
	gate2text.set_text(str(decimal_num2))
	gate3text.set_text(str(decimal_num3))

	# Choose a random number to convert to binary
	var random_index = rng.randi_range(0, 2)
	var binary_number

	if random_index == 0:
		binary_number = level.decimal_to_binary(decimal_num1)
		correct_answer = decimal_num1
	elif random_index == 1:
		binary_number = level.decimal_to_binary(decimal_num2)
		correct_answer = decimal_num2
	else:
		binary_number = level.decimal_to_binary(decimal_num3)
		correct_answer = decimal_num3
		
	question.set_text(str(binary_number)) # Display the binary number

func correctAnswer():
	AudioManager.correct.play()
	level.score += 1
	score.set_text(str("Score: ", level.score))
	
	# Increasing speed to 3 decimal places dependent on current speed
	# The speed increase is lowered significantly after increasing past 15, and 30
	# This is to ensure the game's difficulty does not ramp up too excessively high
	
	if level.speed > 30:
		level.speed = snapped(level.speed * 1.005, 0.001) #0.5% increase to speed
	elif level.speed > 15:
		level.speed = snapped(level.speed * 1.01, 0.001) #1% increase to speed
	else:
		level.speed = snapped(level.speed * 1.1, 0.001) #10% increase to speed
	if level.score % 2 == 0:
		background.environment.background_color = Color(randf(), randf(), randf(), 1)
	
func incorrectAnswer():
	AudioManager.incorrect.play()
	level.lives -= 1
	level.lifetext.set_text(str(level.lives, "♥︎"))
