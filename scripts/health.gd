extends Node2D

@export var _health_internal: int = 100

var health: int:
	get:
		return _health_internal
	set(value):
		_health_internal = clamp(value, 0, 100)
