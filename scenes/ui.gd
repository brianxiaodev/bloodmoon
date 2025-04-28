extends CanvasLayer 

@onready var powerup_label = $PowerupLabel
var collected_powerups: Array = [] 

func update_powerup_display(new_powerup: String = "") -> void:
	if new_powerup != "":
		if not collected_powerups.has(new_powerup):
			collected_powerups.append(new_powerup)

	if collected_powerups.size() == 0:
		powerup_label.text = "Powerups: None"
	else:
		powerup_label.text = "Powerups: " + ", ".join(collected_powerups)
