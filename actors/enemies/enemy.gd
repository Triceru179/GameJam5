extends Actor

onready var player_detector = $PlayerDetector
onready var attack_cooldown_timer = $AttackCooldown

func setup_enemy(color_index: int):
	$BodyPaletteSwapper.change_palette(color_index)

func attack(attack_data: AttackData, rotation_offset: float = 0):
	var dir = Vector2.RIGHT
	if player_detector.player != null:
		dir = -player_detector.get_player_direction_to(self.global_position)
	
	var angle = dir.angle() + deg2rad(rotation_offset)
	dir = Globals.angle_to_vector(angle)
	
	attack_spawner.execute_attack(attack_data, dir, $AttackPoint.global_position,
		Globals.CollisionLayers.EnemyHitbox)

func _flip_to_player():
	if player_detector.player != null:
		_flip(-player_detector.get_player_direction_to(self.global_position))
