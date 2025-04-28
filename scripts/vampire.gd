extends CharacterBody2D
class_name Vampire

signal player_fired_bullet(bullet, position, direction)
signal stealth_changed(value: float)

@export var Bullet: PackedScene
@export var Bats: PackedScene

@export var speed = 150

@onready var attack_spawn_point = $AnimatedSprite2D/AttackSpawnPoint
@onready var attack_direction = $AnimatedSprite2D/AttackDirection
@onready var attack_cooldown = $AttackCooldown

@onready var bats_cooldown = $BatsCooldown

@export var dash_speed: float = 400
@export var dash_duration: float = 0.2
@export var dash_cooldown_time: float = 1.0
var is_dashing = false
var dash_direction = Vector2.ZERO
@onready var dash_timer = $DashTimer
@onready var dash_cooldown = $DashCooldown

var is_stealth = false
var is_stealth_button_held = false
var can_stealth = true
@onready var stealth_cooldown = $StealthCooldown
@export var max_stealth_meter: float = 100.0  # Maximum stealth meter
var current_stealth_meter: float = 100.0      # Current stealth meter value
@export var stealth_drain_rate: float = 15.0    # Rate at which the meter drains per second while in stealth
@export var stealth_regen_rate: float = 5.0     # Rate at which the meter regenerates per second when not in stealth


@onready var health_stat = $Health
@onready var hurt_flash_timer = $HurtFlashTimer
var is_hurt = false

const START_SPEED : int = 150
var health: int = 100
var bats_active = false
var dash_active = false
var shadow_active = false
var is_dead = false
var last_movement_direction = Vector2.RIGHT
var is_attacking = false



func _ready():
	pass

func _physics_process(_delta: float) -> void:
	if is_dead:
		velocity = Vector2.ZERO
		move_and_slide()
		return
	
	attack_spawn_point.position = get_aim_direction() * 10

	var movement_direction := Vector2.ZERO
	
	if Input.is_action_pressed("ui_up"):
		movement_direction.y = -1
	if Input.is_action_pressed("ui_down"):
		movement_direction.y = 1
	if Input.is_action_pressed("ui_left"):
		movement_direction.x = -1
		$AnimatedSprite2D.scale.x = -1
	if Input.is_action_pressed("ui_right"):
		movement_direction.x = 1
		$AnimatedSprite2D.scale.x = 1
	
	movement_direction = movement_direction.normalized()
	if movement_direction != Vector2.ZERO:
		last_movement_direction = movement_direction
	
	if movement_direction != Vector2.ZERO and not is_attacking:
		$AnimatedSprite2D.play("move")
	elif not is_attacking:
		$AnimatedSprite2D.play("idle")	
	
	if is_dashing:
		velocity = dash_direction * dash_speed
	else:
		velocity = movement_direction * speed
	move_and_slide()
	
	if Input.is_action_pressed("shoot"):  # Check if the shoot button is held down
		shoot()
		
	if not is_stealth:
		if current_stealth_meter < max_stealth_meter:
			current_stealth_meter += stealth_regen_rate * _delta
			current_stealth_meter = min(current_stealth_meter, max_stealth_meter)
			emit_signal("stealth_changed", current_stealth_meter)

	else:
		current_stealth_meter -= stealth_drain_rate * _delta
		emit_signal("stealth_changed", current_stealth_meter)
		if current_stealth_meter <= 0:
			current_stealth_meter = 0
			stop_stealth()

	if current_stealth_meter < 10 and can_stealth:
		can_stealth = false
		stealth_cooldown.start()
		print("cant stealth for a bit")
	#print(current_stealth_meter)
	
	if is_stealth_button_held and can_stealth and not is_stealth and current_stealth_meter > 10:
		start_stealth()
	elif not is_stealth_button_held and is_stealth:
		stop_stealth()
	

	
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("dash") and not is_dashing and dash_cooldown.is_stopped():
		start_dash()
	if event.is_action_pressed("stealth") and stealth_cooldown.is_stopped():
		is_stealth_button_held = true  # Stealth button is being held
	elif event.is_action_released("stealth"):
		is_stealth_button_held = false  # Stealth button was released

func get_aim_direction() -> Vector2:
	var aim_direction = Vector2.ZERO
	
	if Input.is_action_pressed("ui_up"):
		aim_direction.y = -1
	if Input.is_action_pressed("ui_down"):
		aim_direction.y = 1
	if Input.is_action_pressed("ui_left"):
		aim_direction.x = -1
	if Input.is_action_pressed("ui_right"):
		aim_direction.x = 1
	
	if aim_direction != Vector2.ZERO:
		return aim_direction.normalized()
	else:
		return last_movement_direction  # Use last direction if no input


	#if event.is_action_pressed("shoot"): #old semi auto shooting
	#	shoot()

