extends Control

export(PackedScene) var next_scene = null

func _ready():
	randomize()
	$TimeToTransition.start()
	
	var monsters = [
		load("res://actors/enemies/slime/Slime.tscn"),
		load("res://actors/enemies/demon/Demon.tscn"),
		load("res://actors/enemies/golem/Golem.tscn"),
	]
	
	var colors = [
		Globals.Colors.RED,
		Globals.Colors.BLUE,
		Globals.Colors.YELLOW,
	]
	
	for _i in range(32):
		var m = monsters[randi() % monsters.size()].instance()
		$Monsters.add_child(m)
		m.global_position = (Vector2(randf() - 0.5, randf() - 0.5) * 148
			+ Vector2(320 / 2, 180 / 2) - Vector2(312, 32))
		
		m.setup_enemy(colors[randi() % colors.size()])

	$World/Player/Camera2D.queue_free()

func _on_TimeToTransition_timeout():
	Globals.change_scene(next_scene, 2)
