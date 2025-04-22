extends Area2D
class_name  Bullet

@export var speed: float = 100
@onready var kill_timer = $KillTimer

var direction: Vector2 = Vector2.ZERO


func _ready() -> void:
	kill_timer.start()
	$AnimatedSprite2D.play("bat")

func _physics_process(delta: float) -> void:
	if direction != Vector2.ZERO:
		position += direction.normalized() * speed * delta
	

func set_direction(dir : Vector2) -> void:
	direction = dir
	rotation += direction.angle()


func _on_kill_timer_timeout() -> void:
	queue_free()
