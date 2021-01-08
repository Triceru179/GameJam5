extends Actor
class_name Enemy

onready var attack_cooldown_timer := $AttackCooldown
onready var player_detector = get_tree().get_current_scene().get_node("World/PlayerDetector")

func _ready():
	._ready()

func setup_enemy(color_index: int):
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

func _on_Hurtbox_area_entered(area):
	if !$InvincibilityTimer.is_stopped():
		return
	
	var p = area.get_parent() as Projectile
	if p != null && p.color_i == current_color_index:
		p.destroy_projectile()
		
		$Health.do_damage(1)
		$InvincibilityTimer.start()

func _on_Health_changed(current_health):
	$HurtSFX.play()
	
	if current_health <= 0:
		emit_signal("died")
		$Pushbox.disabled = true
		visible = false
		pause_mode = PAUSE_MODE_STOP
		
		yield(get_tree().create_timer(0.2), "timeout")
		
		queue_free()
	else:
		Globals.blink_white($BodyPaletteSwapper)
