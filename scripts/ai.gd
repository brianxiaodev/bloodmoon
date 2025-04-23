extends Node2D

signal state_changed(new_state)

enum State {
	PATROL,
	ENGAGE
}
@onready var enemy = get_parent() as CharacterBody2D
@onready var zone = $PlayerDetectionZone

var current_state = State.PATROL
var target : CharacterBody2D = null

func _ready() -> void:
	zone.body_entered.connect(_on_player_detection_zone_body_entered)
	zone.body_exited.connect(_on_player_detection_zone_body_exited)

func _physics_process(delta: float) -> void:
	match current_state:
		State.PATROL:
			pass
		State.ENGAGE:
			if target and is_instance_valid(target) and is_instance_valid(enemy):
				var facing_dir = target.global_position.x - enemy.global_position.x
				enemy.get_node("AnimatedSprite2D").flip_h = facing_dir < 0
		_:
			print("error: found a state for our enemy that should not exist")

func set_state(new_state: int):
	if new_state != current_state:
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
