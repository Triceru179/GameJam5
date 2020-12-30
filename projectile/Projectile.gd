extends Area2D

var dir := Vector2.ZERO
var data: ProjectileData = null

onready var lifetime_timer := $Lifetime

func _physics_process(delta):
	position += dir * data.speed * delta

func setup_projectile(direction: Vector2,
		projectile_data: ProjectileData):
	dir = direction
	data = projectile_data

func _destroy_projectile():
	print("Projectile destroyed!")
	queue_free()

func _on_VisibilityNotifier2D_screen_exited():
	_destroy_projectile()
