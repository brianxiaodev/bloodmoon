extends Area2D

@export var target_scene: PackedScene

func _on_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		#body.queue_free()
		await get_tree().create_timer(1.0).timeout
		print("scene transition")
		get_tree().change_scene_to_packed(target_scene)
