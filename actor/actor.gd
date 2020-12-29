extends KinematicBody2D
class_name Actor

onready var body_pivot := $Pivot/BodyPivot

func _flip(value):
	if value != 0:
		body_pivot.scale.x = lerp(body_pivot.scale.x, sign(value), 0.3)
