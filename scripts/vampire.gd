extends CharacterBody2D
class_name Vampire

signal player_fired_bullet(bullet, position, direction)

@export var Bullet: PackedScene
@export var Bats: PackedScene

@export var speed = 100

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

@export var stealth_duration: float = 3.0
var is_stealth = false
@onready var stealth_timer = $StealthTimer

@onready var health_stat = $Health

const START_SPEED : int = 100
#const BOOST_SPEED : int = 200
var health: int = 100
var bats_active = false
var dash_active = false
var shadow_active = false



func _ready():
	var direction = Vector2.RIGHT
	var bats_instance = Bats.instantiate()
	bats_instance.ignore_body = self
	bats_instance.set_direction(direction)
	bats_instance.get_node("AnimatedSprite2D").play("bat")
	bats_instance.get_node("AnimatedSprite2D").scale = Vector2(0.1, 0.1)
	add_child(bats_instance)
	bats_instance.global_position = attack_spawn_point.global_position


func _physics_process(_delta: float) -> void:
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
	if is_dashing:
		velocity = dash_direction * dash_speed
	else:
		velocity = movement_direction * speed
	move_and_slide()
	
	if Input.is_action_pressed("shoot"):  # Check if the shoot button is held down
		shoot()
		
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("dash") and not is_dashing and dash_cooldown.is_stopped():
		start_dash()

	if event.is_action_pressed("stealth") and not is_stealth:
		start_stealth()


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
	if shadow_active:
		is_stealth = true
		stealth_timer.start()
		var sprite = $AnimatedSprite2D
		#sprite.modulate.a = 0.4  # Set transparency (alpha value)
		sprite.play("shadow")    

	# TODO disable collision or damage reception here
	# $CollisionShape2D.disabled = true?
	
func _on_stealth_timer_timeout() -> void:
	is_stealth = false

	var sprite = $AnimatedSprite2D
	#sprite.modulate.a = 1.0    # Fully visible again
	sprite.play("idle")   

	# TODO: re-enable collision
	# $CollisionShape2D.disabled = false

		
func activate_bats():
	print("do we get here x2???")
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
	if attack_cooldown.is_stopped():
		# Main Bullet
		$AnimatedSprite2D.animation = "attack"
		$AnimatedSprite2D.speed_scale = 2.5
		$AnimatedSprite2D.play()
		var bullet_instance = Bullet.instantiate()
		bullet_instance.ignore_body = self
		bullet_instance.animation_name = "bat"
		var direction = (attack_direction.global_position - attack_spawn_point.global_position).normalized()
		emit_signal("player_fired_bullet", bullet_instance, attack_spawn_point.global_position, direction)
		attack_cooldown.start()
		
	if bats_cooldown.is_stopped() and bats_active:
		var bats_instance = Bats.instantiate()
		var direction = (attack_direction.global_position - attack_spawn_point.global_position).normalized()
		var angle_variation = deg_to_rad(randf_range(-20, 20))  # up to ±15 degrees
		var varied_direction = direction.rotated(angle_variation)

		bats_instance.ignore_body = self
		bats_instance.get_node("AnimatedSprite2D").play("bat")
		bats_instance.get_node("AnimatedSprite2D").scale = Vector2(1, 1) 
		emit_signal("player_fired_bullet", bats_instance, attack_spawn_point.global_position, varied_direction)
		
		bats_cooldown.start()
		

func handle_hit():
	health_stat.health -= 20
	print("player hit", health_stat)

#func boost():
#	$BoostTimer.start()
#	speed = BOOST_SPEED

func _on_boost_timer_timeout() -> void:
	speed = START_SPEED
