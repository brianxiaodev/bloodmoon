extends VideoStreamPlayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.





func _on_finished() -> void:
	get_tree().change_scene_to_file("res://scenes/blood_moon.tscn")
