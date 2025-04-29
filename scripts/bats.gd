extends Area2D
class_name Bats

@export var speed: float = 150
@export var damage: int = 10
@export var heal_amount: int = 5
@onready var kill_timer = $KillTimer

var direction: Vector2 = Vector2.ZERO
var ignore_body: Node2D = null  # Who fired the bat (likely the vampire)


func _ready() -> void:
	kill_timer.start()
	$AnimatedSprite2D.play("bats")

func _physics_process(delta: float) -> void:
	if direction != Vector2.ZERO:
		position += direction.normalized() * speed * delta

func set_direction(dir : Vector2) -> void:
	direction = dir
	rotation += direction.angle()

func _on_kill_timer_timeout() -> void:
	queue_free()

func _on_body_entered(body: Node2D) -> void:
	print("BAT ENTERED BODY")
	if body == ignore_body:
		return
	if body.is_in_group("Playerdetection"):
		print("Hit PlayerDetectionZone — ignored")
		return
	if body.has_method("handle_hit"):
		if body is Vampire and body.is_stealth:
			print("Bat ignored stealth Vampire")
			return
		print("Calling handle_hit() on", body.name)
		body.handle_hit()
		heal_player()
		queue_free()
	else:
		print("Hit", body.name, "but no handle_hit method")

func heal_player() -> void:
	if ignore_body and ignore_body.has_method("heal"):
		ignore_body.heal(heal_amount)
	
