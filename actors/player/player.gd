extends Actor

enum State {
	IDLE = 0,
	WALK = 1,
}

const PROJECTILE_SCENE = preload("res://projectile/Projectile.tscn") 

var look_direction := Vector2.ZERO
var attack_direction := Vector2.ZERO
var velocity := Vector2.ZERO
var input_vector := Vector2.ZERO
var current_state: int = State.IDLE

onready var weapon_pivot := $Pivot/WeaponPivot
onready var weapon_sprite := $Pivot/WeaponPivot/Weapon
onready var attack_point := $Pivot/WeaponPivot/Weapon/AttackPoint
onready var attack_cooldown_timer := $AttackCooldown

func _process(_delta):
	_update_look_direction()
	
	if (Input.is_action_pressed(Globals.ACTION_ATTACK_1)
			&& attack_cooldown_timer.is_stopped()):
		_attack()

func _physics_process(delta):
	_get_input()
	
	match current_state:
		State.IDLE:
			_idle_logic()
			
			if input_vector != Vector2.ZERO:
				current_state = State.WALK
		
		State.WALK:
			_walk_logic()
			
			if velocity.length_squared() == 0:
				current_state = State.IDLE
	
	velocity = move_and_slide(velocity)

func _attack():
	_create_projectile()
	_restart_timer()

func _update_look_direction():
	look_direction = (get_global_mouse_position() - $Pivot.global_position).normalized()
	_rotate_weapon(look_direction)

func _get_input():
	input_vector.x = Input.get_action_strength(Globals.ACTION_RIGHT) - Input.get_action_strength(Globals.ACTION_LEFT)
	input_vector.y = Input.get_action_strength(Globals.ACTION_DOWN) - Input.get_action_strength(Globals.ACTION_UP)
	input_vector = input_vector.normalized()

func _create_projectile():
	var projectile = PROJECTILE_SCENE.instance()
	projectile.setup_projectile(attack_direction)
	
	get_parent().add_child(projectile)
	projectile.position = attack_point.global_position

func _rotate_weapon(direction: Vector2):
	var weapon_rotation = Vector2.RIGHT.angle_to(direction)
	
	weapon_pivot.rotation = lerp_angle(weapon_pivot.rotation, weapon_rotation, 0.2)
	weapon_sprite.rotation = -weapon_pivot.rotation
	
	attack_direction = (get_global_mouse_position() - attack_point.global_position).normalized()

func _restart_timer():
	attack_cooldown_timer.start()

func _idle_logic():
	if anim_player.current_animation != Globals.ANIM_IDLE:
		anim_player.play(Globals.ANIM_IDLE)
	
	_flip(look_direction.x)

func _walk_logic():
	if anim_player.current_animation != Globals.ANIM_WALK:
		anim_player.play(Globals.ANIM_WALK)
	
	_flip(velocity.x)
	
	if input_vector != Vector2.ZERO:
		velocity = velocity.move_toward(input_vector * actor_data.max_speed,
			actor_data.acceleration * get_physics_process_delta_time())
	else:
		velocity = velocity.move_toward(Vector2.ZERO, actor_data.friction
			* get_physics_process_delta_time())
