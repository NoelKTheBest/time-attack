extends Node2D

# time at the start of the application
var start_time

# current time
var time

# the time value of the game
var game_time

# total rewinded time
var rewinded_time

var initial_back_time
var back_time

# maximum amount of time you can go back
@export var max_back_time = 0

# times at when things change in the scene
var times = []

# normal time progression = 1; reversing time = -1; slowed time progression = 0.75, 0.5, or 0.25
var time_scale

var text_area
var is_rewinding


# Called when the node enters the scene tree for the first time.
func _ready():
	# display was set to 320 x 240
	start_time = Time.get_ticks_msec()
	rewinded_time = 0
	back_time = 0
	text_area = get_node("Label")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time = Time.get_ticks_msec()
	
	if !is_rewinding:
		game_time = time - start_time - rewinded_time
	else:
		_on_button_held_down()
	
	var format_string = "
		Time at start of application: %s \n 
		Current Time: %s \n 
		Game time: %s \n
		Back time: %s \n
		Total back time: %s \n
	"
	var actual_string = format_string % [start_time, time, game_time, 
	back_time, rewinded_time]
	
	text_area.text = actual_string

func _on_button_button_down():
	is_rewinding = true
	initial_back_time = time


func _on_button_button_up():
	if !is_rewinding:
		return
	
	is_rewinding = false
	rewinded_time += back_time


func _on_button_held_down():
	
	# the signal for BaseButton pressed() is either the same as the signal for button_down() or
	# button_up(). This means that the code is getting called at the same time. No time has
	# elapsed
	
	back_time = time - initial_back_time
	
	if back_time > (max_back_time * 1000) || back_time > game_time:
		is_rewinding = false
		rewinded_time += back_time

