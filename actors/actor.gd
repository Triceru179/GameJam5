extends KinematicBody2D
class_name Actor

export(Resource) var actor_data = null

onready var body_pivot := $Pivot/BodyPivot
onready var anim_player := $AnimationPlayer

func _flip(value):
	if value != 0:
		body_pivot.scale.x = lerp(body_pivot.scale.x, sign(value), 0.3)
