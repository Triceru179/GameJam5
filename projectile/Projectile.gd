extends Area2D

export(int) var projectile_speed = 128

var direction := Vector2.ZERO

func _physics_process(delta):
	position += direction * projectile_speed * delta

func setup_projectile(direction: Vector2):
	self.direction = direction

func _on_VisibilityNotifier2D_screen_exited():
	print("Projectile destroyed!")
	queue_free()
