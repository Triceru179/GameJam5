extends Actor

func setup_enemy(color_index: int):
	$BodyPaletteSwapper.change_palette(color_index)
