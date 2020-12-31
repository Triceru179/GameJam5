extends KinematicBody2D
class_name Actor

export(Resource) var actor_data = null

var current_color_index = 0

onready var body_pivot := $Pivot/BodyPivot
onready var anim_player := $AnimationPlayer

func _flip(value: float):
	Globals.flip(body_pivot, value, Vector2.RIGHT, 0.7)
