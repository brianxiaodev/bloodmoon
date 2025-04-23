extends CanvasLayer


@onready var health_bar = $HealthBar

func update_health(value: int) -> void:
	print("we're updating health!")
	health_bar.value = value
