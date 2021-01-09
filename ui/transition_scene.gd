extends Control

export(PackedScene) var next_scene = null

var changing = false

func _ready():
	if get_node_or_null("AnimationPlayer") != null:
		$AnimationPlayer.play(Globals.ANIM_IDLE)

func _input(event):
	if event.is_action_pressed("ui_accept") && !changing:
		$MenuAccept.play()
		changing = true
		Globals.change_scene(next_scene)
