extends AudioStreamPlayer2D

@export var fade_speed: float = 2.0 

var target_volume_db: float = 0.0  
var fading: bool = false

func _ready():
	volume_db = -80 
	playing = true
	fade_in()  

func _process(delta):
	print(volume_db)
	if fading:
		if volume_db < target_volume_db:
			volume_db = min(volume_db + fade_speed * delta * 10, target_volume_db)
		elif volume_db > target_volume_db:
			volume_db = max(volume_db - fade_speed * delta * 10, target_volume_db)
		
		if volume_db == target_volume_db:
			fading = false

func fade_in():
	target_volume_db = 0  
	fading = true
