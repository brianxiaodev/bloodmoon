extends Node2D

signal health_changed(new_health: int)

@export var _health_internal: int = 100

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
