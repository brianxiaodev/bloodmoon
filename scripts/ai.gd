extends Node2D

signal state_changed(new_state)

enum State {
	PATROL,
	ENGAGE
}

#@onready var player_detection_zone = $PlayerDetectionZone

#var state = State.PATROL

#func set_state(new_state: int):
#	pass
