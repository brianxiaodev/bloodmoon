extends Node2D

@onready var bullet_manager = $BulletManager
@onready var player = $Vampire

func _ready() -> void:
	var health_node = $Vampire/Health
	var health_ui = $UI
	
	player.connect("player_fired_bullet", Callable(bullet_manager, "handle_bullet_spawned"))

	var success = health_node.health_changed.connect(health_ui.update_health)
	print("Signal connected? ", success)
	health_ui.update_health(health_node.health)		# initialize healthbar
