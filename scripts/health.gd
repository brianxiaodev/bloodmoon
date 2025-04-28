extends Node2D

signal health_changed(new_health: int)

@export var _health_internal: int = 100
@onready var health_bar = get_node("../UI/HealthBar")


var health: int:
	get:
		return _health_internal
	set(value):
		value = clamp(value, 0, 100)
		if _health_internal != value:
			print("value changed!")
			print(value)
			_health_internal = value
			health_changed.emit(_health_internal)
			_update_health_bar()

func _update_health_bar():
	health_bar.value = _health_internal
