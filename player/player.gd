extends Actor

const ACCELERATION = 1024
const MAX_SPEED = 128
const FRICTION = 512
const PROJECTILE_SCENE = preload("res://projectile/Projectile.tscn") 

export(int) var speed = 200

var velocity := Vector2.ZERO
var input_vector := Vector2.ZERO

onready var attack_cooldown_timer := $AttackCooldown


func _process(_delta):
	_update_look_direction()
	
	if (Input.is_action_pressed(Globals.ACTION_ATTACK_1)
			&& attack_cooldown_timer.is_stopped()):
		_attack()

func _physics_process(delta):
	_get_input()
	
	if input_vector != Vector2.ZERO:
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	
	velocity = move_and_slide(velocity)

func _attack():
	_create_projectile()
	_restart_timer()

func _update_look_direction():
	var mouse_direction = (get_global_mouse_position() - $Pivot.global_position).normalized()
	
	_rotate_weapon(mouse_direction)
	_flip(mouse_direction.x)

func _get_input():
	input_vector.x = Input.get_action_strength(Globals.ACTION_RIGHT) - Input.get_action_strength(Globals.ACTION_LEFT)
	input_vector.y = Input.get_action_strength(Globals.ACTION_DOWN) - Input.get_action_strength(Globals.ACTION_UP)
	input_vector = input_vector.normalized()

func _create_projectile():
	var projectile = PROJECTILE_SCENE.instance()
	projectile.setup_projectile(cast_direction)
	
	get_parent().add_child(projectile)
	projectile.position = cast_point.global_position

func _restart_timer():
	attack_cooldown_timer.start()
