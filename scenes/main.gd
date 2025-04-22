extends Node2D

@onready var bullet_manager = $BulletManager
@onready var player = $Vampire

func _ready() -> void:
	player.connect("player_fired_bullet", Callable(bullet_manager, "handle_bullet_spawned"))
