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
var next_back_time
var next_time_value
var next_back_time_v
var next_back_time_a
var next_time_value_v
var next_time_value_a

# maximum amount of time you can go back
@export var max_back_time = 0

# times at when things change in the scene
var times = []
var vector_times = []
var animation_times = []
var oldest_time

# time tables
var vector_time_table = {}
var animation_time_table = {}
var sprite_flip_time_table = {}

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

# Called when the node enters the scene tree for the first time.
func _ready():
	# display was set to 320 x 240
	start_time = Time.get_ticks_msec()
	game_time = 0
	rewinded_time = 0
	back_time = 0
	text_area = get_node("Label")
	$Player.override_velocity = null
	$Player.override_animation = null


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	time = Time.get_ticks_msec()
	_shift_window()
	
	if Input.is_action_just_pressed("rewind_time"): _on_button_button_down()
	if Input.is_action_just_released("rewind_time"): _on_button_button_up()
	
	if !is_rewinding:
		game_time = time - start_time - rewinded_time
	else:
		_on_button_held_down()
	
	#if (Input.is_action_just_pressed("movement")):
		# times.append(game_time)
		#cs_script.AddEntry(game_time)
		#if (times.size() == 0):
		#	oldest_time = game_time;
	
	#print("Queue: " + cs_script.PrintQueue())
	#print(cs_script.PrintTimeTables())
	#cs_script.PrintTimeTables()
	
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
	
	if !is_rewinding:
		for time_value in vector_times:
			if (time_value < window_bottom):
				vector_times.pop_front()
				vector_time_table.erase(time_value)
				#animation_time_table.erase(time_value)
		
		for time_value in animation_times:
			if (time_value < window_bottom):
				animation_times.pop_front()
				animation_time_table.erase(time_value)
				#vector_time_table.erase(time_value)
	
	#print(times)
	#print(vector_time_table)
	#print(animation_time_table)


func _on_button_button_down():
	if (!vector_times.is_empty() || !animation_times.is_empty()):
		is_rewinding = true
		initial_back_time = time
		next_time_value_v = vector_times.pop_back()
		next_time_value_a = animation_times.pop_back()
		#next_time_value = times.pop_back()
		
		# in case we run out of time values
		if (next_time_value_v == null || next_time_value_a == null):
			is_rewinding = false
			print(is_rewinding)
			rewinded_time += back_time
			$Player.override_velocity = null
			$Player.override_animation = null
		
		next_back_time_v = window_head - next_time_value_v
		next_back_time_a = window_head - next_time_value_a
		#next_back_time = window_head - next_time_value


func _on_button_button_up():
	# if we already stopped going back in time, don't do anything and return from this function
	if !is_rewinding:
		return
	
	is_rewinding = false
	rewinded_time += back_time
	$Player.override_velocity = null
	$Player.override_animation = null


func _on_button_held_down():
	
	# the signal for BaseButton pressed() is either the same as the signal for button_down() or
	# button_up(). This means that the code is getting called at the same time. No time has
	# elapsed
	
	back_time = time - initial_back_time
	
	if back_time > (max_back_time * 1000) || back_time > game_time:
		is_rewinding = false
		rewinded_time += back_time
		$Player.override_velocity = null
		$Player.override_animation = null
	
	if back_time >= next_back_time_v:
		# these dictionaries will not contain the same time values
		$Player.override_velocity = vector_time_table[next_time_value_v]
		#$Player.override_animation = animation_time_table[next_time_value]
		
		next_time_value_v = vector_times.pop_back()
		
		# in case we run out of time values
		if (next_time_value_v == null):
			is_rewinding = false
			rewinded_time += back_time
			$Player.override_velocity = null
			$Player.override_animation = null
			return
		
		#print(window_head)
		next_back_time_v = window_head - next_time_value_v
	
	if back_time >= next_back_time_a:
		# these dictionaries will not contain the same time values
		#$Player.override_velocity = vector_time_table[next_time_value]
		$Player.override_animation = animation_time_table[next_time_value_a]
		
		next_time_value_a = animation_times.pop_back()
		
		# in case we run out of time values
		if (next_time_value_a == null):
			is_rewinding = false
			rewinded_time += back_time
			$Player.override_velocity = null
			$Player.override_animation = null
			return
		
		#print(window_head)
		next_back_time_a = window_head - next_time_value_a


func _shift_window():
	window_head = game_time
	window_bottom = game_time - (max_back_time * 1000)


# For the following two signals, game_time has the same value
func _on_player__on_velocity_changed(velocity):
	# print("velocity: " + str(game_time))
	vector_time_table[game_time] = velocity
	vector_times.append(game_time)
	print("vectors: " + str(vector_time_table))
	#times.append(game_time)


func _on_player__on_animation_changed(animation):
	# print("animation: " + str(game_time))
	animation_time_table[game_time] = animation
	animation_times.append(game_time)
	print("animation: " + str(animation_time_table))
