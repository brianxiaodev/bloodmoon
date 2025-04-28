extends Node2D

@onready var bullet_manager = $BulletManager
@onready var player = $Vampire
@onready var ui_scene = preload("res://scenes/ui.tscn")  # Preload the UI scene
var collected_powerups: Array[String] = [] 
var ui

func _ready() -> void:
	randomize()
	var health_node = $Vampire/Health
	ui = ui_scene.instantiate()
	get_node("/root").add_child(ui)
	var health_bar = ui.get_node("HealthBar")
	player.connect("player_fired_bullet", Callable(bullet_manager, "handle_bullet_spawned"))
	var success = health_node.health_changed.connect(health_bar.update_health)
	health_bar.update_health(100)

func update_powerup_display(powerup_name: String):
	if ui:
		ui.update_powerup_display(powerup_name)
