extends Node2D

signal state_changed(new_state)

enum State {
	PATROL,
	ENGAGE
}

@onready var enemy = get_parent() as CharacterBody2D
@onready var zone = $PlayerDetectionZone
@onready var patrol_timer = $PatrolTimer

var current_state = -1
var target : CharacterBody2D = null

#PATROL STATE
var origin: Vector2 = Vector2.ZERO
var patrol_location: Vector2 = Vector2.ZERO
var patrol_location_reached: bool = false
var enemy_velocity: Vector2 = Vector2.ZERO


func _ready() -> void:
	set_state(State.PATROL)
	zone.body_entered.connect(_on_player_detection_zone_body_entered)
	zone.body_exited.connect(_on_player_detection_zone_body_exited)

func _physics_process(delta: float) -> void:
	match current_state:
		State.PATROL:
			if not patrol_location_reached:
				enemy.velocity = enemy_velocity
				enemy.move_and_slide()
				if enemy_velocity.x != 0:
					enemy.get_node("AnimatedSprite2D").flip_h = enemy_velocity.x < 0
				if enemy_velocity.length() > 1:
					if enemy.get_node("AnimatedSprite2D").animation != "walk":
						enemy.get_node("AnimatedSprite2D").play("walk")
				else:
					if enemy.get_node("AnimatedSprite2D").animation != "idle":
						enemy.get_node("AnimatedSprite2D").play("idle")
				if enemy.global_position.distance_to(patrol_location) < 5:
					patrol_location_reached = true
					enemy_velocity = Vector2.ZERO
					patrol_timer.start()
			else:
				if enemy.get_node("AnimatedSprite2D").animation != "idle":
					enemy.get_node("AnimatedSprite2D").play("idle")
		State.ENGAGE:
			if target and is_instance_valid(target) and is_instance_valid(enemy):
				var facing_dir = target.global_position.x - enemy.global_position.x
				enemy.get_node("AnimatedSprite2D").flip_h = facing_dir < 0
		_:
			print("error: found a state for our enemy that should not exist")

func set_state(new_state: int):
	if new_state == current_state:
		return
		
	if new_state == State.PATROL:
		origin = global_position
		patrol_timer.start()
		patrol_location_reached = true
		
	current_state = new_state
	emit_signal("state_changed", current_state)
	
		
func _on_player_detection_zone_body_entered(body: Node2D) -> void:
	if body is Vampire:
		target = body
		set_state(State.ENGAGE)

func _on_player_detection_zone_body_exited(body: Node2D) -> void:
	if body is Vampire:
		target = null
		set_state(State.PATROL)

func _on_patrol_timer_timeout() -> void:
	var patrol_range = 50
	var random_x = randf_range(-patrol_range, patrol_range)
	var random_y = randf_range(-patrol_range, patrol_range)
	patrol_location = Vector2(random_x, random_y) + origin
	patrol_location_reached = false
	enemy_velocity = enemy.global_position.direction_to(patrol_location) * 50
	
