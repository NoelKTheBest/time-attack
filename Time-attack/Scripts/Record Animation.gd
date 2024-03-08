extends Node2D

var time_start
var time_now
var window_bottom
var timer_started

var times = []
var values = {}

var current_animation = ''

var animation_label
var player
var run_recorder

# Called when the node enters the scene tree for the first time.
func _ready():
	animation_label = $'../Label2'
	run_recorder = $'../Record Run'
	player = $'../Player'
	
	time_start = Time.get_ticks_msec()
	timer_started = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if Input.is_action_just_pressed('start timer'):
		timer_started = true
	
	time_now = Time.get_ticks_msec() - time_start
	window_bottom = time_now - 5000
	
	var format_string = "
		Current Animation: %s\n
	"
	
	var actual_string = format_string % [current_animation]
	
	animation_label.text = actual_string


func _on_player__on_animation_changed(animation):
#	print(time_now)
	if (run_recorder.times.has(time_now)):
		times.append(time_now)
		values[time_now] = animation
	current_animation = animation


func _on_timer_timeout():
	timer_started = false
	player.animation_values = values
	player.animation_times = times


func _on_player__on_playback_finished():
	times.clear()
	values.clear()
