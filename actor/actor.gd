extends KinematicBody2D
class_name Actor

onready var body := $Pivot/Body

func _flip(value):
	if value != 0:
		body.scale.x = lerp(body.scale.x, sign(value), 0.3)
