extends Node3D

# Since this scene will be called as a child, the level node will be in the
# root of this node's position

# This allows the level.speed variable to be used here

@onready var level = $"../"

# position.x is used to determine the current location of the module
# It is updated as often as possible with the current speed

# If the position is -15 (offscreen), delete the current module
# This is to save resources and allow more modules to be created as otherwise
# this off-offscreen module will be counted against the total spawned

func _process(delta):
	position.x -= level.speed * delta
	if position.x < -15:
		level.spawnModule(position.x+(level.amnt*level.offset))
		queue_free()
