extends Control

export(PackedScene) var next_scene = null

func _ready():
	if $AnimationPlayer != null:
		$AnimationPlayer.play(Globals.ANIM_IDLE)

func _input(event):
	if event.is_action_pressed("ui_accept"):
		Globals.change_scene(next_scene)
