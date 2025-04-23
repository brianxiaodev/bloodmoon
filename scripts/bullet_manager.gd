extends Node2D

func handle_bullet_spawned(bullet: Area2D, position: Vector2, direction: Vector2):
	add_child(bullet)
	bullet.global_position = position
	bullet.set_direction(direction)

#@export var bullet_scene: PackedScene
#
#func _on_player_shoot(pos, dir):
	#var bullet = bullet_scene.instantiate()
	#add_child(bullet)
	#bullet.position = pos
	#bullet.direction = dir.normalized()
	#bullet.add_to_group("bullets")
