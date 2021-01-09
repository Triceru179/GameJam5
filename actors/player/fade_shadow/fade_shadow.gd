extends Sprite

func setup_sprite(texture: Texture, offset: Vector2, global_position: Vector2,
		scale: Vector2, hframes: int, vframes:int, frame: int):
	self.texture = texture
	self.offset = offset
	self.global_position = global_position
	self.scale = scale
	
	self.hframes = hframes
	self.vframes = vframes
	self.frame = frame

func start_fade(init_alpha: float, duration: float):
	$Tween.interpolate_property(material, "shader_param/alpha", init_alpha, 0, duration)
	$Tween.start()
	
	$Timer.wait_time = duration
	$Timer.start()
