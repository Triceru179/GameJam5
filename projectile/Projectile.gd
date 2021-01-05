extends YSort
class_name Projectile

signal destroyed(projectile)

var dir := Vector2.ZERO
var data: ProjectileData = null
var color_i := 0

onready var sprite := $Sprite
onready var default_collision_mask = $Hitbox.collision_mask

func _ready():
	$AnimationPlayer.play(Globals.ANIM_IDLE)

func _physics_process(delta):
	if !data:
		return
	
	position += dir * data.speed * delta
	sprite.rotation_degrees += data.rotation_speed * delta

func setup_projectile(projectile_data: ProjectileData,
		direction: Vector2, collision_layer: int, color_index: int = 0):
	dir = direction
	data = projectile_data
	sprite.texture = data.texture
	
	$Hitbox/CollisionShape2D.shape.radius = data.hitbox_radius
	$Hitbox/CollisionShape2D.disabled = false
	$Hitbox.set_collision_layer_bit(collision_layer, true)
	
	color_i = color_index
	$PaletteSwapper.change_palette(color_index)

func destroy_projectile():
	$AnimationPlayer.play(Globals.ANIM_DEATH)
	yield($AnimationPlayer, "animation_finished")
	
	queue_free()

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

func _on_Hitbox_body_entered(_body):
	destroy_projectile()
