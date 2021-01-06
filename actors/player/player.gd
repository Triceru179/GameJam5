extends Actor

signal wand_color_changed(color_index)
signal damaged(current_health)

enum State {
	IDLE,
	MOVE,
	DASH,
}

const COLOR_DEFAULT = Color(1.0, 1.0, 1.0, 1.0)
const COLOR_TRASPARENT = Color(1.0, 1.0, 1.0, 0.5)
const WEAPON_DISTANCE = 13
const DASH_SPEED = 252

var look_direction := Vector2.ZERO
var dash_direction := Vector2.ZERO
var velocity := Vector2.ZERO
var input_vector := Vector2.ZERO
var current_state: int = State.IDLE

onready var dash_input_buffer := $DashInputBuffer
onready var dash_duration_timer := $DashDuration
onready var dash_cooldown_timer := $DashCooldown
onready var weapon_anchor := $Pivot/WeaponPivot/Anchor
onready var weapon_pivot := $Pivot/WeaponPivot
onready var weapon_sprite := $Pivot/WeaponPivot/Weapon
onready var attack_cooldown_timer := $AttackCooldown

func _ready():
	._ready()
	$Pivot/WeaponPivot/AnimationPlayer.play(Globals.ANIM_IDLE)
	_update_weapon_color()
	
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
	_try_dash()

func _physics_process(_delta):
	_get_input()

	match current_state:
		State.IDLE:
			if anim_player.current_animation != Globals.ANIM_IDLE:
				anim_player.play(Globals.ANIM_IDLE)
			
			_idle_logic()
			_try_attack()

			if input_vector != Vector2.ZERO:
				current_state = State.MOVE

		State.MOVE:
			if anim_player.current_animation != Globals.ANIM_WALK:
				anim_player.play(Globals.ANIM_WALK)
			
			_move_logic()
			_try_attack()

			if velocity.length_squared() == 0:
				current_state = State.IDLE
		
		State.DASH:
			_flip(dash_direction.x)
			move_and_slide(dash_direction * DASH_SPEED)
			
			dash_cooldown_timer.start()
			if dash_duration_timer.is_stopped():
				current_state = State.MOVE
				$Pivot.modulate = COLOR_DEFAULT

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
	var dir = (get_global_mouse_position() -
		$Pivot/WeaponPivot/Weapon/AttackPoint.global_position).normalized()
	var angle = dir.angle() + deg2rad(rotation_offset)
	dir = Globals.angle_to_vector(angle)
	
	attack_spawner.execute_attack(actor_data.attack, dir,
		$Pivot/WeaponPivot/Weapon/AttackPoint.global_position,
		Globals.CollisionLayers.PlayerHitbox, current_color_index)
	
	_restart_timer()

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
				
		dash_direction = look_direction
		if dash_direction == Vector2.ZERO:
			dash_direction = Vector2(sign(body_pivot.scale.x), 0)
		
		$Pivot.modulate = COLOR_TRASPARENT
		
		dash_duration_timer.start()
		$InvincibilityTimer.start(dash_duration_timer.wait_time)
		
		current_state = State.DASH

func _try_attack():
	if (Input.is_action_pressed(Globals.ACTION_ATTACK_1)
			&& attack_cooldown_timer.is_stopped()):
		attack()

func _on_Health_changed(current_health):
	emit_signal("damaged", current_health)
	
	if current_health <= 0:
		set_process(false)
		set_physics_process(false)
		$Hurtbox.monitoring = false
		visible = false
		
		yield(get_tree().create_timer(2), "timeout")
		get_tree().reload_current_scene()
	else:
		Globals.blink_white($BodyPaletteSwapper)
