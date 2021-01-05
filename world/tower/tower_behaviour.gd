extends StaticBody2D


func _ready():
	$Sphere/AnimationPlayer.play(Globals.ANIM_IDLE)
	var player = get_tree().get_current_scene().get_node("World/Player")
	player.connect("wand_color_changed", self, "_on_Wand_color_changed")
	player.connect("damaged", self, "_on_Player_damaged")
	
	$Sphere/PaletteSwapper.change_palette(player.current_color_index)

func _on_Wand_color_changed(color_index):
	$Sphere/PaletteSwapper.change_palette(color_index)

func _on_Player_damaged(current_health):
	Globals.blink_white($Sphere/PaletteSwapper)
	
	print(current_health)
	if current_health <= 0:
		print("??")
		var sphere_anim_p = $Sphere/AnimationPlayer
		sphere_anim_p.play(Globals.ANIM_DEATH)
		
		yield(sphere_anim_p, "animation_finished")
		$Sphere.visible = false
	else:
		var frame = clamp(3 - current_health + 1, 0, 3)
		$Sphere/Sprite.frame = frame
