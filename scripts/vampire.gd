extends CharacterBody2D

signal player_fired_bullet(bullet, position, direction)

@export var Bullet: PackedScene
## bat powerup, scene not yet made
#@export var Bats: PackedScene

@export var speed = 100

@onready var attack_spawn_point = $AnimatedSprite2D/AttackSpawnPoint
@onready var attack_direction = $AnimatedSprite2D/AttackDirection
@onready var attack_cooldown = $AttackCooldown

const START_SPEED : int = 100
const BOOST_SPEED : int = 200
var health: int = 100

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
		bullet_instance.ignore_body = self
		var direction = (attack_direction.global_position - attack_spawn_point.global_position).normalized()
		emit_signal("player_fired_bullet", bullet_instance, attack_spawn_point.global_position, direction)
		attack_cooldown.start()

func handle_hit():
	health -= 20
	print("player hit", health)

func boost():
	$BoostTimer.start()
	speed = BOOST_SPEED

func _on_boost_timer_timeout() -> void:
	speed = START_SPEED
