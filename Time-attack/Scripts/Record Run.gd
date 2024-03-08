extends Node2D


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
	
	# If we start the timer again, the player can no longer move 
	if Input.is_action_just_pressed('start timer'):
		$'../Timer'.start()
		timer_started = true
	
	time_now = Time.get_ticks_msec() - time_start
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
	
	if timer_started:
		times.append(time_now)
		values[time_now] = player.position


func _on_timer_timeout():
	timer_started = false
	player.control_player(times, values)


func _on_player__on_playback_finished():
	times.clear()
	values.clear()
