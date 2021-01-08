extends CanvasLayer

onready var shader_material = $ColorRect.material
onready var tween = $Tween

func adjust_screen_brightness(value, duration = 0):
	tween.interpolate_property(shader_material, "shader_param/brightness",
		shader_material.get_shader_param("brightness"), value, duration)
	tween.start()

func adjust_screen_contrast(value, duration = 0):
	tween.interpolate_property(shader_material, "shader_param/contrast",
		shader_material.get_shader_param("contrast"), value, duration)
	tween.start()

func adjust_screen_saturation(value, duration = 0):
	tween.interpolate_property(shader_material, "shader_param/saturation",
		shader_material.get_shader_param("saturation"), value, duration)
	tween.start()

func reset_screen():
	tween.stop_all()
	shader_material.set_shader_param("brightness", 1)
	shader_material.set_shader_param("contrast", 1)
	shader_material.set_shader_param("saturation", 1)
