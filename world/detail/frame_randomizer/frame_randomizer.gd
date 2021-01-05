extends Node

func _ready():
	var sprite = get_parent() as Sprite
	var total_frames = sprite.hframes * sprite.vframes
	
	sprite.frame = randi() % total_frames
