extends Node2D

@onready var bullet_manager = $BulletManager
@onready var player = $Vampire
@onready var powerup_label = $PowerUpUI/PowerUpLabel

var collected_powerups: Array[String] = [] 

func _ready() -> void:
	randomize()
	var health_node = $Vampire/Health
	var health_ui = $UI
	
	player.connect("player_fired_bullet", Callable(bullet_manager, "handle_bullet_spawned"))

	var success = health_node.health_changed.connect(health_ui.update_health)

func update_powerup_display(new_powerup: String = "") -> void:
	if new_powerup != "":
		if not collected_powerups.has(new_powerup):
			collected_powerups.append(new_powerup)
	
	if collected_powerups.size() == 0:
		powerup_label.text = "Powerups: None"
	else:
		powerup_label.text = "Powerups: " + ", ".join(collected_powerups)
