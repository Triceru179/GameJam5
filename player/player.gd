extends KinematicBody2D

const ACCELERATION = 500
const MAX_SPEED = 100
const FRICTION = 500
const PROJECTILE_SCENE = preload("res://projectile/Projectile.tscn") 

export(int) var speed = 200

var velocity := Vector2.ZERO
var input_vector := Vector2.ZERO

var wand_direction := Vector2.ZERO

onready var cast_point := $Pivot/WandPivot/Wand/CastPoint
onready var wand_pivot := $Pivot/WandPivot
onready var attack_cooldown_timer := $AttackCooldown

func _process(_delta):
	_update_wand()

func _physics_process(_delta):
	_get_input()
	
	if (Input.is_action_just_pressed(Globals.ACTION_ATTACK_1)
			&& attack_cooldown_timer.is_stopped()):
		_attack()
	
	velocity = move_and_slide(velocity)

func _attack():
	_create_projectile()
	_restart_timer()

func _create_projectile():
	var projectile = PROJECTILE_SCENE.instance()
	projectile.setup_projectile(wand_direction)
	
	get_parent().add_child(projectile)
	projectile.position = cast_point.global_position

func _restart_timer():
	attack_cooldown_timer.start()

func _update_wand():
	wand_direction = (get_global_mouse_position() - wand_pivot.global_position).normalized()
	wand_pivot.rotation = Vector2.RIGHT.angle_to(wand_direction)

func _get_input():
	input_vector.x = Input.get_action_strength(Globals.ACTION_RIGHT) - Input.get_action_strength(Globals.ACTION_LEFT)
	input_vector.y = Input.get_action_strength(Globals.ACTION_DOWN) - Input.get_action_strength(Globals.ACTION_UP)
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * get_physics_process_delta_time())
	else:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * get_physics_process_delta_time())
