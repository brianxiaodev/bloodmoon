extends Node2D

@onready var bullet_manager = $BulletManager
@onready var player = $Vampire
@onready var powerup_label = $PowerUpUI/PowerUpLabel

@onready var health_ui_scene = preload("res://scenes/ui.tscn")  # Preload the UI scene
var collected_powerups: Array[String] = [] 

func _ready() -> void:
	randomize()
	var health_node = $Vampire/Health
	var health_ui = health_ui_scene.instantiate()
	get_node("/root").add_child(health_ui)
	var health_bar = health_ui.get_node("HealthBar")
	player.connect("player_fired_bullet", Callable(bullet_manager, "handle_bullet_spawned"))
	var success = health_node.health_changed.connect(health_bar.update_health)
	health_bar.update_health(100)

func update_powerup_display(new_powerup: String = "") -> void:
	if new_powerup != "":
		if not collected_powerups.has(new_powerup):
			collected_powerups.append(new_powerup)
	
	if collected_powerups.size() == 0:
		powerup_label.text = "Powerups: None"
	else:
		powerup_label.text = "Powerups: " + ", ".join(collected_powerups)
