extends CanvasLayer

const WAVE_HUD_TEXT = "Onda %s de %s"

func _ready():
	var player = get_tree().get_current_scene().get_node("World/Player")
	player.connect("damaged", self, "_on_Player_damaged")
	player.connect("wand_color_changed", self, "_on_Player_wand_color_changed")
	
	var wave_spawner = get_tree().get_current_scene().get_node("World/WaveSpawner")
	wave_spawner.connect("wave_started", self, "_update_wave_text")
	_update_wave_text(0, wave_spawner.waves.size())
	
	$ColorHUD/PaletteSwapper.change_palette(player.current_color_index)
	_update_health(player.get_node("Health").current_health)

func _update_wave_text(wave_number, total_waves):
	$WaveHUD/Label.text = WAVE_HUD_TEXT % [wave_number, total_waves]

func _update_health(value):
	$HealthHUD/Sprite.region_rect = Rect2(0, 0, 16 * value, 16)

func _on_Player_wand_color_changed(color_index):
	$ColorHUD/PaletteSwapper.change_palette(color_index)

func _on_Player_damaged(current_health):
	Globals.blink_white($HealthHUD/PaletteSwapper, 0.1)
	yield(get_tree().create_timer(0.1), "timeout")
	_update_health(current_health)
