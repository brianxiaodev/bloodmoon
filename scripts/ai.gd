extends Node2D

signal state_changed(new_state)

enum State {
	PATROL,
	ENGAGE
}

var current_state = State.PATROL

func set_state(new_state: int):
	if new_state != current_state:
		current_state = new_state
		emit_signal("state_changed", current_state)
