extends Area2D

@export var heal_amount: int = 10
@onready var player = $Player  # Path to the player node

func _ready() -> void:
	$AnimatedSprite2D.play()

func _on_body_entered(body: Node2D) -> void:
	body.heal(heal_amount)
	queue_free()
