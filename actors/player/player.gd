extends Actor

enum State {
	IDLE,
	MOVE,
	STAGGER,
}

const PROJECTILE_SCENE = preload("res://projectile/Projectile.tscn")
const WEAPON_DISTANCE = 13

export(Resource) var current_projectile_data = null

var look_direction := Vector2.ZERO
var velocity := Vector2.ZERO
var input_vector := Vector2.ZERO
var current_state: int = State.IDLE

onready var weapon_anchor := $Pivot/WeaponPivot/Anchor
onready var weapon_pivot := $Pivot/WeaponPivot
onready var weapon_sprite := $Pivot/WeaponPivot/Weapon
onready var attack_cooldown_timer := $AttackCooldown

func _ready():
	$Pivot/WeaponPivot/AnimationPlayer.play(Globals.ANIM_IDLE)
	_update_weapon_color()

func _process(_delta):
	if (Input.is_action_just_pressed(Globals.ACTION_COLOR_SWAP_LEFT)):
		_cycle_color(-1)
	elif (Input.is_action_just_pressed(Globals.ACTION_COLOR_SWAP_RIGHT)):
		_cycle_color(1)
	
	_update_look_direction()
	_rotate_weapon()
	
	if (Input.is_action_pressed(Globals.ACTION_ATTACK_1)
			&& attack_cooldown_timer.is_stopped()):
		_attack()

func _physics_process(_delta):
	_get_input()

	match current_state:
		State.IDLE:
			if anim_player.current_animation != Globals.ANIM_IDLE:
				anim_player.play(Globals.ANIM_IDLE)
			
			_idle_logic()

			if input_vector != Vector2.ZERO:
				current_state = State.MOVE

		State.MOVE:
			if anim_player.current_animation != Globals.ANIM_WALK:
				anim_player.play(Globals.ANIM_WALK)
			
			_move_logic()

			if velocity.length_squared() == 0:
				current_state = State.IDLE

	velocity = move_and_slide(velocity)

func _cycle_color(value: int):
	var index = current_color_index
	index += sign(value)
	
	print(index)
	
	if index > Globals.COLOR_COUNT - 1:
		index = 0
	elif (index < 0):
		index = Globals.COLOR_COUNT - 1
	
	current_color_index = index
	_update_weapon_color()

func _update_weapon_color():
	$WeaponPaletteSwapper.change_palette(current_color_index)

func _attack():
	_create_projectile()
	_restart_timer()

func _update_look_direction():
	look_direction = (get_global_mouse_position() - body_pivot.global_position).normalized()

func _get_input():
	input_vector.x = Input.get_action_strength(Globals.ACTION_RIGHT) - Input.get_action_strength(Globals.ACTION_LEFT)
	input_vector.y = Input.get_action_strength(Globals.ACTION_DOWN) - Input.get_action_strength(Globals.ACTION_UP)
	input_vector = input_vector.normalized()

func _create_projectile():
	var projectile = PROJECTILE_SCENE.instance()
	var attack_direction = ((get_global_mouse_position()
		- $Pivot/WeaponPivot/Weapon/AttackPoint.global_position).normalized())
	
	projectile.setup_projectile(attack_direction, current_projectile_data)
	
	get_parent().add_child(projectile)
	projectile.position = $Pivot/WeaponPivot/Weapon/AttackPoint.global_position

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
	_flip(velocity.x)
	
	if input_vector != Vector2.ZERO:
		velocity = velocity.move_toward(input_vector * actor_data.max_speed,
			actor_data.acceleration * get_physics_process_delta_time())
	else:
		velocity = velocity.move_toward(Vector2.ZERO, actor_data.friction
			* get_physics_process_delta_time())
