extends CharacterBody2D

signal shoot

const SPEED = 300.0
const ACCEL = 2.0

var input: Vector2

func get_input():
	input.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		var dir = get_global_mouse_position() - position
		shoot.emit(position, dir)
	
	return input.normalized()
	
func _physics_process(delta):
	var playerInput = get_input()
	velocity = lerp(velocity, playerInput * SPEED, delta * ACCEL)
	move_and_slide()
	
	# player direction except we need sprites for each thing so this also doesnt work :skull:
	#var mouse = get_local_mouse_position()
	#var angle = snappedf(mouse.angle(), PI/4) / (PI / 4)
	#angle = wrapi(int(angle), 0, 8) 
	#$AnimatedSprite2D.animation = "walk" + str(angle)
	
	# should limit it to only animate when walking but its not working :/
	if velocity.length() != 0:
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()
		$AnimatedSprite2D.frame = 3
		

	
