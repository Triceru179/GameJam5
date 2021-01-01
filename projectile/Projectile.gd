extends Area2D
class_name Projectile

var dir := Vector2.ZERO
var data: ProjectileData = null

onready var sprite := $AnimatedSprite

func _physics_process(delta):
	position += dir * data.speed * delta
	sprite.rotation_degrees += data.rotation_speed * delta

func setup_projectile(projectile_data: ProjectileData,
		direction: Vector2, collision_layer: int):
	dir = direction
	data = projectile_data
	set_collision_layer_bit(collision_layer, true)

func destroy_projectile():
	queue_free()

func _on_VisibilityNotifier2D_screen_exited():
	destroy_projectile()