func start_dash():
	if dash_active:
		is_dashing = true
		dash_direction = velocity.normalized()
		dash_timer.start()
		dash_cooldown.start()

func _on_dash_timer_timeout() -> void:
	is_dashing = false

func _on_dash_cooldown_timeout() -> void:
	# Optional: reset any visual effects
	pass
	
func start_stealth():
	if current_stealth_meter > 0 and not is_stealth:
		print("start repeated")
		is_stealth = true

		var sprite = $AnimatedSprite2D
		sprite.modulate.a = 0.2  # Set transparency (alpha value)
		$CollisionShape2D.disabled = true  # Disable collision during stealth
		print("Stealth activated")
		
func stop_stealth():
	if not is_stealth:
		return
	is_stealth = false

	var sprite = $AnimatedSprite2D
	sprite.modulate.a = 1.0  # Fully visible again
	$CollisionShape2D.disabled = false  # Re-enable collision
	print("Stealth deactivated")
	# Optional: you can start cooldown or additional effects after stealth ends

func _on_stealth_cooldown_timeout() -> void:
	print("can enter shadow")
	can_stealth = true
	pass # Replace with function body.

		
func activate_bats():
	bats_active = true
	print(bats_active )
	
func activate_dash():
	dash_active = true
	
func activate_shadow():
	shadow_active = true

func _on_bats_timer_timeout() -> void:
	#bats_active = false
	#right now this doesnt do anything
	pass
func shoot():
	if is_stealth:
		return
	if attack_cooldown.is_stopped():
		is_attacking = true
		$AnimatedSprite2D.animation = "attack"
		$AnimatedSprite2D.speed_scale = 2.5
		$AnimatedSprite2D.play()
		
		var bullet_instance = Bullet.instantiate()
		bullet_instance.ignore_body = self
		bullet_instance.animation_name = "fireball"
		
		var direction = get_aim_direction()
		if direction == Vector2.ZERO:
			direction = Vector2($AnimatedSprite2D.scale.x, 0)  # Default to facing
		
		emit_signal("player_fired_bullet", bullet_instance, attack_spawn_point.global_position + Vector2(0, 10), direction)
		attack_cooldown.start()
		
	if bats_cooldown.is_stopped() and bats_active:
		var bats_instance = Bats.instantiate()
		var direction = get_aim_direction()
		if direction == Vector2.ZERO:
			direction = Vector2($AnimatedSprite2D.scale.x, 0)
			
		var angle_variation = deg_to_rad(randf_range(-20, 20))
		var varied_direction = direction.rotated(angle_variation)

		bats_instance.ignore_body = self
		bats_instance.get_node("AnimatedSprite2D").play("bat")
		bats_instance.get_node("AnimatedSprite2D").scale = Vector2(1, 1) 
		emit_signal("player_fired_bullet", bats_instance, attack_spawn_point.global_position, varied_direction)
		
		bats_cooldown.start()

		

func handle_hit():
	if is_dead:
		return
	health_stat.health -= 20
	is_hurt = true
	$AnimatedSprite2D.modulate = Color(1,0,0) #flash red
	hurt_flash_timer.start()
	print("player hit", health_stat.health)
	if health_stat.health <= 0:
		die()
		
func die():
	if is_dead:
		return
	is_dead = true
	$AnimatedSprite2D.stop()
	$AnimatedSprite2D.play("death")
	print("Vampire down.")
	set_process(false)  # Optional: stop player control
	$CollisionShape2D.disabled = true  # Prevent more collisions
	await $AnimatedSprite2D.animation_finished	# Wait for animation to complete
	#respawn()
	show_game_over()

func show_game_over():
	get_tree().change_scene_to_file("res://scenes/game_over.tscn")

#func respawn():
	#get_tree().reload_current_scene()
	
func heal(amount: int) -> void:
	if (health_stat.health < 100 and health_stat.health > 100-amount):
		health_stat.health = 100
		print("Healed! Current health:", health_stat.health)
	elif(health_stat.health < 100):
		health_stat.health += amount
		print("Healed! Current health:", health_stat.health)

func _on_boost_timer_timeout() -> void:
	speed = START_SPEED


func _on_hurt_flash_timer_timeout() -> void:
	is_hurt = false
	$AnimatedSprite2D.modulate = Color(1,1,1)


func _on_animated_sprite_2d_animation_finished() -> void:
	if $AnimatedSprite2D.animation == "attack":
		is_attacking = false
