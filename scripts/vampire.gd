extends CharacterBody2D

signal player_fired_bullet(bullet, position, direction)

@export var Bullet: PackedScene
@export var Bats: PackedScene

@export var speed = 100

@onready var attack_spawn_point = $AnimatedSprite2D/AttackSpawnPoint
@onready var attack_direction = $AnimatedSprite2D/AttackDirection
@onready var attack_cooldown = $AttackCooldown

const START_SPEED : int = 100
const BOOST_SPEED : int = 200
var health: int = 100
var bats_active = false

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
		
func activate_bats():
	print("do we get here x2???")
	bats_active = true
	print(bats_active)
	$BatsTimer.start()

func _on_bats_timer_timeout() -> void:
	bats_active = false

func shoot():
	$AnimatedSprite2D.animation = "attack"
	$AnimatedSprite2D.speed_scale = 2.5
	$AnimatedSprite2D.play()
	
	if attack_cooldown.is_stopped():
		# Main Bullet
		var bullet_instance = Bullet.instantiate()
		bullet_instance.ignore_body = self
		var direction = (attack_direction.global_position - attack_spawn_point.global_position).normalized()
		emit_signal("player_fired_bullet", bullet_instance, attack_spawn_point.global_position, direction)
		
		# Bats Bullet
		print(bats_active)
		if bats_active:
			print("we are shoooting bats too")
			var bats_instance = Bats.instantiate()
			bats_instance.ignore_body = self
			bats_instance.get_node("AnimatedSprite2D").play("bat")
			$AnimatedSprite2D.scale = Vector2(1, 1)
			emit_signal("player_fired_bullet", bats_instance, attack_spawn_point.global_position, direction)
		
		attack_cooldown.start()

func handle_hit():
	health -= 20
	print("player hit", health)

func boost():
	$BoostTimer.start()
	speed = BOOST_SPEED

func _on_boost_timer_timeout() -> void:
	speed = START_SPEED
