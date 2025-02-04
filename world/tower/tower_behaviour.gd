extends StaticBody2D

const SFXs = [
	preload("res://world/tower/sfxs/glass_break_1.wav"),
	preload("res://world/tower/sfxs/glass_break_2.wav"),
	preload("res://world/tower/sfxs/glass_break_3.wav"),
	preload("res://world/tower/sfxs/glass_break_4.wav"),
]

var bodies_inside := 0

onready var translucid_bodies = [
	$Body,
	$Sphere/Sprite
]

func _ready():
	$Sphere/AnimationPlayer.play(Globals.ANIM_IDLE)
	var player = get_tree().get_current_scene().get_node("World/Player")
	player.connect("wand_color_changed", self, "_on_Player_wand_color_changed")
	player.connect("damaged", self, "_on_Player_damaged")
	
	$Sphere/PaletteSwapper.change_palette(player.current_color_index)

func _check_invisibility():
	for s in translucid_bodies:
		s.modulate = Globals.COLOR_SEMI_TRASPARENT if bodies_inside > 0 else Globals.COLOR_DEFAULT

func _on_Player_wand_color_changed(color_index):
	$Sphere/PaletteSwapper.change_palette(color_index)

func _on_Player_damaged(current_health):
	Globals.blink_white($Sphere/PaletteSwapper)
	
	var audio_stream = $AudioStreamPlayer2D
	audio_stream.stream = Globals.random_sfx_from_array(SFXs)
	audio_stream.play()
	
	if current_health <= 0:
		var sphere_anim_p = $Sphere/AnimationPlayer
		sphere_anim_p.play(Globals.ANIM_DEATH)
		
		yield(sphere_anim_p, "animation_finished")
		$Sphere.visible = false
	else:
		var frame = clamp(3 - current_health + 1, 0, 3)
		$Sphere/Sprite.frame = frame

func _on_CheckBodiesInside_body_entered(_body):
	bodies_inside += 1
	_check_invisibility()

func _on_CheckBodiesInside_body_exited(_body):
	bodies_inside -= 1
	_check_invisibility()

func _on_CheckBodiesInside_area_entered(_area):
	bodies_inside += 1
	_check_invisibility()

func _on_CheckBodiesInside_area_exited(_area):
	bodies_inside -= 1
	_check_invisibility()
