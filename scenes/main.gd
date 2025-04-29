extends Node2D

@onready var bullet_manager = $BulletManager
@onready var player = $Vampire
@onready var ui_scene = preload("res://scenes/ui.tscn")  # Preload the UI scene
#var enemies = []
#@onready var win_screen = preload("res://scenes/win.tscn")

var collected_powerups: Array[String] = [] 
var ui
var stealth_bar

func _ready() -> void:
	randomize()
	
	#for child in get_children():
		#if child is Enemy:
			#enemies.append(child)
			#child.connect("tree_exited", Callable(self, "_on_enemy_died"))
	
	var health_node = $Vampire/Health
	ui = ui_scene.instantiate()

	get_node("/root").add_child(ui)
	
	var health_bar = ui.get_node("HealthBar")
	stealth_bar = ui.get_node("StealthBar")
	stealth_bar.visible = false 
	player.connect("player_fired_bullet", Callable(bullet_manager, "handle_bullet_spawned"))
	player.connect("shadow_unlocked", Callable(self, "on_shadow_unlocked"))

	var success = health_node.health_changed.connect(health_bar.update_health)
	health_bar.update_health(100)
	player.connect("stealth_changed", Callable(stealth_bar, "update_stealth"))

#func _on_enemy_died():
	#check_win_condition()

#func check_win_condition():
	## Remove any enemies that are no longer inside the tree
	#enemies = enemies.filter(func(e): return e.is_inside_tree())
	#
	#if enemies.is_empty():
		#show_win_screen()

#func show_win_screen():
	#if ui:
		#ui.visible = false
		#
	#var won = win_screen.instantiate()
	#add_child(won)
	#win_image_node.position = get_viewport_rect().size / 2
	#win_image_node.offset = win_screen.get_size() / -2

func _process(delta):
	if player and player.is_dead:
		if ui:
			ui.visible = false
	else:
		if stealth_bar:
			stealth_bar.value = player.current_stealth_meter


func update_powerup_display(powerup_name: String):
	if ui:
		ui.update_powerup_display(powerup_name)

func on_shadow_unlocked():
	if stealth_bar:
		stealth_bar.visible = true
