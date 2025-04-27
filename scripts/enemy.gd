extends CharacterBody2D
class_name Enemy

@export var Bullet: PackedScene
@export var fire_rate   : float = 0.8

@onready var attack_spawn_point = $AnimatedSprite2D/AttackSpawnPoint
@onready var attack_direction = $AnimatedSprite2D/AttackDirection
@onready var health_stat = $Health
@onready var ai = $AI
@onready var shooting_timer = $ShootingTimer

var is_dead : bool = false
var original_scale = Vector2.ONE

func _ready() -> void:
	#$PlayerDetectionZone.connect("body_entered", Callable(self, "_on_player_entered_zone"))
	#ai.connect("state_changed", Callable(self, "_on_state_changed"))
	#shooting_timer.timeout.connect(_on_shooting_timer_timeout)
	$AnimatedSprite2D.play("idle") 
	original_scale = $AnimatedSprite2D.scale
	ai.state_changed.connect(_on_state_changed)
	shooting_timer.wait_time = fire_rate
	shooting_timer.timeout.connect(_on_shooting_timer_timeout)
	
func _on_state_changed(new_state: int) -> void:
	if new_state == ai.State.ENGAGE:
		shooting_timer.start()
	else:
		shooting_timer.stop()
		
func _on_shooting_timer_timeout() -> void:
	shoot()

func shoot():
	if is_dead:
		return
	$AnimatedSprite2D.animation = "shoot"
	$AnimatedSprite2D.speed_scale = 2.5
	$AnimatedSprite2D.play()
	var bullet_instance = Bullet.instantiate()
	bullet_instance.ignore_body = self
	bullet_instance.animation_name = "enemyAttack"
	
	if get_node("AI").target:
		var player_pos = get_node("AI").target.global_position
		var dir = (player_pos - attack_spawn_point.global_position).normalized()
		get_parent().get_node("BulletManager").handle_bullet_spawned(bullet_instance, attack_spawn_point.global_position, dir)
	

func handle_hit():
	if is_dead:
		return
	health_stat.health -= 20
	print("Current health:", health_stat.health)
	if health_stat.health <= 0:
		die()
		#$AnimatedSprite2D.animation = "dead"
		#$AnimatedSprite2D.speed_scale = 2.5
		#$AnimatedSprite2D.play()
		##$AnimatedSprite2D.animation_finished.connect(queue_free)
		#$AnimatedSprite2D.connect("animation_finished", Callable(self, "_on_death_animation_finished"))

func die():
	if is_dead:
		return
	is_dead = true
	print("Enemy dying...")

	# Stop shooting
	shooting_timer.stop()

	# Optional: Disconnect AI signal to avoid state flips
	ai.state_changed.disconnect(_on_state_changed)

	# Stop all animation conflicts
	$AnimatedSprite2D.stop()
	$AnimatedSprite2D.play("dead")
	#$AnimatedSprite2D.frame = 0

	
	$AnimatedSprite2D.animation_finished.connect(
			_on_death_animation_finished,
			Object.CONNECT_ONE_SHOT
		)


func _on_death_animation_finished():
	queue_free()


func _on_animated_sprite_2d_frame_changed() -> void:
	if $AnimatedSprite2D.animation == "dead":
		var current_frame = $AnimatedSprite2D.frame
		if current_frame >= 14 and current_frame <= 16:
			$AnimatedSprite2D.scale = original_scale * 6 
		else:
			$AnimatedSprite2D.scale = original_scale
