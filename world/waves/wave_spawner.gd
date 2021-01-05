extends Node

signal wave_finished(current_wave, remaining_waves)

const MAP_BOUNDS = Vector2(640, 360)
const TIME_BEFORE_FIRST_WAVE = 5
const COLORS = [Globals.Colors.RED, Globals.Colors.BLUE, Globals.Colors.YELLOW]

export(Array, Resource) var waves = []

var remaining_enemies := 0
var current_wave := 0

func _ready():
	randomize()
	yield(get_tree().create_timer(TIME_BEFORE_FIRST_WAVE), "timeout")
	_spawn_wave(current_wave)

func spawn_next_wave():
	current_wave += 1
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
				enemy.connect("killed", self, "_on_Enemy_killed")
				enemy.global_position = pos
				
				remaining_enemies += 1
				
				yield(get_tree().create_timer(randf() * 0.2), "timeout")
		
		print("Wave " + str(current_wave) + " spawned! Defeat them all!")

func _on_Enemy_killed():
	remaining_enemies -= 1
	
	if remaining_enemies <= 0:
		remaining_enemies = 0
		emit_signal("wave_finished")
		$RestTime.start()

func _on_RestTime_timeout():
	spawn_next_wave()
