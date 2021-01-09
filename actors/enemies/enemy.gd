extends Actor
class_name Enemy

var rnd_spd: float = 1

onready var attack_cooldown_timer := $AttackCooldown
onready var player_detector = get_tree().get_current_scene().get_node("World/PlayerDetector")

func _ready():
	._ready()
	rnd_spd = randf() * 0.4 + 0.8

func move(direction: Vector2):
	var _er = move_and_slide(direction * actor_data.max_speed * rnd_spd)

func setup_enemy(color_index: int, actual_wave: int = 0):
	$BodyPaletteSwapper.change_palette(color_index)
	current_color_index = color_index

func attack(rotation_offset: float = 0):
	var dir = Vector2.RIGHT
	if player_detector.player != null:
		dir = -player_detector.get_player_direction_to(self.global_position)
	
	var angle = dir.angle() + deg2rad(rotation_offset)
	dir = Globals.angle_to_vector(angle)
	
	attack_spawner.execute_attack(actor_data.attack, dir, $AttackPoint.global_position,
		Globals.CollisionLayers.EnemyHitbox, Globals.Colors.PURPLE)

func _flip_to_player():
	if player_detector.player != null:
		_flip(-player_detector.get_player_direction_to(self.global_position))

func try_damaging(proj):
	if !$InvincibilityTimer.is_stopped():
		return
	
	if proj.color_i == current_color_index:
		proj.destroy_projectile()
		
		$Health.do_damage(1)
		$InvincibilityTimer.start()

func _on_Health_changed(current_health):
	$HurtSFX.play()
	
	if current_health <= 0:
		pause_mode = PAUSE_MODE_STOP
		$Hurtbox/CollisionShape2D.set_deferred("disabled", true)
		anim_player.stop()
		visible = false
		pause_mode = PAUSE_MODE_STOP
		emit_signal("died")
		
		_play_death_particles(Vector2.ZERO)
		yield(get_tree().create_timer(1), "timeout")
		
		queue_free()
	else:
		Globals.blink_white($BodyPaletteSwapper)
