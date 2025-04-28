extends Area2D

var item_type : int 	# different types of power ups; 1 - bats, 2 - shadow, 3 - dash

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# rn only have bats and dash bc shadow isn't setup yet
	item_type = randi_range(0, 2)	# set to random powerup
	$AnimatedSprite2D.play()
	print("Item Ready!")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node2D) -> void:
	var main = get_tree().root.get_node("Blood Moon")
	#if item_type == 0:
	if item_type == 0:
		print("Bats")
		if body.has_method("activate_bats"):
			print("do we get here???")
			body.activate_bats()
		  # Adjust the path if different
		main.update_powerup_display("Bats")
	elif item_type == 1:
		print("Shadow")
		if body.has_method("activate_shadow"):
			body.activate_shadow()
		main.update_powerup_display("Shadow")
	#elif item_type == 2:
	elif item_type == 2:
		print("Dash")
		#body.boost()
		if body.has_method("activate_dash"):
			body.activate_dash()
		main.update_powerup_display("Dash")
	# delete item
	queue_free()
	
