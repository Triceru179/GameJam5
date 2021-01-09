extends Actor

signal wand_color_changed(color_index)
signal magic_upgraded
signal damaged(current_health)

enum State {
	IDLE,
	MOVE,
	DASH,
}

const HURT_SFX = [
	preload("res://actors/player/sfxs/player_hurt_1.wav"),
	preload("res://actors/player/sfxs/player_hurt_2.wav"),
	preload("res://actors/player/sfxs/player_hurt_3.wav"),
	preload("res://actors/player/sfxs/player_hurt_4.wav"),
	preload("res://actors/player/sfxs/player_hurt_5.wav"),
	preload("res://actors/player/sfxs/player_hurt_6.wav"),
]

const FADE_SHADOW = preload("res://actors/player/fade_shadow/FadeShadow.tscn")

const WEAPON_DISTANCE = 8
const DASH_SPEED = 256

const WAVE_ATTACK_UPGRADES = {
	"2": {"atk_cd_redu": 0.1},
	"4": {"number": 2, "spread": 15, "proj_speed": 16},
	"6": {"proj_speed": 16, "atk_cd_redu": 0.1},
	
	"default": {"proj_speed": 0, "number": 0, "spread": 0, "atk_cd": 0},
}

var look_direction := Vector2.ZERO
var dash_direction := Vector2.ZERO
var velocity := Vector2.ZERO
var input_vector := Vector2.ZERO
var current_state: int = State.IDLE

var player_attack_data: AttackData = AttackData.new()

onready var dash_input_buffer := $DashInputBuffer
onready var dash_duration_timer := $DashDuration
onready var dash_cooldown_timer := $DashCooldown
onready var weapon_anchor := $Pivot/WeaponPivot/Anchor
onready var weapon_pivot := $Pivot/WeaponPivot
onready var weapon_sprite := $Pivot/WeaponPivot/Weapon

onready var attack_cooldown_timer := $AttackCooldown
onready var player_attack_projectile: ProjectileData = actor_data.attack.projectile_data

func _ready():
	._ready()
	
	$Pivot/WeaponPivot/AnimationPlayer.play(Globals.ANIM_IDLE)
	_update_weapon_color()
	
	var wave_s = get_tree().get_current_scene().get_node_or_null("World/WaveSpawner")
	if wave_s:
		wave_s.connect("wave_started", self, "_try_upgrade_player_attack")
	
	player_attack_data = actor_data.attack
	
	$BodyPaletteSwapper.change_palette(Globals.Colors.DEFAULT)

func _process(_delta):
	look_direction = (get_global_mouse_position() - body_pivot.global_position).normalized()
	
	if Input.is_action_pressed("action_dash"):
		dash_input_buffer.start()
	
	if (Input.is_action_just_pressed(Globals.ACTION_COLOR_SWAP_LEFT)):
		_cycle_color(-1)
	elif (Input.is_action_just_pressed(Globals.ACTION_COLOR_SWAP_RIGHT)):
		_cycle_color(1)
	
	_rotate_weapon()

func _physics_process(_delta):
	_get_input()

	match current_state:
		State.IDLE:
			if anim_player.current_animation != Globals.ANIM_IDLE:
				anim_player.play(Globals.ANIM_IDLE)
			
			_idle_logic()
			_try_attack()
			_try_dash()

			if input_vector != Vector2.ZERO:
				current_state = State.MOVE

		State.MOVE:
			if anim_player.current_animation != Globals.ANIM_MOVE:
				anim_player.play(Globals.ANIM_MOVE)
			
			_move_logic()
			_try_attack()
			_try_dash()

			if input_vector == Vector2.ZERO && velocity.length_squared() == 0:
				current_state = State.IDLE
		
		State.DASH:
			if anim_player.current_animation != Globals.ANIM_MOVE:
				anim_player.play(Globals.ANIM_MOVE)
			
			_flip(dash_direction.x)
			var _er = move_and_slide(dash_direction * DASH_SPEED)
			
			dash_cooldown_timer.start()
			if dash_duration_timer.is_stopped():
				current_state = State.MOVE

func _cycle_color(value: int):
	var index = current_color_index
	index += sign(value)
	
	if index > Globals.COLOR_COUNT - 1:
		index = 0
	elif (index < 0):
		index = Globals.COLOR_COUNT - 1
	
	current_color_index = index
	_update_weapon_color()

func _update_weapon_color():
	$WeaponPaletteSwapper.change_palette(current_color_index)
	emit_signal("wand_color_changed", current_color_index)

