extends Area3D


# These positions ensure that the player's character travels through the center of each gate
var positions = [-1.37, 0, 1.37]
var curPos = 1

# Allows the player character to move left or right
# CurPos is used to prevent the character from moving outside of the three lanes as well as 
# determining which lane to move to
func _process(_delta):
	if Input.is_action_just_pressed("right"):
		if curPos < 2:
			curPos += 1
			position.z = positions[curPos]
			AudioManager.switch_lane.play()
	elif Input.is_action_just_pressed("left"):
		if curPos > 0:
			curPos -= 1
			position.z = positions[curPos]
			AudioManager.switch_lane.play()
