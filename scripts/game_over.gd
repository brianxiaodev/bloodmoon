extends CanvasLayer

func _ready():
	set_process_unhandled_input(true)

func _unhandled_input(event):
	if event.is_action_pressed("restart"):
		print("Restart pressed!") 
		get_tree().change_scene_to_file("res://scenes/blood_moon.tscn")