func attack(rotation_offset: float = 0):
	$CastSFX.play()
	
	var dir = (get_global_mouse_position() -
		$Pivot/WeaponPivot/Weapon/AttackPoint.global_position).normalized()
	var angle = dir.angle() + deg2rad(rotation_offset)
	dir = Globals.angle_to_vector(angle)
	
	attack_spawner.execute_attack(player_attack_data, dir,
		$Pivot/WeaponPivot/Weapon/AttackPoint.global_position,
		Globals.CollisionLayers.PlayerHitbox, current_color_index)
	
	_restart_timer()

func _spawn_dash_fade_shadow():
	var shadow = FADE_SHADOW.instance()
	get_parent().add_child(shadow)
	
	var sprite = $Pivot/BodyPivot/Body
	
	shadow.setup_sprite(sprite.texture, sprite.offset, sprite.global_position,
		body_pivot.scale, sprite.hframes, sprite.vframes, sprite.frame)
	shadow.start_fade(0.5, 0.25)

func _get_input():
	input_vector.x = Input.get_action_strength(Globals.ACTION_RIGHT) - Input.get_action_strength(Globals.ACTION_LEFT)
	input_vector.y = Input.get_action_strength(Globals.ACTION_DOWN) - Input.get_action_strength(Globals.ACTION_UP)
	input_vector = input_vector.normalized()

func _rotate_weapon():
	var direction = (get_global_mouse_position() - weapon_anchor.global_position).normalized()
	var weapon_position = weapon_anchor.position + direction * WEAPON_DISTANCE
	var weapon_rotation = Vector2.RIGHT.angle_to(direction)
	
	weapon_sprite.position = lerp(weapon_sprite.position, weapon_position, 0.5)
	weapon_sprite.rotation = lerp_angle(weapon_sprite.rotation, weapon_rotation, 0.2)
	
	Globals.flip(weapon_sprite, direction.x, Vector2.UP, 0.4)

func _restart_timer():
	attack_cooldown_timer.start()

func _idle_logic():
	_flip(look_direction.x)

func _move_logic():
	_flip(input_vector.x)
	
	if input_vector != Vector2.ZERO:
		velocity = velocity.move_toward(input_vector * actor_data.max_speed,
			actor_data.acceleration * get_physics_process_delta_time())
	else:
		velocity = velocity.move_toward(Vector2.ZERO, actor_data.friction
			* get_physics_process_delta_time())
	
	velocity = move_and_slide(velocity)

func _try_dash():
	if (!dash_input_buffer.is_stopped() && dash_cooldown_timer.is_stopped()
			&& dash_duration_timer.is_stopped()):
				
		dash_direction = input_vector
		if dash_direction == Vector2.ZERO:
			dash_direction = Vector2(sign(body_pivot.scale.x), 0)
		
		dash_duration_timer.start()
		_spawn_dash_fade_shadow()
		$DashFadeShadowCD.start()
		
		$DashSFX.play()
		$InvincibilityTimer.start(dash_duration_timer.wait_time)
		
		current_state = State.DASH

func _try_attack():
	if (Input.is_action_pressed(Globals.ACTION_ATTACK_1)
			&& attack_cooldown_timer.is_stopped()):
		attack()

func _try_upgrade_player_attack(wave, _total):
	if WAVE_ATTACK_UPGRADES.has(str(wave)):
		var dict = WAVE_ATTACK_UPGRADES.get(str(wave))
		
		if dict.has("proj_speed"):
			player_attack_data.projectile_data.speed += dict["proj_speed"]
		
		if dict.has("number"):
			player_attack_data.number_of_projectiles += dict["number"]
		
		if dict.has("spread"):
			player_attack_data.spread += dict["spread"]
		
		if dict.has("atk_cd_redu"):
			var atk_cd = $AttackCooldown
			atk_cd.wait_time = max(atk_cd.wait_time - dict["atk_cd_redu"], 0.1)
		
		emit_signal("magic_upgraded")

func _on_Health_changed(current_health):
	if !visible:
		return
	
	emit_signal("damaged", current_health)
	play_sfx(Globals.random_sfx_from_array(HURT_SFX))
	
	if current_health <= 0:
		pause_mode = PAUSE_MODE_STOP
		$Hurtbox/CollisionShape2D.set_deferred("disabled", true)
		visible = false
		_play_death_particles(Vector2(0, -8))
		is_dead = true
		emit_signal("died")
		
		var cam = $Camera2D
		if cam:
			remove_child(cam)
			get_parent().add_child(cam)
			cam.global_position = global_position
		
		yield(get_tree().create_timer(0.5), "timeout")
		queue_free()
	else:
		Globals.blink_white($BodyPaletteSwapper)

func _on_DashFadeShadowCD_timeout():
	_spawn_dash_fade_shadow()
	if !dash_duration_timer.is_stopped():
		$DashFadeShadowCD.start()
