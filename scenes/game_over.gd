extends CanvasLayer

func _unhandled_input(event):
	if event.is_action_pressed("ui_accept"): 
		get_tree().reload_current_scene()
