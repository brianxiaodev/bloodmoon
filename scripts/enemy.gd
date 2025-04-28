extends CharacterBody2D
class_name Enemy

@export var Bullet: PackedScene
@export var fire_rate   : float = 0.8

@onready var attack_spawn_point = $AnimatedSprite2D/AttackSpawnPoint
@onready var attack_direction = $AnimatedSprite2D/AttackDirection
@onready var health_stat = $Health
@onready var ai = $AI
@onready var shooting_timer = $ShootingTimer


@onready var hurt_flash_timer = $HurtFlashTimer
var is_hurt = false

@onready var ui = get_tree().root.get_node("Blood Moon/UI")

var is_dead : bool = false
var original_scale = Vector2.ONE
var player_in_zone = false

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
	is_hurt = true
	$AnimatedSprite2D.modulate = Color(1,0,0) #flash red
	hurt_flash_timer.start()
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

	#disconnect ai process
	ai.state_changed.disconnect(_on_state_changed)
	ai.set_process(false)
	ai.set_physics_process(false)

	# Stop all animation conflicts
	$AnimatedSprite2D.stop()
	$AnimatedSprite2D.play("dead")
	 


func _on_animated_sprite_2d_frame_changed() -> void:
	if $AnimatedSprite2D.animation == "dead":
		var current_frame = $AnimatedSprite2D.frame
		if current_frame >= 14 and current_frame <= 16:
			$AnimatedSprite2D.scale = original_scale * 6 
		else:
			$AnimatedSprite2D.scale = original_scale
		if current_frame == $AnimatedSprite2D.sprite_frames.get_frame_count("dead") - 1:
			queue_free()


func _on_hurt_flash_timer_timeout() -> void:
	is_hurt = false
	$AnimatedSprite2D.modulate = Color(1,1,1)

func _on_player_entered_zone():
	player_in_zone = true

func _on_player_exited_zone():
	player_in_zone = false
