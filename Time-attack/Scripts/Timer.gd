extends Node2D

# time at the start of the application
var start_time

# current application time
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
var oldest_time

# normal time progression = 1; reversing time = -1; slowed time progression = 0.75, 0.5, or 0.25
var time_scale

# equal to the current time - max back time to get the window of time we are working with
# we'll need to subtract window from current time to get a time within the window range to log changes
# ex: 20000(time) - 5000(max_back_time) = 15000(window)
# 	  if 23200

# we want to be able to take the current time in the window and log that
# we can make it so that window doesn't follow current time but rather defines a section of time where
#	changes can be logged as happening at a certain point in the time window
#
var window_bottom
var window_head

# boolean value that lets us know whether or not we are going back in time
var is_rewinding

var text_area
var cs_script

# Called when the node enters the scene tree for the first time.
func _ready():
	# display was set to 320 x 240
	start_time = Time.get_ticks_msec()
	game_time = 0
	rewinded_time = 0
	back_time = 0
	text_area = get_node("Label")
	cs_script = get_node("Time Tables")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time = Time.get_ticks_msec()
	_shift_window()
	
	if !is_rewinding:
		game_time = time - start_time - rewinded_time
	else:
		_on_button_held_down()
	
	if (Input.is_action_just_pressed("movement")):
		# times.append(game_time)
		cs_script.AddEntry(game_time)
		#if (times.size() == 0):
		#	oldest_time = game_time;
	
	print(cs_script.PrintQueue())
	
	var format_string = "
		Time at start of application: %s\n 
		Current Time: %s\n 
		Game time: %s\n
		Back time: %s\n
		Total back time: %s\n
		Current Window\n
		>   end: %s       start: %s\n
	"
	var actual_string = format_string % [start_time, time, game_time, 
	back_time, rewinded_time, window_bottom, window_head]
	
	text_area.text = actual_string
	
	#if (oldest_time < window_bottom):
	#	oldest_time = times[1]
	#	times.remove_at(0)
	#	cs_script.RemoveFromQueue()
	
	cs_script.RemoveFromQueue(window_bottom)


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


func _shift_window():
	window_head = game_time
	window_bottom = game_time - (max_back_time * 1000)


