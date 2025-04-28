extends Area2D

#
#func _ready() -> void:
	#body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		#body.queue_free()
		await get_tree().create_timer(3.0).timeout
		print("scene transition")
		# get_tree().change_scene_to_file("res://path_to_new_scene.tscn")
