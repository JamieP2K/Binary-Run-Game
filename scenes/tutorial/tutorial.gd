extends Control


# This is to track the movement between pages
# It not an elegant solution but is functional
var current_page = 1

@onready var main_menu = load("res://scenes/main menu/main_menu.tscn") as PackedScene

#Ensures all of the nodes that represent the pages, buttons and
# text input fields are accessible

@onready var back = $"Back"
@onready var next = $"Next"
@onready var pages = $"Pages"
@onready var page1 = $"Pages/Page1"
@onready var page2 = $"Pages/Page2"
@onready var page3 = $"Pages/Page3"
@onready var page4 = $"Pages/Page4"
@onready var page5 = $"Pages/Page5"
@onready var page6 = $"Pages/Page6"
@onready var page7 = $"Pages/Page7"
@onready var Answer1 = $"Pages/Page5/1100Answer"
@onready var Answer2 = $"Pages/Page5/0011Answer"
@onready var Answer3 = $"Pages/Page5/1010Answer"
@onready var Answer4 = $"Pages/Page5/1101Answer"


func _ready() -> void:
	pass

# Allows the user to escape the tutorial and return to the menu at any time
# This method is chosen as it is intuitive and removes the need to take up
# more screen space with another button for exiting to the menu

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		get_tree().change_scene_to_packed(main_menu)

# Ensures the current_page variable is always updated when switching between pages

func _on_back_button_down() -> void:
	AudioManager.click_button.play()
	current_page -= 1
	switch_page()

func _on_next_button_down() -> void:
	AudioManager.click_button.play()
	current_page += 1
	switch_page()

# Checks the current page against a switch case. Ensures that the appropriate pages
# and button is showing at all times.
# Alternate methods exist however this was chosen as it was fast to develop and test

func switch_page():
		match current_page:
			1:
				page1.show()
				page2.hide()
				back.hide()
			2:
				back.show()
				page1.hide()
				page2.show()
				page3.hide()
			3:
				page2.hide()
				page3.show()
				page4.hide()
			4:
				page3.hide()
				page4.show()
				page5.hide()
			5:
				page4.hide()
				page5.show()
				page6.hide()
			6:
				next.show()
				page5.hide()
				page6.show()
				page7.hide()
			7:
				next.hide()
				page6.hide()
				page7.show()

# Ensures that the answers are not editable after being entered.
# Prevents cheating and removes the need to re-check new answers

# Green is chosen for to signify correct answers
# Red is chosen to signify incorrect answers
# These choices stand out and are obvious at a glance what they indicate
func _on_check_answers_button_down() -> void:
	Answer1.editable = false
	Answer2.editable = false
	Answer3.editable = false
	Answer4.editable = false
	
	#If correct, just turn green. If not, turn red and unhide the label
	
	check_answer(Answer1, 12)
	check_answer(Answer2, 3)
	check_answer(Answer3, 10)
	check_answer(Answer4, 13)

func check_answer(answer: Node, correct_answer: int):
	if answer.text == str(correct_answer):
		answer.add_theme_color_override("font_uneditable_color", Color.GREEN)
	else:
		answer.add_theme_color_override("font_uneditable_color", Color.RED)
		answer.propagate_call("set_visible", [true])
