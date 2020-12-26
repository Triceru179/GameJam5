extends KinematicBody2D

const ACCELERATION = 500
const MAX_SPEED = 100
const FRICTION = 500
const PROJECTILE_SCENE = preload("res://projectile/Projectile.tscn") 

onready var project_pivot = $ProjectPivot
onready var timer = $Timer

export (int) var speed = 200

var velocity = Vector2.ZERO

func get_input():
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * get_physics_process_delta_time())
	else:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * get_physics_process_delta_time())

func _physics_process(_delta):
	get_input()
	attack()

	velocity = move_and_slide(velocity)

func attack():
	if Input.is_action_just_pressed("ui_accept"):
		if timer.is_stopped():
			create_projectile()
			restart_timer()

func create_projectile():
	var projectile = PROJECTILE_SCENE.instance()
	get_parent().add_child(projectile)
	projectile.position = project_pivot.global_position

func restart_timer():
	timer.set_wait_time(.5)
	timer.start()

func _on_Timer_timeout():
	timer.stop()
