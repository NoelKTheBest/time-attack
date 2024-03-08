extends Node2D

# Create variables
var time_start
var time_now
var times
var values
var timer_started
var window_bottom
var text_area
var player
var timer

# Called when the node enters the scene tree for the first time.
func _ready():
	time_start = Time.get_ticks_msec()
	timer_started = false
	
	text_area = $'../Label'
	player = $'../Player'
	
	# Create a list
	times = []
	
	# Create a dictionary
	values = {}


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

# detecting player controls using _physics_process()
func _physics_process(delta):
	var velocity = Vector2.ZERO # The player's movement vector.
	
	# Start timer. Timer must has one_shot set to true
	if Input.is_action_just_pressed('start timer'):
		$'../Timer'.start()
		timer_started = true
	
	time_now = Time.get_ticks_msec() - time_start
	# sliding windows aren't used in this demo
	window_bottom = time_now - 5000
	
	var format_string = "
		Time at start of application: -\n 
		Current Time: -\n 
		Game time: -\n
		Back time: -\n
		Total back time: -\n
		Current Window\n
		>   end: %s       start: %s\n
		Current Position: %s, %s\n
		Timer is stopped: %s\n
	"
	
	var actual_string = format_string % [window_bottom, time_now, 
	player.position.x, player.position.y, $'../Timer'.is_stopped()]
	
	text_area.text = actual_string
	
	# Record times while timer is counting down
	if timer_started:
		times.append(time_now)
		values[time_now] = player.position


# Once timer has stopped, playback begins
func _on_timer_timeout():
	timer_started = false
	# This function call sets the global variables of the player to times and values.
		# This is a no-no unless done right since Godot (at least by default) does not
		# copy data upon variable assignment. Rather when setting a variable to another 
		# variable a reference to the memory address is shared. In other words the 
		# variables are now linked due to this call. This caused problems later on.
	player.control_player(times, values)


# Clear the records. Signal sent by Player script
func _on_player__on_playback_finished():
	times.clear()
	values.clear()
