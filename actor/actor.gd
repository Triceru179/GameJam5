extends KinematicBody2D
class_name Actor

onready var body := $Pivot/Body
onready var cast_point := $Pivot/WandPivot/Wand/CastPoint
onready var wand_pivot := $Pivot/WandPivot
onready var wand_sprite := $Pivot/WandPivot/Wand

var cast_direction := Vector2.ZERO

func _flip(value):
	if value != 0:
		body.scale.x = lerp(body.scale.x, sign(value), 0.3)

func _rotate_weapon(direction: Vector2):
	var wand_rotation = Vector2.RIGHT.angle_to(direction)
	
	wand_pivot.rotation = lerp_angle(wand_pivot.rotation, wand_rotation, 0.2)
	wand_sprite.rotation = -wand_pivot.rotation
	
	cast_direction = (get_global_mouse_position() - cast_point.global_position).normalized()
