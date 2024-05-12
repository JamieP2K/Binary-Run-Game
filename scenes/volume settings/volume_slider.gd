extends HSlider

# Export allows the audiobus_name to be a property that can be set in the editor.
# This is important as the bus name must be set within the editor for this code to work
@export var audiobus_name: String
var audiobus: int

func _ready() -> void:
	
	# Converts the bus name to an integer
	# A lot of methods do not work on bust names and require their index
	# The getter and setter methods below require an index
	
	audiobus = AudioServer.get_bus_index(audiobus_name)
	value_changed.connect(on_volume_change) # This is to allow the slider to control the value
	
	# Converts the db value to a linear format rather than the curve db's usually are
	# This ensures the slider within the options menu works as a user expects it to
	
	value = db_to_linear(AudioServer.get_bus_volume_db(audiobus))

func on_volume_change(volume: float) -> void:
	AudioServer.set_bus_volume_db(audiobus,linear_to_db(volume))	
