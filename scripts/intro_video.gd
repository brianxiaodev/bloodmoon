extends VideoStreamPlayer

@onready var viewport_size = Vector2(get_viewport().size)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if stream:
		await self.ready
		var texture = get_video_texture()
		var video_size = texture.get_size()
		_fit_video_to_screen(video_size)

func _input(event):
	if event.is_action_pressed("shoot"):
		skip_intro()

func skip_intro():
	stop()  # Stop the video
	get_tree().change_scene_to_file("res://scenes/blood_moon.tscn")


func _fit_video_to_screen(video_size: Vector2) -> void:
	var video_aspect = video_size.x / video_size.y
	var viewport_aspect = viewport_size.x / viewport_size.y
	if video_aspect > viewport_aspect:
		# Video is wider than screen -> fit width
		scale.x = viewport_size.x / video_size.x
		scale.y = scale.x
	else:
		# Video is taller -> fit height
		scale.y = viewport_size.y / video_size.y
		scale.x = scale.y
		
	# Center the video
	position = (viewport_size - video_size * scale) / 2


func _on_finished() -> void:
	get_tree().change_scene_to_file("res://scenes/blood_moon.tscn")
