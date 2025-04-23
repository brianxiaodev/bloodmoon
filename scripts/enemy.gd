extends CharacterBody2D

@export var Bullet: PackedScene
@onready var attack_spawn_point = $AnimatedSprite2D/AttackSpawnPoint
@onready var attack_direction = $AnimatedSprite2D/AttackDirection
#@onready var attack_cooldown = $AttackCooldown
@onready var health_stat = $Health
@onready var ai = $AI
@onready var shooting_timer = $ShootingTimer

func _ready() -> void:
	$PlayerDetectionZone.connect("body_entered", Callable(self, "_on_player_entered_zone"))
	ai.connect("state_changed", Callable(self, "_on_state_changed"))
	shooting_timer.timeout.connect(_on_shooting_timer_timeout)
	
func _on_state_changed(new_state: int) -> void:
	if new_state == ai.State.ENGAGE:
		shooting_timer.start()
	else:
		shooting_timer.stop()
		
func _on_shooting_timer_timeout() -> void:
	shoot()

func _on_player_entered_zone(body: Node2D) -> void:
	if body.name == "Vampire":  # or use `is Vampire`
		ai.set_state(ai.State.ENGAGE)


func shoot():
	$AnimatedSprite2D.animation = "shoot"
	$AnimatedSprite2D.speed_scale = 2.5
	$AnimatedSprite2D.play()
	var bullet_instance = Bullet.instantiate()
	bullet_instance.ignore_body = self
	var direction = (attack_direction.global_position - attack_spawn_point.global_position).normalized()
	get_parent().get_node("BulletManager").handle_bullet_spawned(bullet_instance, attack_spawn_point.global_position, direction)
	

func handle_hit():
	health_stat.health -= 20
	if health_stat.health <= 0:
		$AnimatedSprite2D.animation = "dead"
		$AnimatedSprite2D.speed_scale = 2.5
		$AnimatedSprite2D.play()
		$AnimatedSprite2D.connect("animation_finished", Callable(self, "_on_death_animation_finished"))

func _on_death_animation_finished():
	queue_free()
	


func _on_player_detection_zone_body_entered(body: Node2D) -> void:
	if body is Vampire:
		ai.set_state(ai.State.ENGAGE)


func _on_player_detection_zone_body_exited(body: Node2D) -> void:
	if body is Vampire:
		ai.set_state(ai.State.PATROL)
