extends CharacterBody2D
signal hit

@export var speed = 400 # How fast the player will move (pixels/sec).
@export var jump_force = 1000 # How high the player will jumo
var screen_size # Size of the game window.

const g = 7/4
const v_term = 15/4
var fallspd = 0
var jump_spd

func _ready():
	screen_size = get_viewport_rect().size


func _process(delta):
	var velocity = Vector2.ZERO # The player's movement vector.
	
	if Input.is_action_pressed("move_right"):
		$AnimatedSprite2D.flip_h = false
		$CollisionShape2D.position.x = -7
		velocity.x = 1
	if Input.is_action_pressed("move_left"):
		$AnimatedSprite2D.flip_h = true
		$CollisionShape2D.position.x = 7
		velocity.x = -1
		
	velocity.x *= speed
	
	if (!is_on_floor()):
		fallspd = fallspd + g
		if (fallspd >= v_term):
			fallspd = v_term
		velocity.y += fallspd * speed
	else:
		if (Input.is_action_just_pressed("jump")):
			print("before jump: " + str(velocity.y))
			velocity.y = -jump_force
			print("after jump: " + str(velocity.y))
		elif (jump_spd < 0):
			pass
		else:
			fallspd = 0
			velocity.y = 0
	
	if (is_on_floor() && Input.is_action_just_pressed("jump")):
		pass
	
	if velocity.x != 0:
		$AnimatedSprite2D.play("run")
	else:
		$AnimatedSprite2D.play("idle")
	
	if velocity.y > 0:
		$AnimatedSprite2D.play("fall")
	elif velocity.y < 0:
		$AnimatedSprite2D.play("jump")
	
	print(velocity.y)
	jump_spd = velocity.y
	position += velocity * delta
	#print("velocity * delta: " + str(velocity.y * delta))
	position.x = clamp(position.x, 0, screen_size.x)
	#position.y = clamp(position.y, 0, screen_size.y)
	#print(position)


#func is_on_floor():
#	if (has_overlapping_areas()):
#		return true
