extends Area2D

export(int) var projectile_speed = 200

var velocity = Vector2.ZERO


func _physics_process(delta):
	velocity.x = 1
	velocity.y = 0
	velocity *= projectile_speed
	position += velocity * delta


func _on_VisibilityNotifier2D_screen_exited():
	print("left")
	queue_free()
	
