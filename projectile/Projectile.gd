extends Area2D

var dir := Vector2.ZERO
var data: ProjectileData = null

func _physics_process(delta):
	position += dir * data.speed * delta

func setup_projectile(direction: Vector2 = Vector2.ZERO,
		projectile_data: ProjectileData = null):
	dir = direction
	data = projectile_data

func _on_VisibilityNotifier2D_screen_exited():
	print("Projectile destroyed!")
	queue_free()
