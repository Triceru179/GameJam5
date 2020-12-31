extends Node

export(NodePath) var target_sprite = null

export(Texture) var palette_default = preload("res://actors/palette_default.png")
export(Texture) var palette_red = null
export(Texture) var palette_blue = null
export(Texture) var palette_yellow = null

onready var palettes = {
	Globals.Colors.DEFAULT: palette_default,
	Globals.Colors.RED: palette_red,
	Globals.Colors.BLUE: palette_blue,
	Globals.Colors.YELLOW: palette_yellow,
}

func _ready():
	change_palette(Globals.Colors.DEFAULT)

func change_palette(color_index: int):
	var palette = palettes[color_index]
	
	if palette != null:
		get_node(target_sprite).material.set_shader_param("palette", palette)
	else:
		push_error("Failed to pass a index that isn't on the colors range.")
