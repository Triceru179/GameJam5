extends Actor
class_name Enemy

var rnd_spd: float = 1
var player_min_distance_to_attack = pow(10 * 16, 2)
var min_distance_to_player = pow(16, 2)

onready var attack_cooldown_timer := $AttackCooldown
onready var player_detector = get_tree().get_current_scene().get_node("World/PlayerDetector")

func _ready():
	._ready()
	rnd_spd = randf() * 0.4 + 0.8

func move(direction: Vector2, spd_mod: float = 1):
	var _er = move_and_slide(direction * actor_data.max_speed * spd_mod * rnd_spd)

func setup_enemy(color_index: int):
	change_color(color_index)

func attack(rotation_offset: float = 0):
	if is_dead:
		return
	
	var dir = Vector2.RIGHT
	if player_detector.player != null:
		dir = -player_detector.get_player_direction_to(self.global_position)
	
	var angle = dir.angle() + deg2rad(rotation_offset)
	dir = Globals.angle_to_vector(angle)
	
	attack_spawner.execute_attack(actor_data.attack, dir, $AttackPoint.global_position,
		true, Globals.Colors.PURPLE)

func change_color(color_index):
	$BodyPaletteSwapper.change_palette(color_index)
	current_color_index = color_index

func _flip_to_player():
	if player_detector.player != null:
		_flip(-player_detector.get_player_direction_to(self.global_position).x)

func try_damaging(proj):
	if !$InvincibilityTimer.is_stopped():
		return
	
	if proj.color_i == current_color_index:
		proj.destroy_projectile()
		
		$Health.do_damage(1)
		$InvincibilityTimer.start()

func _on_Health_changed(current_health):
	if current_health <= 0:
		is_dead = true
		emit_signal("died")
		_play_death_particles(Vector2.ZERO)
		
		var death_sfx = $DeathSFX
		death_sfx.connect("finished", death_sfx, "queue_free")
		remove_child(death_sfx)
		get_parent().add_child(death_sfx)
		death_sfx.global_position = global_position
		death_sfx.play()
		
		queue_free()
	else:
		$HurtSFX.play()
		Globals.blink_white($BodyPaletteSwapper)

func _on_Hitbox_area_entered(area):
	if area.get_parent() is Player:
		area.get_parent().try_damaging(null)
