extends Area2D
class_name  Bullet

@export var speed: float = 100
@onready var kill_timer = $KillTimer

var direction: Vector2 = Vector2.ZERO
var ignore_body: Node2D = null  # ← Who fired the bullet


func _ready() -> void:
	kill_timer.start()
	$AnimatedSprite2D.play("fireball")
	$AnimatedSprite2D.scale = Vector2(0.03, 0.03)

func _physics_process(delta: float) -> void:
	if direction != Vector2.ZERO:
		position += direction.normalized() * speed * delta
	

func set_direction(dir : Vector2) -> void:
	direction = dir
	rotation += direction.angle()


func _on_kill_timer_timeout() -> void:
	queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body == ignore_body:
		return
	if body.has_method("handle_hit"):
		body.handle_hit()
		queue_free()
