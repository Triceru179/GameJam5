extends Node

signal wave_started(wave_number, total_waves)
signal all_waves_finished

const MAP_BOUNDS = Vector2(640, 360)
const COLORS = [Globals.Colors.RED, Globals.Colors.BLUE, Globals.Colors.YELLOW]

export(Array, Resource) var waves = []

var remaining_enemies := 0
var current_wave := 0

func _ready():
	randomize()
	$TimeBeforeFirstWave.start()
	yield($TimeBeforeFirstWave, "timeout")
	_spawn_wave(current_wave)

func _spawn_wave(index):
	var w_data = waves[index]
	
	if w_data != null:
		if w_data.enemies_scene.size() != w_data.enemies_quantity.size():
			push_error("The size of scene and quantity arrays are different!")
			return
		
		for i in range(0, w_data.enemies_scene.size()):
			for _t in range(0, w_data.enemies_quantity[i]):
				var enemy = w_data.enemies_scene[i].instance() as Enemy
				get_tree().get_current_scene().get_node("World").add_child(enemy)
				
				var pos = Vector2(randf() * 40 + 32 + MAP_BOUNDS.x / 2, randf() * MAP_BOUNDS.y / 2)
				var x_rand = sign(rand_range(-1, 1))
				var y_rand = sign(rand_range(-1, 1))
				pos.x *= x_rand if x_rand != 0 else 1
				pos.y *= y_rand if y_rand != 0 else 1
				
				var r_color = randi() % COLORS.size()
				enemy.setup_enemy(COLORS[r_color])
				enemy.connect("died", self, "_on_Enemy_died")
				enemy.global_position = pos
				
				remaining_enemies += 1
				
				yield(get_tree().create_timer(randf() * 0.2), "timeout")
		
		emit_signal("wave_started", str(current_wave + 1), waves.size())
		$WaveStarted.play()
		
	else:
		push_error("Wave data is null!")

func _on_Enemy_died():
	remaining_enemies -= 1
	
	if remaining_enemies <= 0:
		remaining_enemies = 0
		current_wave += 1
		
		if current_wave < waves.size():
			$RestTime.start()
		else:
			emit_signal("all_waves_finished")
			Globals.change_scene(load("res://menu/victory_menu/VictoryMenu.tscn"), 1)

func _on_RestTime_timeout():
	_spawn_wave(current_wave)
