extends CharacterBody2D

signal player_fired_bullet(bullet, position, direction)

@export var Bullet: PackedScene
@export var speed = 100

@onready var attack_spawn_point = $AnimatedSprite2D/AttackSpawnPoint
@onready var attack_direction = $AnimatedSprite2D/AttackDirection
@onready var attack_cooldown = $AttackCooldown

func _process(_delta: float) -> void:
	var movement_direction := Vector2.ZERO
	
	if Input.is_action_pressed("ui_up"):
		$AnimatedSprite2D.play("move")
		movement_direction.y = -1
	if Input.is_action_pressed("ui_down"):
		$AnimatedSprite2D.play("move")
		movement_direction.y = 1
	if Input.is_action_pressed("ui_left"):
		$AnimatedSprite2D.play("move")
		movement_direction.x = -1
		$AnimatedSprite2D.scale.x = -1
	if Input.is_action_pressed("ui_right"):
		$AnimatedSprite2D.play("move")
		movement_direction.x = 1
		$AnimatedSprite2D.scale.x = 1
	
	movement_direction = movement_direction.normalized()
	velocity = movement_direction * speed
	move_and_slide()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("shoot"):
		shoot()

func shoot():
	$AnimatedSprite2D.animation = "attack"
	$AnimatedSprite2D.speed_scale = 2.5
	$AnimatedSprite2D.play()
	
	if attack_cooldown.is_stopped():
		var bullet_instance = Bullet.instantiate()
		var direction = (attack_direction.global_position - attack_spawn_point.global_position).normalized()
		emit_signal("player_fired_bullet", bullet_instance, attack_spawn_point.global_position, direction)
		attack_cooldown.start()
	else:
		pass

#Working code from Grace:
#signal shoot
#const SPEED = 300.0
#const ACCEL = 2.0
#var input: Vector2

#func get_input():
	#input.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	#input.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	#
	#if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		#var dir = get_global_mouse_position() - position
		#shoot.emit(position, dir)
	#
	#return input.normalized()
	
#func _physics_process(delta):
#	var playerInput = get_input()
#	velocity = lerp(velocity, playerInput * SPEED, delta * ACCEL)
#	move_and_slide()
	
	# player direction except we need sprites for each thing so this also doesnt work :skull:
	#var mouse = get_local_mouse_position()
	#var angle = snappedf(mouse.angle(), PI/4) / (PI / 4)
	#angle = wrapi(int(angle), 0, 8) 
	#$AnimatedSprite2D.animation = "walk" + str(angle)
	
	# should limit it to only animate when walking but its not working :/
	#if velocity.length() != 0:
		#$AnimatedSprite2D.play()
	#else:
		#$AnimatedSprite2D.stop()
		#$AnimatedSprite2D.frame = 3
		

	
