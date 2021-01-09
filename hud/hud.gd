extends CanvasLayer

const WAVE_HUD_TEXT = "Wave %s of %s"

func _ready():
	var player = get_tree().get_current_scene().get_node("World/Player")
	player.connect("damaged", self, "_on_Player_damaged")
	player.connect("wand_color_changed", self, "_on_Player_wand_color_changed")
	player.connect("magic_upgraded", self, "_on_Player_magic_upgraded")
	
	var wave_spawner = get_tree().get_current_scene().get_node("World/WaveSpawner")
	wave_spawner.connect("wave_started", self, "_show_wave_info")
	_update_wave_text(0, wave_spawner.waves.size())
	
	$WaveHUD.modulate = Globals.COLOR_TRASPARENT
	$UpgradeHUD.modulate = Globals.COLOR_TRASPARENT
	$ColorHUD/PaletteSwapper.change_palette(player.current_color_index)
	_update_health(player.get_node("Health").current_health)

func _update_wave_text(wave_number, total_waves):
	$WaveHUD/Label.text = WAVE_HUD_TEXT % [wave_number, total_waves]

func _show_wave_info(wave_number, total_waves):
	var tween = $Tween
	var fade_duration = 1.0
	var duration_on_screen = 2.0
	
	_update_wave_text(wave_number, total_waves)
	
	tween.interpolate_property($WaveHUD, "modulate", Globals.COLOR_TRASPARENT,
		Globals.COLOR_DEFAULT, fade_duration / 2)
	tween.interpolate_property($WaveHUD, "modulate", Globals.COLOR_DEFAULT,
		Globals.COLOR_TRASPARENT, fade_duration / 2, Tween.TRANS_LINEAR,
		Tween.EASE_IN_OUT, duration_on_screen)
	tween.start()

func _on_Player_magic_upgraded():
	var tween = $Tween
	var fade_duration = 1.0
	var duration_on_screen = 2.0
	
	tween.interpolate_property($UpgradeHUD, "modulate", Globals.COLOR_TRASPARENT,
		Globals.COLOR_DEFAULT, fade_duration / 2)
	tween.interpolate_property($UpgradeHUD, "modulate", Globals.COLOR_DEFAULT,
		Globals.COLOR_TRASPARENT, fade_duration / 2, Tween.TRANS_LINEAR,
		Tween.EASE_IN_OUT, duration_on_screen)
	tween.start()

func _update_health(value):
	$HealthHUD/Sprite.region_rect = Rect2(0, 0, 16 * value, 16)

func _on_WaveSpawner_enemy_count_changed(value):
	$EnemyCountHUD/Label.text = str(value)

func _on_Player_wand_color_changed(color_index):
	$ColorHUD/PaletteSwapper.change_palette(color_index)

func _on_Player_damaged(current_health):
	Globals.blink_white($HealthHUD/PaletteSwapper, 0.1)
	yield(get_tree().create_timer(0.1), "timeout")
	_update_health(current_health)
