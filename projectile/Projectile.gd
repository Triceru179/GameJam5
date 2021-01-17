extends YSort
class_name Projectile

signal destroyed(projectile)

const PLAYER_MASK = 1 + 32 + 512
const ENEMY_MASK = 1 + 32 + 128

var dir := Vector2.ZERO
var data: ProjectileData = null
var color_i := 0

var destroyed := false

onready var sprite := $Sprite
onready var default_collision_mask = $Hitbox.collision_mask

func _ready():
	$AnimationPlayer.play(Globals.ANIM_IDLE)
	$TimeTilDestroy.start()

func _physics_process(delta):
	move()

func move():
	position += dir * data.speed * get_physics_process_delta_time()
	sprite.rotation_degrees += data.rotation_speed * get_physics_process_delta_time()

func setup_projectile(projectile_data: ProjectileData,
		direction: Vector2, is_enemy_projectile: bool, color_index: int = 0):
	dir = direction
	data = projectile_data
	sprite.texture = data.texture
	
	$AnimationPlayer.play(Globals.ANIM_IDLE)

	destroyed = false
	$Hitbox/CollisionShape2D.shape.radius = data.hitbox_radius
	$Hitbox.collision_mask = ENEMY_MASK if is_enemy_projectile else PLAYER_MASK
	
	color_i = color_index
	$PaletteSwapper.change_palette(color_index)

func destroy_projectile():
	if destroyed:
		return
	
	dir = Vector2.ZERO
	destroyed = true
	$AnimationPlayer.play(Globals.ANIM_DEATH)

func _on_Hitbox_body_entered(_body):
	destroy_projectile()

func _on_Hitbox_area_entered(area):
	if destroyed:
		return
	
	var actor = area.get_parent()
	if actor && actor.has_method("try_damaging"):
		actor.try_damaging(self)

func _on_TimeTilDestroy_timeout():
	destroy_projectile()

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == Globals.ANIM_DEATH:
		emit_signal("destroyed", self)
		queue_free()
