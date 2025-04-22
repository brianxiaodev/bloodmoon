extends CharacterBody2D

var health: int = 100
@onready var ai = $AI

func handle_hit():
	health -= 20
	if health <= 0:
		$AnimatedSprite2D.animation = "dead"
		$AnimatedSprite2D.speed_scale = 2.5
		$AnimatedSprite2D.play()
		queue_free()
