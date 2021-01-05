extends Node

const PALETTE_WHITE = preload("res://actors/palette_default.png")

export(NodePath) var target_sprite = null

export(Texture) var palette_default = PALETTE_WHITE
export(Texture) var palette_red = null
export(Texture) var palette_blue = null
export(Texture) var palette_yellow = null
export(Texture) var palette_purple = null

var current_palette_index := 0

onready var palettes = {
	Globals.Colors.DEFAULT: palette_default,
	Globals.Colors.RED: palette_red,
	Globals.Colors.BLUE: palette_blue,
	Globals.Colors.YELLOW: palette_yellow,
	Globals.Colors.PURPLE: palette_purple,
	Globals.Colors.WHITE: PALETTE_WHITE,
}

func _ready():
	change_palette(Globals.Colors.DEFAULT)

func change_palette(color_index: int):
	var palette = palettes[color_index]
	if palette != null:
		get_node(target_sprite).material.set_shader_param("palette", palette)
		current_palette_index = color_index
	else:
		push_error("Failed to pass a index that isn't on the colors range.")
