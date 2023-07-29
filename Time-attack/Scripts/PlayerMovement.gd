extends CharacterBody2D
signal _on_velocity_changed(veloctiy)
signal _on_animation_changed(animation)


const SPEED = 500.0
const JUMP_VELOCITY = -900.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var attacked = false

# current values of the player
var first_iteration
var current_animation = ""
var current_velocity
var previous_velocity

# override values for the player that are passed to this script from Timer.gd
var override_velocity
var override_animation

func _ready():
	first_iteration = true


func _process(delta):
	if (override_velocity == null && override_animation == null):
		#print("ready to move")
		previous_velocity = current_velocity
		
		# Add the gravity.
		if not is_on_floor():
			velocity.y += gravity * delta
			if (velocity.y > 0 ):
				$AnimatedSprite2D.play("fall")
			elif (velocity.y < 0):
				$AnimatedSprite2D.play("jump")

		# Handle Jump.
		if Input.is_action_just_pressed("ui_accept") and is_on_floor():
			velocity.y = JUMP_VELOCITY
		
		# Handle Attack
		if Input.is_action_just_pressed("attack") && is_on_floor():
			$AnimatedSprite2D.play("attack")
			attacked = true
		elif Input.is_action_just_pressed("heavy_attack") && is_on_floor():
			$AnimatedSprite2D.play("heavy attack")
			attacked = true

		# Get the input direction and handle the movement/deceleration.
		# As good practice, you should replace UI actions with custom gameplay actions.
		var direction = Input.get_axis("ui_left", "ui_right")
		if direction && !attacked:
			velocity.x = direction * SPEED
			if (direction > 0 && !attacked):
				$AnimatedSprite2D.flip_h = false
				$CollisionShape2D.position.x = -7
			elif (direction < 0 && !attacked):
				$AnimatedSprite2D.flip_h = true
				$CollisionShape2D.position.x = 7
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
		
		if velocity.x != 0 && is_on_floor() && !attacked:
			$AnimatedSprite2D.play("run")
		elif velocity.x == 0 && is_on_floor() && !attacked:
			$AnimatedSprite2D.play("idle")

		if attacked: velocity = Vector2.ZERO
		
		#if first_iteration:
		#	current_animation = $AnimatedSprite2D.animation
		#	_on_animation_changed.emit(current_animation)
		#	first_iteration = false
	
		current_velocity = velocity
		
		if (current_velocity != previous_velocity):
			_on_velocity_changed.emit(current_velocity)
		
		move_and_slide()
	else:
		#print("going back")
		if override_velocity != null: velocity = override_velocity * -1
		move_and_slide()
		
		$AnimatedSprite2D.play_backwards(override_animation)
		
		#if $AnimatedSprite2D.animation != override_animation:
		#	$AnimatedSprite2D.play_backwards(override_animation)


func _on_animated_sprite_2d_animation_finished():
	if !attacked:
		return
	else:
		attacked = false
	


func _on_animated_sprite_2d_animation_changed():
	current_animation = $AnimatedSprite2D.animation
	_on_animation_changed.emit(current_animation)
